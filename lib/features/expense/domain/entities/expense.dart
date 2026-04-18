class Expense
{
  final String id;
  final String title;
  final double amount;
  final String category;
  final DateTime date;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
});
  Expense copyWith({
    String? title,
    double? amount,
    String? category,
    DateTime? date,
})
  {
    return Expense(
      id:id,
      title: title?? this.title,
        amount: amount?? this.amount,
      category: category?? this.category,
      date: date?? this.date,
    );
  }
}