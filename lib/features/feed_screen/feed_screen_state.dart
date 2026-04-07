import '/config/response/api_response.dart';
import '/data/models/feed/feed_model.dart';
import 'feed_screen_initial_params.dart';

class FeedScreenState {
  final ApiResponse<FeedModel> response;
  FeedScreenState({required this.response});

  factory FeedScreenState.initial({
    required FeedScreenInitialParams initialParams,
  }) {
    return FeedScreenState(response: ApiResponse.loading());
  }

  FeedScreenState copyWith({ApiResponse<FeedModel>? response}) {
    return FeedScreenState(response: response ?? this.response);
  }
}
