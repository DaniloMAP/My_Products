import '../../core/network/api_client.dart';
import '../services/product_service.dart';

abstract class ProductDatasource {
  Future<ProductResponse> getProducts({
    int page = 1,
    int pageSize = 10,
    String? search,
  });
}

class ProductDatasourceImpl implements ProductDatasource {
  final ApiClient _apiClient;

  ProductDatasourceImpl(this._apiClient);

  @override
  Future<ProductResponse> getProducts({
    int page = 1,
    int pageSize = 10,
    String? search,
  }) async {
    final queryParams = {
      'page': page.toString(),
      'pageSize': pageSize.toString(),
      if (search != null && search.isNotEmpty) 
        'search': Uri.encodeComponent(search),
    };

    final response = await _apiClient.get(
      '/api/products',
      queryParams: queryParams,
    );

    return ProductResponse.fromJson(response);
  }
}