abstract class ExpenseEvent {}
  class LoadExpenses extends ExpenseEvent
  {
    final String userId;
    LoadExpenses(this.userId);
}
