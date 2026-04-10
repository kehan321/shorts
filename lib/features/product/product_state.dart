import '/config/response/api_response.dart';
import '/data/models/product_model.dart';
import 'product_initial_params.dart';

class ProductState {
  final ApiResponse<ProductModel> response;
  final bool isLoadingMore;

  ProductState({required this.response, this.isLoadingMore = false});
  factory ProductState.initial({required ProductInitialParams initialParams}) =>
      ProductState(
        response: ApiResponse.initial(ProductModel.fromJson({})),
        isLoadingMore: false,
      );
  ProductState copyWith({
    ApiResponse<ProductModel>? response,
    bool? isLoadingMore,
  }) => ProductState(
    response: response ?? this.response,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
  );
}
