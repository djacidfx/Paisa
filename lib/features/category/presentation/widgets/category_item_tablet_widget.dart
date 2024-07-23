import 'package:flutter/material.dart';
import 'package:paisa/core/common.dart';
import 'package:paisa/core/widgets/paisa_widget.dart';
import 'package:paisa/features/category/domain/entities/category.dart';

class CategoryItemTabletWidget extends StatelessWidget {
  const CategoryItemTabletWidget({
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
    return PaisaFilledCard(
      child: InkWell(
        onLongPress: () => onLongPress(category.name, category.superId!),
        onTap: () => onTap(category.superId!),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Icon(
                IconData(
                  category.icon,
                  fontFamily: fontFamilyName,
                  fontPackage: fontFamilyPackageName,
                ),
                color: Color(category.color),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.bodyMedium?.copyWith(
                        color: context.onSurface,
                      ),
                    ),
                    if (category.description != null)
                      Text(
                        category.description!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.labelMedium?.copyWith(
                          color: context.onSurface.withOpacity(0.55),
                        ),
                      )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
