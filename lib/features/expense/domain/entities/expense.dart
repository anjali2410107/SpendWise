class Expense
{
  final String id;
  final String title;
  final double amount;
  final String category;
  final DateTime date;
  final String paymentMethod;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    required this.paymentMethod,
});
  Expense copyWith({
    String? title,
    double? amount,
    String? category,
    DateTime? date,
    String? paymentMethod,
})
  {
    return Expense(
      id:id,
      title: title?? this.title,
        amount: amount?? this.amount,
      category: category?? this.category,
      date: date?? this.date,
      paymentMethod: paymentMethod??this.paymentMethod,
    );
  }
}