import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shorts/core/services/pagination_cubit.dart';

import '/config/response/api_response.dart';
import '/core/utils/app_url.dart';
import '/data/models/product_model.dart';
import '/domain/repositories/network/network_base_api_service.dart';
import 'product_initial_params.dart';
import 'product_navigator.dart';
import 'product_state.dart';

final int limit = 5;
final int offset = 0;

class ProductCubit extends Cubit<ProductState> with PaginationMixin {
  final NetworkBaseApiService networkRepository;
  final ProductNavigator navigator;
  final ProductInitialParams initialParams;
  ProductCubit(this.initialParams, this.networkRepository, this.navigator)
    : super(ProductState.initial(initialParams: initialParams));

  Future<void> product() async {
    emit(state.copyWith(response: ApiResponse.loading()));
    final product = await networkRepository.get<Map<String, dynamic>>(
      url: AppUrl.product,
      queryParams: {'skip': offset.toString(), 'limit': limit.toString()},
    );
    product.fold(
      (l) => emit(state.copyWith(response: ApiResponse.error(l.error))),
      ((r) => emit(
        state.copyWith(
          response: ApiResponse.completed(ProductModel.fromJson(r)),
        ),
      )),
    );
  }

  Future<void> loadMore() async {
    await loadMoreData<ProductModel>(
      fetchData: (offset, limit) async {
        final response = await networkRepository.get<Map<String, dynamic>>(
          url: AppUrl.product,
          queryParams: {'skip': offset.toString(), 'limit': limit.toString()},
        );
        return response.fold(
          (l) => ApiResponse.error(l.error),
          (r) => ApiResponse.completed(ProductModel.fromJson(r)),
        );
      },
      mergeData: (current, newData) => current.copyWith(
        products: [...current.products, ...newData.products],
      ),
      getCurrentCount: (data) => data.products.length,
      getTotalCount: (data) => data.total,
    );
  }





}
