import '/config/response/api_response.dart';
import '/data/models/home_model.dart';
import 'home_initial_params.dart';

class HomeState {
  final ApiResponse<List<HomeModel>> response;

  HomeState({required this.response});
  factory HomeState.initial({required HomeInitialParams initialParams}) =>
      HomeState(response: ApiResponse.initial([]));
  HomeState copyWith({ApiResponse<List<HomeModel>>? response}) =>
      HomeState(response: response ?? this.response);
}
