import 'package:flutter_bloc/flutter_bloc.dart';

import '/config/response/api_response.dart';
import '/core/utils/app_url.dart';
import '/data/models/fetching_model.dart';
import '/domain/repositories/network/network_base_api_service.dart';
import 'fetching_initial_params.dart';
import 'fetching_navigator.dart';
import 'fetching_state.dart';

class FetchingCubit extends Cubit<FetchingState> {
  final NetworkBaseApiService networkRepository;
  final FetchingNavigator navigator;
  final FetchingInitialParams initialParams;
  FetchingCubit(this.initialParams, this.networkRepository, this.navigator)
    : super(FetchingState.initial(initialParams: initialParams));

  Future<void> fetching() async {
    emit(state.copyWith(response: ApiResponse.loading()));
    final fetching = await networkRepository.get<List<dynamic>>(
      url: AppUrl.fetching,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
    fetching.fold(
      (l) => emit(state.copyWith(response: ApiResponse.error(l.error))),
      ((r) {
        final users = r
            .map(
              (e) =>
                  FetchingModel.fromJson(Map<String, dynamic>.from(e as Map)),
            )
            .toList();

        emit(state.copyWith(response: ApiResponse.completed(users)));
      }),
    );
  }
}
