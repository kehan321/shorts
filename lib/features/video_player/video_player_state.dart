import '/config/response/api_response.dart';
import '/data/models/video_player_model.dart';
import 'video_player_initial_params.dart';

class VideoPlayerState {
  final ApiResponse<VideoPlayerModel> response;
  final bool chromeVisible;

  VideoPlayerState({
    required this.response,
    this.chromeVisible = true,
  });

  factory VideoPlayerState.initial({
    required VideoPlayerInitialParams initialParams,
  }) {
    return VideoPlayerState(
      response: ApiResponse.completed(VideoPlayerModel.fromJson({})),
      chromeVisible: true,
    );
  }

  VideoPlayerState copyWith({
    ApiResponse<VideoPlayerModel>? response,
    bool? chromeVisible,
  }) {
    return VideoPlayerState(
      response: response ?? this.response,
      chromeVisible: chromeVisible ?? this.chromeVisible,
    );
  }
}
