import '../../domain/entities/expense.dart';

class   ExpensesState {
  final List<Expense> expenses;
  final List<Expense> filteredExpenses;
  final bool isLoading;
final Map<String,double> monthlyTotals;

  ExpensesState({
    this.expenses=const[],
    this.isLoading=false,
    this.monthlyTotals=const{},
    this.filteredExpenses=const[],
  });
  ExpensesState copyWith({
    List<Expense>? expenses,
    bool? isLoading,
    Map<String,double>?monthlyTotals,
    List<Expense>? filteredExpenses,
})
  {
    return ExpensesState(
      expenses: expenses??this.expenses,
      isLoading: isLoading??this.isLoading,
      monthlyTotals: monthlyTotals??this.monthlyTotals,
      filteredExpenses: filteredExpenses??this.filteredExpenses,
    );
  }
}