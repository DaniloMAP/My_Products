import 'package:get/get.dart';
import '../../../core/network/api_client.dart';
import '../../../data/datasources/product_datasource.dart';
import '../../../data/repositories/product_repository.dart';
import '../../../domain/services/product_service.dart';
import '../controllers/product_controller.dart';

class ProductBinding extends Bindings {
  @override
  void dependencies() {
    // Network
    Get.lazyPut<ApiClient>(() => ApiClient());
    
    // Datasource
    Get.lazyPut<ProductDatasource>(
      () => ProductDatasourceImpl(Get.find<ApiClient>()),
    );
    
    // Repository
    Get.lazyPut<ProductRepository>(
      () => ProductRepositoryImpl(Get.find<ProductDatasource>()),
    );
    
    // Service
    Get.lazyPut<ProductService>(
      () => ProductService(Get.find<ProductRepository>()),
    );
    
    // Controller
    Get.lazyPut<ProductController>(
      () => ProductController(Get.find<ProductService>()),
    );
  }
}
