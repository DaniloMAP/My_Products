import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/product_controller.dart';

import '../widgets/product_states.dart';
import '../widgets/products_grid.dart';
import '../widgets/search_bar_widget.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<ProductController>();
    final scrollCtrl = ScrollController();

    scrollCtrl.addListener(() {
      if (scrollCtrl.position.pixels >=
          scrollCtrl.position.maxScrollExtent - 100) {
        ctrl.loadMore();
      }
    });

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Produtos',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: Colors.grey[200]),
        ),
        actions: [
          Obx(
            () => ctrl.isLoading.value && ctrl.displayItems.isNotEmpty
                ? const Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  )
                : const SizedBox(),
          ),
        ],
      ),
      body: Column(
        children: [
          SearchBarWidget(controller: ctrl),

          Expanded(
            child: Obx(() {
              if (ctrl.isLoading.value &&
                  ctrl.displayItems.isEmpty &&
                  ctrl.searchQuery.isEmpty) {
                return const ProductLoadingState(isSearching: false);
              }

              if (ctrl.error.isNotEmpty) {
                return ProductErrorState(
                  errorMessage: ctrl.error.value,
                  controller: ctrl,
                );
              }

              final list = ctrl.displayItems;

              if (list.isEmpty) {
                if (ctrl.searchQuery.isNotEmpty && !ctrl.isSearchActive.value) {
                  return ProductsGrid(
                    controller: ctrl,
                    scrollController: scrollCtrl,
                    products: ctrl.products,
                  );
                }

                if (ctrl.searchQuery.isNotEmpty && ctrl.isSearchActive.value) {
                  return ProductSearchEmptyState(controller: ctrl);
                }

                return ProductEmptyState(controller: ctrl);
              }

              return ProductsGrid(
                controller: ctrl,
                scrollController: scrollCtrl,
                products: list,
              );
            }),
          ),
        ],
      ),
    );
  }
}
