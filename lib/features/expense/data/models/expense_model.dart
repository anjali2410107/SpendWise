import 'package:spendwise/auth/domain/expense.dart';

class ExpenseModel extends Expense{
  ExpenseModel({
    required super.id,
    required super.title,
    required super.amount,
    required super.category,
    required super.date,
});


}