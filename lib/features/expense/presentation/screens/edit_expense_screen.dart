import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spendwise/features/expense/presentation/bloc/expense_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/expense.dart';
import '../bloc/expense_bloc.dart';

class EditExpenseScreen extends StatefulWidget{
  final Expense expense;
  final String userId;
  const EditExpenseScreen({
    super.key,
    required this.expense,
    required this.userId,
});
  @override
  State<EditExpenseScreen> createState() =>_EditExpenseScreenState();
}
class _EditExpenseScreenState extends State<EditExpenseScreen>
{
  late TextEditingController titleController;
  late TextEditingController amountController;
  String? selectedCategory;

@override
void initState() {
  super.initState();
  titleController =TextEditingController(text: widget.expense.title);
  amountController=TextEditingController(text: widget.expense.amount.toString());
  selectedCategory=widget.expense.category;
}
void _updateExpense()
{
  final updatedExpense=widget.expense.copyWith
    (
    title:titleController.text,
    amount:double.parse(amountController.text),
    category:selectedCategory!,
  );
  context.read<ExpenseBloc>().add(
    UpdateExpense(updatedExpense, widget.userId),
  );
  context.pop();
}
@override
Widget build(BuildContext context)
{
  return Scaffold(
    appBar: AppBar(title: const Text("Edit Expense")),
    body: Padding(padding: const EdgeInsets.all(16),
    child: Column(
      children: [
        TextField(
          controller: titleController,
          decoration: const InputDecoration(labelText: "Title"),
        ),
        TextField(
          controller: amountController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: "Amount"),
        ),
        DropdownButton<String>(
            value: selectedCategory,
            hint: const Text("select category"),
            items: ["Food","Travel","Shopping"].map((e) =>DropdownMenuItem(
               value: e,
                child: Text(e),
            )).toList(),
            onChanged: (value)
    {
      setState(() {
        selectedCategory=value;
      });
    },
    ),
        const SizedBox(height: 20,),
        ElevatedButton(onPressed: _updateExpense,
            child: const Text("Update"),
        ),
      ],
    ),
    ),
  );
}}