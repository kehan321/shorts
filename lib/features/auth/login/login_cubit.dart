import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shorts/domain/repositories/network/network_base_api_service.dart';
import 'package:shorts/features/feed_screen/feed_screen_initial_params.dart';

import '/core/show/show/show.dart';
import '/domain/usecases/auth/login/login_use_cases.dart';
import 'login_initial_params.dart';
import 'login_navigator.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginInitialParams initialParams;
  final UserUseCases useCases;
  final NetworkBaseApiService networkRepository;
  final LoginNavigator navigator;
  final Show show;

  LoginCubit(
    this.initialParams,
    this.networkRepository,
    this.useCases,
    this.navigator,
    this.show,
  ) : super(LoginState.initial(initialParams: initialParams));

  Future<void> postLogin({
    required String username,
    required String password,
  }) async {
    emit(state.copyWith(isLoading: true));
    final login = await networkRepository.post<Map<String, dynamic>>(
      url: "https://dummyjson.com/auth/login",
      body: {
        'username': username.trim(),
        'password': password,
        'expiresInMins': 30,
      },
    );
    login.fold(
      (l) {
        emit(state.copyWith(isLoading: false));
        return show.showErrorSnackBar(l.error);
      },
      (userData) => useCases
          .execute(userData: userData)
          .then(
            (value) => value.fold(
              (l) {
                emit(state.copyWith(isLoading: false));
                return show.showErrorSnackBar(l.error);
              },
              ((r) {
                emit(state.copyWith(isLoading: false));
                return navigator.openFeedScreen(
                  const FeedScreenInitialParams(),
                );
              }),
            ),
          ),
    );
  }
}
