import 'package:flutter/material.dart';
import 'package:paisa/core/widgets/paisa_widgets/paisa_divider.dart';

import 'package:paisa/features/category/domain/entities/category.dart';
import 'package:paisa/features/category/presentation/widgets/category_item_mobile_widget.dart';

class CategoryListMobileWidget extends StatelessWidget {
  const CategoryListMobileWidget({
    super.key,
    required this.categories,
    required this.onTap,
    required this.onLongPress,
  });

  final List<CategoryEntity> categories;
  final Function(String categoryName, int categoryId) onLongPress;
  final Function(int categoryId) onTap;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) => const PaisaDivider(indent: 72),
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 124),
      itemCount: categories.length,
      shrinkWrap: true,
      itemBuilder: (_, index) {
        return CategoryItemMobileWidget(
          category: categories[index],
          onTap: onTap,
          onLongPress: onLongPress,
        );
      },
    );
  }
}
