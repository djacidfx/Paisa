import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paisa/config/routes.dart';
import 'package:paisa/core/widgets/paisa_scaffold.dart';

import 'package:hive_flutter/adapters.dart';
import 'package:paisa/features/category/presentation/cubit/categories_cubit.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'package:paisa/core/common.dart';
import 'package:paisa/core/widgets/paisa_widget.dart';
import 'package:paisa/features/category/data/model/category_model.dart';
import 'package:paisa/features/category/domain/entities/category.dart';
import 'package:paisa/features/category/presentation/pages/category_list_mobile_page.dart';
import 'package:paisa/features/category/presentation/pages/category_list_tablet_page.dart';
import 'package:paisa/main.dart';

class CategoryListPage extends StatelessWidget {
  const CategoryListPage({super.key});

  void onTab(BuildContext context, int id) {
    CategoryPageData(
      categoryId: id,
    ).push(context);
  }

  void onLongPress(BuildContext context, String categoryName, int id) {
    paisaAlertDialog(
      context,
      title: Text(context.loc.dialogDeleteTitle),
      child: RichText(
        text: TextSpan(
          text: context.loc.deleteCategory,
          children: [
            TextSpan(
              text: categoryName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
          style: context.bodyLarge,
        ),
      ),
      confirmationButton: TextButton(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        onPressed: () {
          context.read<CategoriesCubit>().deleteCategory(id);
          Navigator.pop(context);
        },
        child: const Text('Delete'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PaisaAnnotatedRegionWidget(
      color: context.background,
      child: PaisaScaffold(
        body: ValueListenableBuilder<Box<CategoryModel>>(
          valueListenable: getIt<Box<CategoryModel>>().listenable(),
          builder: (BuildContext context, value, Widget? child) {
            if (value.values.isEmpty) {
              return EmptyWidget(
                title: context.loc.emptyCategoriesMessageTitle,
                description: context.loc.emptyCategoriesMessageSubTitle,
                icon: Icons.category,
              );
            }
            final List<CategoryEntity> categories = value.values.toEntities();
            return ScreenTypeLayout.builder(
              mobile: (p0) => CategoryListMobileWidget(
                categories: categories,
                onTap: (id) => onTab(context, id),
                onLongPress: (name, id) => onLongPress(context, name, id),
              ),
              tablet: (p0) => CategoryListTabletWidget(
                crossAxisCount: 3,
                categories: categories,
                onTap: (id) => onTab(context, id),
                onLongPress: (name, id) => onLongPress(context, name, id),
              ),
              desktop: (p0) => CategoryListTabletWidget(
                crossAxisCount: 5,
                categories: categories,
                onTap: (id) => onTab(context, id),
                onLongPress: (name, id) => onLongPress(context, name, id),
              ),
            );
          },
        ),
      ),
    );
  }
}
