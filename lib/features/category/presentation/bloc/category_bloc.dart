import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:paisa/core/common_enum.dart';
import 'package:paisa/features/category/domain/entities/category.dart';
import 'package:paisa/features/category/domain/use_case/category_use_case.dart';
import 'package:paisa/features/transaction/domain/use_case/transaction_use_case.dart';

part 'category_bloc.freezed.dart';

@injectable
class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc({
    required this.getCategoryUseCase,
    required this.addCategoryUseCase,
    required this.deleteCategoryUseCase,
    required this.deleteExpensesFromCategoryIdUseCase,
    required this.updateCategoryUseCase,
  }) : super(const AddCategoryInitial()) {
    on<CategoryEvent>((event, emit) {});
    on<FetchCategoryFromIdEvent>(_fetchCategoryFromId);
    on<AddOrUpdateCategoryEvent>(_addOrUpdateCategory);
    on<CategoryDeleteEvent>(_deleteCategory);
    on<CategoryIconSelectedEvent>(_categoryIcon);
    on<UpdateCategoryBudgetEvent>(_updateCategoryBudget);
    on<CategoryColorSelectedEvent>(_updateCategoryColor);
    on<UpdateCategoryTypeEvent>(_updateCategoryType);
  }

  final AddCategoryUseCase addCategoryUseCase;
  double? categoryBudget;
  String? categoryDesc;
  String? categoryTitle;
  CategoryType categoryType = CategoryType.income;
  CategoryEntity? currentCategory;
  final DeleteCategoryUseCase deleteCategoryUseCase;
  final DeleteTransactionsByCategoryIdUseCase
      deleteExpensesFromCategoryIdUseCase;

  final GetCategoryUseCase getCategoryUseCase;
  bool? isBudgetSet = false;
  int? selectedColor;
  int? selectedIcon;
  final UpdateCategoryUseCase updateCategoryUseCase;

  Future<void> _fetchCategoryFromId(
    FetchCategoryFromIdEvent event,
    Emitter<CategoryState> emit,
  ) async {
    final int? categoryId = event.categoryId;
    if (categoryId == null) return;

    final CategoryEntity? category = getCategoryUseCase(
      GetCategoryParams(categoryId),
    );
    if (category != null) {
      categoryTitle = category.name;
      categoryDesc = category.description;
      categoryBudget = category.budget;
      selectedIcon = category.icon;
      currentCategory = category;
      isBudgetSet = category.isBudget;
      selectedColor = category.color;
      categoryType = category.categoryType;
      emit(CategoryState.success(category));
    }
  }

  FutureOr<void> _addOrUpdateCategory(
    AddOrUpdateCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    final String? title = categoryTitle;
    final String? description = categoryDesc;
    final int? icon = selectedIcon;
    final double? budget = categoryBudget;

    final int? color = selectedColor;
    if (icon == null) {
      return emit(const CategoryState.error('Select category icon'));
    }
    if (title == null) {
      return emit(const CategoryState.error('Add category title'));
    }

    if (color == null) {
      return emit(const CategoryState.error('Select category color'));
    }
    if (event.isAddOrUpdate) {
      await addCategoryUseCase(AddCategoryParams(
        icon: icon,
        description: description,
        name: title,
        budget: budget ?? 0,
        isBudget: isBudgetSet ?? false,
        color: color,
        categoryType: categoryType,
      ));
    } else {
      if (currentCategory == null) return;

      await updateCategoryUseCase(UpdateCategoryParams(
        key: currentCategory!.superId!,
        budget: budget,
        color: color,
        description: description,
        icon: icon,
        isBudget: isBudgetSet ?? false,
        categoryType: categoryType,
        name: title,
      ));
    }
    emit(CategoryState.added(isCategoryAddedOrUpdate: event.isAddOrUpdate));
  }

  Future<void> _deleteCategory(
    CategoryDeleteEvent event,
    Emitter<CategoryState> emit,
  ) async {
    final int categoryId = event.categoryId;
    await deleteCategoryUseCase(DeleteCategoryParams(categoryId));
    await deleteExpensesFromCategoryIdUseCase(
      DeleteTransactionsByCategoryIdParams(categoryId),
    );
    emit(const CategoryState.deleted());
  }

  FutureOr<void> _categoryIcon(
    CategoryIconSelectedEvent event,
    Emitter<CategoryState> emit,
  ) {
    selectedIcon = event.categoryIcon;
    emit(CategoryState.iconSelected(event.categoryIcon));
  }

  FutureOr<void> _updateCategoryBudget(
    UpdateCategoryBudgetEvent event,
    Emitter<CategoryState> emit,
  ) {
    isBudgetSet = event.isBudget;
    emit(CategoryState.updateBudget(event.isBudget));
  }

  FutureOr<void> _updateCategoryColor(
    CategoryColorSelectedEvent event,
    Emitter<CategoryState> emit,
  ) {
    selectedColor = event.categoryColor;
    emit(CategoryState.colorSelected(event.categoryColor));
  }

  FutureOr<void> _updateCategoryType(
    UpdateCategoryTypeEvent event,
    Emitter<CategoryState> emit,
  ) {
    categoryType = event.categoryType;
    emit(CategoryState.updateType(event.categoryType));
  }
}

@freezed
class CategoryEvent with _$CategoryEvent {
  const factory CategoryEvent.addOrUpdate(bool isAddOrUpdate) =
      AddOrUpdateCategoryEvent;

  const factory CategoryEvent.colorSelected(int categoryColor) =
      CategoryColorSelectedEvent;

  const factory CategoryEvent.delete(int categoryId) = CategoryDeleteEvent;

  const factory CategoryEvent.fetchFromId(int? categoryId) =
      FetchCategoryFromIdEvent;

  const factory CategoryEvent.iconSelected(int categoryIcon) =
      CategoryIconSelectedEvent;

  const factory CategoryEvent.updateBudget(bool isBudget) =
      UpdateCategoryBudgetEvent;

  const factory CategoryEvent.updateType(CategoryType categoryType) =
      UpdateCategoryTypeEvent;
}

@freezed
class CategoryState with _$CategoryState {
  const factory CategoryState.added({required bool isCategoryAddedOrUpdate}) =
      CategoryAddedState;

  const factory CategoryState.colorSelected(int categoryColor) =
      CategoryColorSelectedState;

  const factory CategoryState.deleted() = CategoryDeletedState;

  const factory CategoryState.error(String errorString) = CategoryErrorState;

  const factory CategoryState.iconSelected(int categoryIcon) =
      CategoryIconSelectedState;

  const factory CategoryState.initial() = AddCategoryInitial;

  const factory CategoryState.success(CategoryEntity category) =
      CategorySuccessState;

  const factory CategoryState.updateBudget(bool isBudget) =
      UpdateCategoryBudgetState;

  const factory CategoryState.updateType(CategoryType categoryType) =
      UpdateCategoryTypeState;
}
