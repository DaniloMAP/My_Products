import '../../data/repositories/product_repository.dart';
import '../../data/services/product_service.dart';

class ProductService {
  final ProductRepository _repository;

  ProductService(this._repository);

  Future<ProductResponse> fetchProducts({
    int page = 1,
    int pageSize = 10,
  }) async {
    return await _repository.getProducts(
      page: page,
      pageSize: pageSize,
    );
  }

  Future<ProductResponse> searchProducts({
    required String query,
    int page = 1,
    int pageSize = 10,
  }) async {
    if (query.trim().isEmpty) {
      throw Exception('Query de busca não pode estar vazia');
    }

    return await _repository.getProducts(
      page: page,
      pageSize: pageSize,
      search: query.trim(),
    );
  }

  bool hasMorePages({
    required int currentItemsCount,
    required int totalCount,
  }) {
    return currentItemsCount < totalCount;
  }

  bool shouldLoadMore({
    required double scrollPosition,
    required double maxScrollExtent,
    double threshold = 100.0,
  }) {
    return scrollPosition >= maxScrollExtent - threshold;
  }
}