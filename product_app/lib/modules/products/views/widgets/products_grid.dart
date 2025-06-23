import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../controllers/product_controller.dart';
import 'product_card.dart';

class ProductsGrid extends StatelessWidget {
  final ProductController controller;
  final ScrollController scrollController;
  final List<dynamic> products;

  const ProductsGrid({
    super.key,
    required this.controller,
    required this.scrollController,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        if (controller.searchQuery.isNotEmpty) {
          return controller.searchProducts(
            controller.searchQuery.value,
            reset: true,
          );
        } else {
          return controller.fetchProducts(reset: true);
        }
      },
      child: GridView.builder(
        controller: scrollController,
        padding: const EdgeInsets.all(16),
        physics: const AlwaysScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: context.gridCrossAxisCount,
          childAspectRatio: 0.7,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount:
            products.length +
            (controller.isLoading.value && products.isNotEmpty ? 2 : 0),
        itemBuilder: (_, i) {
          if (i >= products.length) {
            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(child: CircularProgressIndicator()),
            );
          }

          final product = products[i];
          return ProductCard(product: product);
        },
      ),
    );
  }
}
