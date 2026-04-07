import 'package:flutter_bloc/flutter_bloc.dart';
import '/data/models/auth/login_model.dart';
import '/features/video_player/video_player_initial_params.dart';
import 'login_initial_params.dart';
import 'login_navigator.dart';
import 'login_state.dart';
import '/domain/usecases/auth/login/login_use_cases.dart';
import '/core/show/show/show.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginInitialParams initialParams;
  final LoginUseCases useCases;
  final LoginNavigator navigator;
    final Show show;

  LoginCubit(this.initialParams, this.useCases, this.navigator, this.show)
      : super(LoginState.initial(initialParams: initialParams));

  void postLogin({required LoginModel body}) {
    emit(state.copyWith(isLoading: true));
    useCases.execute(body: body.toJson()).then((value) => value
            .fold((l) {
               emit(state.copyWith(isLoading: false));
              return show.showErrorSnackBar(l.error);
            },
                ((r) {
          emit(state.copyWith(isLoading: false));
          return navigator.openVideoPlayer(const VideoPlayerInitialParams());
        })));
  }
}
