import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paisa/features/category/domain/use_case/category_use_case.dart';
import 'package:paisa/features/transaction/domain/use_case/transaction_use_case.dart';

part 'categories_cubit.freezed.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  CategoriesCubit(
    this._deleteCategoryUseCase,
    this._deleteExpensesFromCategoryIdUseCase,
  ) : super(const CategoriesState.initial());

  final DeleteCategoryUseCase _deleteCategoryUseCase;
  final DeleteTransactionsByCategoryIdUseCase
      _deleteExpensesFromCategoryIdUseCase;

  Future<void> deleteCategory(int categoryId) async {
    await _deleteCategoryUseCase(DeleteCategoryParams(categoryId));
    await _deleteExpensesFromCategoryIdUseCase(
      DeleteTransactionsByCategoryIdParams(categoryId),
    );
    emit(const CategoriesState.deleted());
  }
}

@freezed
class CategoriesState with _$CategoriesState {
  const factory CategoriesState.deleted() = CategoryDeletedState;

  const factory CategoriesState.initial() = _Initial;
}
