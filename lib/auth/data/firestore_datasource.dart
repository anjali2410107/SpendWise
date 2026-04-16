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
  Stream<List<ExpenseModel>> getExpenses(String userId)
  {
    return firestore
        .collection('users')
        .doc(userId)
        .collection('expenses')
        .snapshots()
        .map((snapshot)
    {
      return snapshot.docs
      .map((doc)=>ExpenseModel.fromJson(doc.data()))
      .toList();
    }
    );
  }

  Future<void> deleteExpense(String expenseId,String userId) async
  {
    await firestore
        .collection('users')
        .doc(userId)
        .collection('expenses')
        .doc(expenseId)
        .delete();
  }
  Future<void> updateExpense(ExpenseModel expense,String userId) async
  {
    await firestore
        .collection('users')
        .doc(userId)
        .collection('expenses')
        .doc(expense.id)
        .update(expense.toJson());
  }

}