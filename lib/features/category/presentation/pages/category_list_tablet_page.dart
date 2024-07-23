import 'package:flutter/material.dart';

import 'package:paisa/features/category/domain/entities/category.dart';
import 'package:paisa/features/category/presentation/widgets/category_item_tablet_widget.dart';

class CategoryListTabletWidget extends StatelessWidget {
  const CategoryListTabletWidget({
    super.key,
    this.crossAxisCount = 1,
    required this.categories,
    required this.onLongPress,
    required this.onTap,
  });

  final List<CategoryEntity> categories;
  final int crossAxisCount;
  final Function(String categoryName, int categoryId) onLongPress;
  final Function(int categoryId) onTap;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.only(
        bottom: 124,
        left: 8,
        right: 8,
        top: 8,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount:
            MediaQuery.of(context).orientation == Orientation.landscape ? 3 : 2,
        childAspectRatio: 4,
      ),
      itemCount: categories.length,
      shrinkWrap: true,
      itemBuilder: (_, index) {
        return CategoryItemTabletWidget(
          category: categories[index],
          onTap: onTap,
          onLongPress: onLongPress,
        );
      },
    );
  }
}
