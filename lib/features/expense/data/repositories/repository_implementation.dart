import 'dart:math';

import 'package:spendwise/auth/data/firestore_datasource.dart';
import 'package:spendwise/features/expense/data/models/expense_model.dart';
import 'package:spendwise/features/expense/domain/entities/expense.dart';
import 'package:spendwise/features/expense/domain/repositories/expense_repository.dart';

class ExpenseRepositoryImpl implements ExpenseRepository
{
  final ExpenseRemoteDataSource remote;
  ExpenseRepositoryImpl(this.remote);
  @override
  Future<void> addExpense(Expense expense,String userId) async
  {
    final model=ExpenseModel(
        id: expense.id,
        title: expense.title,
        amount: expense.amount,
        category: expense.category,
        date: expense.date);
    await remote.addExpense(model, userId);
  }
  @override
  Stream<List<Expense>> getExpenses(String userId) {
    return remote.getExpenses(userId).map(
        (models) =>models,
    );
  }
  Future<void> deleteExpense(String expenseId,String userId) async
  {
    print("Repo delete called: $expenseId");
    await remote.deleteExpense(expenseId, userId);
  }
  Future<void> updateExpense(Expense expense,String userId)
  async{
final model=ExpenseModel(
    id: expense.id,
    title: expense.title,
    amount: expense.amount,
    category: expense.category,
    date: expense.date,
);
await remote.updateExpense(model, userId);
  }
}