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
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(title: const Text("Add Expense"),
      backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body:SingleChildScrollView(
          padding:const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Transaction Amount",style: TextStyle(fontSize: 12,color: Colors.grey),),
          const SizedBox(height: 10,),
          Center(
          child: TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
            decoration: const InputDecoration(
              hintText: "0.00",
              border: InputBorder.none,
            ),
          ),),
          const SizedBox(height: 20,),
        const Text("TiTLE"),
        const SizedBox(height: 6,),
        TextField(
          controller: _titleController,
          decoration: InputDecoration(
            hintText: "What was it for?",
            filled:true,
            fillColor: Colors.grey.shade200,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
          const SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const[
              Text("Curated Category",style: TextStyle(fontWeight: FontWeight.bold),),
              Text("SELECT ONE",style: TextStyle(fontSize: 10,color: Colors.green),),
            ],
          ),
          const SizedBox(height: 10,),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: ["Food","Transport","Retail","Rent","Fun","Health"]
                .map((cat) =>_categoryBox(cat))
            .toList(),
          ),
          const SizedBox(height: 20,),

          Row(
            children: [
              Expanded(child: _infoBox(Icons.calendar_today,"Oct 24,2023"),
              ),
              const SizedBox(width: 10,),
              Expanded(child: _infoBox(Icons.credit_card,"Visa"),
              ),
            ],
          ),
          const SizedBox(height: 20,),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0A3D4D),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text("Save Entry"),
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _categoryBox(String cat)
  {
    final isSelected=category==cat;
    return GestureDetector(
      onTap: ()
      {
        setState(() {
          category=cat;
               
        });
      },
      child: Container(
        width: 90,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected?const Color(0xFF0A3D4D):Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(cat,style: TextStyle(
            color: isSelected?Colors.white:Colors.black,
            fontSize: 12,
          ),),
        ),
      ),
    );
  }
  Widget _infoBox(IconData icon,String text)
  {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon,size: 18,),
          const SizedBox(width: 8,),
          Text(text),
        ],
      ),
    );
  }
}