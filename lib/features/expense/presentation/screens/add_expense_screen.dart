import 'dart:math';

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
final List<Map<String,dynamic>> _categories=[
  {
    "name":"Food","icon":Icons.restaurant
  },
  {
    "name":"Transport","icon":Icons.directions_car
  }, {
    "name":"Retail","icon":Icons.shopping_bag
  }, {
    "name":"Rent","icon":Icons.home
  }, {
    "name":"Fun","icon":Icons.sports_esports
  }, {
    "name":"Health","icon":Icons.medical_services
  }, {
    "name":"Travel","icon":Icons.flight
  },
  {
    "name":"Other","icon":Icons.more_horiz
  },

];
class _AddExpenseScreenState extends State<AddExpenseScreen>
{
  final _titleController=TextEditingController();
  final _amountController=TextEditingController();
  String category="Food";
  DateTime selectedDate=DateTime.now();
  String selectedCard="Visa";
  String paymentMethod="Cash";
  IconData _getPaymentIcon(String method)
  {
    switch(method)
        {
      case "Cash":
        return Icons.money;
      case "UPI":
        return Icons.qr_code;
      case "Card":
        return Icons.credit_card;
      case "Wallet":
        return Icons.account_balance_wallet_rounded;
      default:
        return Icons.payment;
    }
  }
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
        date: selectedDate,
      paymentMethod: paymentMethod,
    );
    context.read<ExpenseBloc>().add
      (
      AddExpense(expense, widget.userId),
    );
    context.pop();

  }
  void _showPaymentSheet()
  {
    showModalBottomSheet(context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top:Radius.circular(20)),
        ),
        builder: (context)
    {
      final methods=["Cash","UPI","Card","Wallet"];
      return Padding(padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: methods.map((method){
          final isSelected=paymentMethod==method;
          return ListTile
            (
        leading:Icon(
        _getPaymentIcon(method),
        color:isSelected?const Color(0xFF0A3D4D):Colors.grey,
        ),
      title:Text(method),
      trailing:isSelected?const Icon(Icons.check,color:Color(0xFF0A3D4D))
      :null,
      onTap:()
      {
        setState(() => paymentMethod=method);
        Navigator.pop(context);
      },
      );
      }).toList(),
      ),
      );
      },
      );
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
        const Text("TITLE"),
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
              Text("SELECT ONE",style: TextStyle(fontSize:12,color: Colors.green,fontWeight: FontWeight.bold),),
            ],
          ),
          const SizedBox(height: 10,),
        GridView.count(crossAxisCount: 4,
        shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.9,
          children:_categories.map((cat)
          {
            return _categoryItem(cat);
          }
          ).toList(),
        ),
          const SizedBox(height: 20,),

          Row(
            children: [
              Expanded(child:GestureDetector(
                onTap: () async
                {
                  final picked=await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2020), lastDate: DateTime.now(),);
                  if(picked!=null)
                    {
                      setState(() => selectedDate=picked);
                    }
                },
                child: _infoBox(Icons.calendar_today,
                   "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}" ),
              ),
              ),
              const SizedBox(width: 10,),
              Expanded(child: GestureDetector(
  onTap: () {
    _showPaymentSheet();
  },

          child:     _infoBox(Icons.credit_card,"Visa"),
              ),
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
                child: const Text("Save Entry",style: TextStyle(color: Colors.white),),
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _categoryItem(Map<String,dynamic> cat)
  {
    final isSelected=category==cat["name"];
    return GestureDetector(
      onTap: ()
      {
        setState(() {
          category=cat["name"];
               
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected?const Color(0xFF0A3D4D):Colors.white,
          borderRadius: BorderRadius.circular(16),
         border: Border.all(
           color: isSelected? Colors.transparent:Colors.grey.shade200,
         width: 1),
          boxShadow:[ BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
          )
            ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(cat["icon"],color: isSelected?Colors.white:Colors.black,),
            const SizedBox(
              height: 6,
            ),
            const SizedBox(height: 6,),
            Text(cat["name"],
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: isSelected?Colors.white:Colors.black,
            ),
            ),
          ],
        )
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