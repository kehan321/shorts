import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player_app/core/utils/app_url.dart';
import 'package:video_player_app/data/models/feed/feed_model.dart';
import 'package:video_player_app/domain/repositories/network/network_base_api_service.dart';

import '/config/response/api_response.dart';
import 'feed_screen_initial_params.dart';
import 'feed_screen_navigator.dart';
import 'feed_screen_state.dart';

class FeedScreenCubit extends Cubit<FeedScreenState> {
  FeedScreenCubit(this.initialParams, this.navigator, this.networkRepository)
    : super(FeedScreenState.initial(initialParams: initialParams));

  final FeedScreenInitialParams initialParams;
  final FeedScreenNavigator navigator;
  final NetworkBaseApiService networkRepository;
  Future<void> feedScreen() async {
    emit(state.copyWith(response: ApiResponse.loading()));

    final feed = await networkRepository.get<Map<String, dynamic>>(
      url: AppUrl.feed,
    );

    feed.fold(
      (l) {
        emit(state.copyWith(response: ApiResponse.error(l.error)));
      },
      (r) {
        emit(
          state.copyWith(
            response: ApiResponse.completed(FeedModel.fromJson(r)),
          ),
        );
      },
    );
  }
}
