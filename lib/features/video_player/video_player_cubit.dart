import 'package:flutter_bloc/flutter_bloc.dart';

import '/data/models/video_player_model.dart';
import '/domain/repositories/network/network_base_api_service.dart';
import 'video_player_initial_params.dart';
import 'video_player_navigator.dart';
import 'video_player_state.dart';
import 'widgets/video_player_constants.dart';

class VideoPlayerCubit extends Cubit<VideoPlayerState> {
  VideoPlayerCubit(this.initialParams, this.networkRepository, this.navigator)
    : super(VideoPlayerState.initial(initialParams: initialParams));

  final VideoPlayerInitialParams initialParams;
  final NetworkBaseApiService networkRepository;
  final VideoPlayerNavigator navigator;

  void setChromeVisible(bool visible) {
    emit(state.copyWith(chromeVisible: visible));
  }

  String resolvePlaybackUrl(VideoPlayerModel data) {
    final fromParams = initialParams.videoUrl?.trim();
    if (fromParams != null && fromParams.isNotEmpty) {
      return fromParams;
    }
    final fromModel = data.videoUrl?.trim();
    if (fromModel != null && fromModel.isNotEmpty) {
      return fromModel;
    }
    return VideoPlayerConstants.defaultVideoUrl;
  }
}
