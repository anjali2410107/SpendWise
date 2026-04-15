import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spendwise/features/expense/data/models/expense_model.dart';

class ExpenseRemoteDataSource
{
  final FirebaseFirestore firestore;
  ExpenseRemoteDataSource(this.firestore);
  Future<void> addExpense(ExpenseModel expense,String userId) async
  {
    await firestore
        .collection('users')
        .doc(userId)
        .collection('expenses')
        .doc(expense.id)
        .set(expense.toJson());
  }

}