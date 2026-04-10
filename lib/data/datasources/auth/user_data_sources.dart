import 'package:flutter_bloc/flutter_bloc.dart';

import '/data/models/user/user_info_store_model.dart';
import '/injection_container.dart';

/// User Data Source - Manages current user information throughout the app
/// This is a singleton Cubit that holds the current user's data
class UserDataSources extends Cubit<UserInfoStoreModel> {
  UserDataSources() : super(UserInfoStoreModel.empty().copyWith());

  /// Update user data
  void setUserDataSources({required UserInfoStoreModel userInfoStoreModel}) =>
      emit(userInfoStoreModel);

  /// Get current user
  User? get currentUser => state.user;

  /// Get user email
  /// 
  String get userEmail => state.user?.email ?? '';

  /// Get user name
  String get userName => state.user?.name ?? '';

  /// Get user ID
  String get userId => state.user?.id ?? '';

  /// Get access token
  String get accessToken => state.accessToken;

  /// Get refresh token
  String get refreshToken => state.refreshToken;

  /// Check if user is logged in
  bool get isLoggedIn => state.accessToken.isNotEmpty && state.user != null;

  /// Check if user has active subscription
  bool get hasActiveSubscription {
    final user = state.user;
    if (user == null) return false;
    return user.subscriptionStatus == 'active' &&
        (user.subscriptionEndDate == null ||
            user.subscriptionEndDate!.isAfter(DateTime.now()));
  }

  /// Clear user data (logout)
  void clearUserData() {
    emit(UserInfoStoreModel.empty().copyWith());
  }
}

/// Global helper to access UserDataSources instance
/// Use this instead of getIt<UserDataSources>() throughout the app
UserDataSources get userDataSource => getIt<UserDataSources>();
