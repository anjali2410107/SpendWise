import 'package:spendwise/features/expense/domain/entities/expense.dart';

abstract class ExpenseEvent {}
  class LoadExpenses extends ExpenseEvent
  {
    final String userId;
    LoadExpenses(this.userId);
}
class AddExpense extends ExpenseEvent
{
  final Expense expense;
  final String userId;
  AddExpense(this.expense,this.userId);
}
class DeleteExpense extends ExpenseEvent
{
  final String expenseId;
  final String userId;
  DeleteExpense(this.expenseId,this.userId);
}
class UpdateExpense extends ExpenseEvent
{
  final Expense expense;
  final String userId;
  UpdateExpense(this.expense,this.userId);
}