import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

import '/core/utils/app_url.dart';
import '/data/datasources/auth/user_data_sources.dart';
import '/domain/repositories/local/local_storage_base_api_service.dart';

class DioConfig {
  static Dio createDio({
    required UserDataSources userDataSources,
    required LocalStorageRepository localStorageRepository,
    void Function()? onSessionCleared,
  }) {
    final dio = Dio();

    // Base configuration
    dio.options = BaseOptions(
      // connectTimeout: const Duration(seconds: 30),
      // receiveTimeout: const Duration(seconds: 30),
      // sendTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
      // validateStatus: (status) => status != null && status < 500,
    );

    // Add interceptors in order
    dio.interceptors.addAll([
      InterceptorsWrapper(
        userDataSources,
        localStorageRepository,
        onSessionCleared,
      ),
      TalkerDioLogger(
        settings: TalkerDioLoggerSettings(
          printRequestHeaders: true,
          printErrorHeaders: false,
          printErrorMessage: false,
        ),
      ),
      // LoggingInterceptor(),
    ]);

    return dio;
  }
}

// Enhanced Authentication Interceptor
class InterceptorsWrapper extends Interceptor {
  final UserDataSources _userDataSources;
  final LocalStorageRepository _localStorageRepository;
  final void Function()? _onSessionCleared;
  bool _didClearSession = false;

  InterceptorsWrapper(
    this._userDataSources,
    this._localStorageRepository,
    this._onSessionCleared,
  );

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Once session is invalidated, stop protected requests to prevent 401 spam.
    if (_didClearSession) {
      options.headers.remove('Authorization');
      if (_isPublicRequest(options)) {
        return handler.next(options);
      }
      return handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.cancel,
          message: 'Session expired. Protected request blocked.',
        ),
      );
    }
    final token = _userDataSources.state.accessToken;
    if (token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    return handler.next(response);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      if (_didClearSession) {
        return handler.next(err);
      }

      // Never attempt a refresh when refresh endpoint itself is unauthorized.
      if (_isRefreshRequest(err.requestOptions)) {
        await _clearSessionOnce(
          reason: '[Auth] Refresh endpoint unauthorized, clearing session',
        );
        return handler.next(err);
      }

      try {
        final refreshed = await _attemptTokenRefresh(
          _userDataSources,
          _localStorageRepository,
        );
        if (refreshed) {
          err.requestOptions.headers['Authorization'] =
              'Bearer ${_userDataSources.state.accessToken}';
          final retriedResponse = await Dio().fetch(err.requestOptions);
          return handler.resolve(retriedResponse);
        }
        // Refresh failed (401, no token, or error): clear session so app can show login
        await _clearSessionOnce(
          reason:
              '[Auth] Session cleared (refresh failed), triggering navigate to login',
        );
      } catch (e) {
        log('Token refresh failed: $e');
        await _clearSessionOnce(
          reason:
              '[Auth] Session cleared (refresh error), triggering navigate to login',
        );
      }
    }
    return handler.next(err);
  }

  Future<void> _clearSessionOnce({required String reason}) async {
    if (_didClearSession) return;
    _didClearSession = true;
    await _localStorageRepository.removeUserData();
    _userDataSources.clearUserData();
    log(reason);
    _onSessionCleared?.call();
  }
}

bool _isRefreshRequest(RequestOptions requestOptions) {
  final path = requestOptions.path.toLowerCase();
  return path.contains('/auth/refresh');
}

bool _isPublicRequest(RequestOptions requestOptions) {
  final path = requestOptions.path.toLowerCase();
  return path.contains('/auth/login') ||
      path.contains('/auth/register') ||
      path.contains('/auth/refresh') ||
      path.contains('/auth/forgot-password') ||
      path.contains('/auth/reset-password-with-token') ||
      path.contains('/auth/verify-reset-otp') ||
      path.contains('/forgotpassword');
}

/// Only one refresh runs at a time; concurrent 401s wait for it and then retry with new token.
Future<bool>? _refreshInProgress;

Future<bool> _attemptTokenRefresh(
  UserDataSources userDataSources,
  LocalStorageRepository localStorageRepository,
) async {
  if (_refreshInProgress != null) {
    return _refreshInProgress!;
  }
  final completer = Completer<bool>();
  _refreshInProgress = completer.future;
  try {
    final ok = await _doTokenRefresh(userDataSources, localStorageRepository);
    completer.complete(ok);
    return ok;
  } catch (e) {
    completer.complete(false);
    return false;
  } finally {
    _refreshInProgress = null;
  }
}

/// Performs token refresh and updates storage. Returns true if new tokens were saved.
Future<bool> _doTokenRefresh(
  UserDataSources userDataSources,
  LocalStorageRepository localStorageRepository,
) async {
  final refreshToken = userDataSources.state.refreshToken;
  if (refreshToken.isEmpty) {
    log('[Token Refresh] No refresh token available');
    return false;
  }

  try {
    // Don't throw on 4xx so we can handle 401 (e.g. expired refresh) without DioException
    final refreshDio = Dio();
    refreshDio.options.validateStatus = (status) =>
        status != null && status < 500;

    log('[Token Refresh] Calling refresh endpoint...');
    log('AppUrl.refreshToken: ${AppUrl.refreshToken}');
    final refreshResponse = await refreshDio.post(
      AppUrl.refreshToken,
      data: {'refreshToken': refreshToken},
      options: Options(headers: {'Content-Type': 'application/json'}),
    );

    if (refreshResponse.statusCode == 200) {
      // API returns only { "accessToken", "refreshToken" } per /api/auth/refresh
      final Map<String, dynamic> newTokensJson =
          refreshResponse.data as Map<String, dynamic>;
      log('[Token Refresh] SUCCESS - response data: $newTokensJson');
      // ignore: avoid_print
      print('[Token Refresh] SUCCESS - new tokens received');

      final newAccessToken = newTokensJson['accessToken']?.toString() ?? '';
      final newRefreshToken = newTokensJson['refreshToken']?.toString() ?? '';
      if (newAccessToken.isEmpty) {
        log('[Token Refresh] Response 200 but accessToken empty');
        return false;
      }

      // Merge new tokens with existing user (refresh API does not return user)
      final current = userDataSources.state;
      final mergedUserData = current.copyWith(
        accessToken: newAccessToken,
        refreshToken: newRefreshToken.isNotEmpty
            ? newRefreshToken
            : current.refreshToken,
      );

      final saveResult = await localStorageRepository.setUserData(
        userInfoStoreModel: mergedUserData,
      );
      saveResult.fold(
        (l) => log('[Token Refresh] Failed to save user data: $l'),
        (r) => userDataSources.setUserDataSources(
          userInfoStoreModel: mergedUserData,
        ),
      );
      return true;
    } else {
      log(
        '[Token Refresh] Rejected (${refreshResponse.statusCode}): '
        '${refreshResponse.data ?? "no body"}',
      );
      return false;
    }
  } catch (e, stackTrace) {
    log('Token refresh error: $e', error: e, stackTrace: stackTrace);
    return false;
  }
}

// // Logging Interceptor (for debugging)
// class LoggingInterceptor extends Interceptor {
//   @override
//   void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
//     AppPrint.success('🌐 REQUEST[${options.method}] => PATH: ${options.uri}');
//     AppPrint.info('📤 Headers: ${options.headers}');
//     if (options.data != null) {
//       AppPrint.success('📦 Body: ${options.data}');
//     }
//     handler.next(options);
//   }

//   @override
//   void onResponse(Response response, ResponseInterceptorHandler handler) {
//     AppPrint.success(
//       '✅ RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.uri}',
//     );
//     AppPrint.json('📥 Data: ${response.data}');
//     handler.next(response);
//   }

//   @override
//   void onError(DioException err, ErrorInterceptorHandler handler) {
//     AppPrint.error(
//       '❌ ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.uri}',
//     );
//     AppPrint.error('💥 Message: ${err.message}');
//     if (err.response != null) {
//       AppPrint.error('📛 Response: ${err.response?.data}');
//     }
//     handler.next(err);
//   }
// }
