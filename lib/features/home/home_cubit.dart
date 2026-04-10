import 'package:flutter_bloc/flutter_bloc.dart';

import '/config/response/api_response.dart';
import '/data/models/home_model.dart';
import '/domain/repositories/network/network_base_api_service.dart';
import 'home_initial_params.dart';
import 'home_navigator.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final NetworkBaseApiService networkRepository;
  final HomeNavigator navigator;
  final HomeInitialParams initialParams;
  HomeCubit(this.initialParams, this.networkRepository, this.navigator)
    : super(HomeState.initial(initialParams: initialParams));

  Future<void> home() async {
    emit(state.copyWith(response: ApiResponse.loading()));
    final home = await networkRepository.get<List<dynamic>>(
      url: "https://picsum.photos/v2/list?limit=20",
    );
    home.fold(
      (l) => emit(state.copyWith(response: ApiResponse.error(l.error))),
      ((r) {
        final user = r
            .map((e) => HomeModel.fromJson(e as Map<String, dynamic>))
            .toList();
        emit(state.copyWith(response: ApiResponse.completed(user)));
      }),
    );
  }
}
