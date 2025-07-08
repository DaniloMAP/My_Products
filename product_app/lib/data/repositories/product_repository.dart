import '../datasources/product_datasource.dart';
import '../services/product_service.dart';

abstract class ProductRepository {
  Future<ProductResponse> getProducts({
    int page = 1,
    int pageSize = 10,
    String? search,
  });
}

class ProductRepositoryImpl implements ProductRepository {
  final ProductDatasource _datasource;

  ProductRepositoryImpl(this._datasource);

  @override
  Future<ProductResponse> getProducts({
    int page = 1,
    int pageSize = 10,
    String? search,
  }) async {
    return await _datasource.getProducts(
      page: page,
      pageSize: pageSize,
      search: search,
    );
  }
}