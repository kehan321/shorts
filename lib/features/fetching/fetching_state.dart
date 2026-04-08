import '/config/response/api_response.dart';
import '/data/models/fetching_model.dart';
import 'fetching_initial_params.dart';

class FetchingState {
  final ApiResponse<List<FetchingModel>> response;

  FetchingState({required this.response});
  factory FetchingState.initial({
    required FetchingInitialParams initialParams,
  }) => FetchingState(response: ApiResponse.initial([]));
  FetchingState copyWith({ApiResponse<List<FetchingModel>>? response}) =>
      FetchingState(response: response ?? this.response);
}
