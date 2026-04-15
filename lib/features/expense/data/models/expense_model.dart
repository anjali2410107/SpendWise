import 'package:spendwise/features/expense/domain/entities/expense.dart';

class ExpenseModel extends Expense{
  ExpenseModel({
    required super.id,
    required super.title,
    required super.amount,
    required super.category,
    required super.date,
});
factory ExpenseModel.fromJson(Map<String,dynamic> json)
{
  return ExpenseModel(
      id: json['id'],
      title: json['title'],
      amount: json['amount'],
      category: json['category'],
      date: DateTime.parse(json['date']),
  );
}
Map<String,dynamic> toJson()
{
  return
      {
        'id':id,
        'title':title,
        'amount':amount,
        'category':category,
        'date':date.toIso8601String(),
      };
}

}