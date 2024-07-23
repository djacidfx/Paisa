import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:paisa/core/common.dart';
import 'package:paisa/core/common_enum.dart';
import 'package:paisa/features/category/domain/entities/category.dart';

class CategoryItemMobileWidget extends StatelessWidget {
  const CategoryItemMobileWidget({
    super.key,
    required this.category,
    required this.onLongPress,
    required this.onTap,
  });

  final CategoryEntity category;
  final Function(String categoryName, int categoryId) onLongPress;
  final Function(int categoryId) onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onLongPress: () => onLongPress(category.name, category.superId!),
      onTap: () => onTap(category.superId!),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Color(category.color).withOpacity(0.3),
          child: Icon(
            IconData(
              category.icon,
              fontFamily: fontFamilyName,
              fontPackage: fontFamilyPackageName,
            ),
            color: Color(category.color),
          ),
        ),
        title: Text(
          category.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: context.titleMedium?.copyWith(
            color: context.onSurfaceVariant,
          ),
        ),
        trailing: category.categoryType == CategoryType.transfer
            ? Icon(MdiIcons.swapHorizontal)
            : null,
        subtitle: category.description == null || category.description == ''
            ? null
            : Text(
                category.description!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.bodyLarge?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurfaceVariant
                      .withOpacity(0.75),
                ),
              ),
      ),
    );
  }
}
