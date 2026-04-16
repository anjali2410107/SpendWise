import '../../domain/entities/expense.dart';

class   ExpensesState {
  final List<Expense> expenses;
  final bool isLoading;

  ExpensesState({
    this.expenses=const[],
    this.isLoading=false,
  });
  ExpensesState copyWith({
    List<Expense>? expenses,
    bool? isLoading,
})
  {
    return ExpensesState(
      expenses: expenses??this.expenses,
      isLoading: isLoading??this.isLoading,
    );
  }
}