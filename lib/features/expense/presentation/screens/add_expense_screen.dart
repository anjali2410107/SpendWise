import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spendwise/features/expense/domain/entities/expense.dart';
import 'package:spendwise/features/expense/presentation/bloc/expense_event.dart';

import '../bloc/expense_bloc.dart';

class AddExpenseScreen extends StatefulWidget{
  final String userId;
  const AddExpenseScreen({super.key,required this.userId});
  @override
  State<AddExpenseScreen> createState()=> _AddExpenseScreenState();
}
class _AddExpenseScreenState extends State<AddExpenseScreen>
{
  final _titleController=TextEditingController();
  final _amountController=TextEditingController();
  String category="Food";
  void _submit()
  {
    final title=_titleController.text;
    final amount=double.tryParse(_amountController.text);
    if(title.isEmpty||amount==null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter valid data")),
      );

      return;
    }
    final expense=Expense(
        id: '',
        title: title,
        amount: amount,
        category: category,
        date: DateTime.now(),
    );
    context.read<ExpenseBloc>().add
      (
      AddExpense(expense, widget.userId),
    );
    context.pop();
    
  }
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Expense")),
      body: Padding(
          padding:const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: "Title",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12,),
        TextField(
          controller: _amountController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: "Amount",
            border: OutlineInputBorder(),
          ),
        ),
          const SizedBox(height: 12,),
          DropdownButtonFormField<String>
            (
              value: category,
              items: ["Food","Travel","Shopping"]
              .map((e) => DropdownMenuItem(
                value: e,
                  child: Text(e),)).toList(),
              onChanged: (val)
          {
            setState(() {
              category=val!;
            });
          },
            decoration: const InputDecoration(
              labelText: "Category",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20,),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(onPressed: _submit,
                child: const Text("Add Expense"),
            ),
          ),
        ],
      ),
      ),
    );
  }
}