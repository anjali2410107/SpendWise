import 'package:spendwise/features/expense/domain/entities/expense.dart';

abstract class ExpenseRepository {
  Future<void> addExpense(Expense expense,String userId);
  Stream<List<Expense>> getExpenses(String userId);
  Future<void> deleteExpense(String expenseId,String userId);
  Future<void> updateExpense(Expense expense,String userId);
}