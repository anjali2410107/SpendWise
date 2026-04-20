import 'dart:math';

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
class _EditExpenseScreenState extends State<EditExpenseScreen> {
  late TextEditingController titleController;
  late TextEditingController amountController;
  String? selectedCategory;
  late DateTime selectedDate;
  late String paymentMethod;
  static const _bg = Color(0xFFF4F6F8);
  static const _teal = Color(0xFF0A3D4D);
  static const _muted = Color(0xFF8A97A8);
  final List<Map<String, dynamic>> _categories = const [
    {"name": "Food", "icon": Icons.restaurant},
    {"name": "Transport", "icon": Icons.directions_car},
    {"name": "Retail", "icon": Icons.shopping_bag},
    {"name": "Rent", "icon": Icons.home},
    {"name": "Fun", "icon": Icons.sports_esports},
    {"name": "Health", "icon": Icons.medical_services},
    {"name": "Travel", "icon": Icons.flight},
    {"name": "Other", "icon": Icons.more_horiz},
  ];

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.expense.title);
    amountController =
        TextEditingController(text: widget.expense.amount.toString());
    selectedCategory = widget.expense.category;
    selectedDate = widget.expense.date;
    paymentMethod = widget.expense.paymentMethod;
  }

  void dispose() {
    titleController.dispose();
    amountController.dispose();
    super.dispose();
  }

void _updateExpense()
{
  final updatedExpense=widget.expense.copyWith
    (
    title:titleController.text,
    amount:double.parse(amountController.text),
    category:selectedCategory!,
    date: selectedDate,
    paymentMethod: paymentMethod,
  );
  context.read<ExpenseBloc>().add(
    UpdateExpense(updatedExpense, widget.userId),
  );
  context.pop();
}
Future<void> _pickDate() async
{
  final picked=await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now()
  );
  if (picked != null) {
    setState(() => selectedDate = picked);
  }
}
  void _showPaymentSheet() {
    final methods = ["Cash", "UPI", "Card", "Wallet"];

    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) {
          return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: methods.map((method) {
                    final isSelected = paymentMethod == method;

                    return ListTile(
                      leading: Icon(
                        _getPaymentIcon(method),
                        color: isSelected ? _teal : Colors.grey,
                      ),
                      title: Text(method),
                      trailing: isSelected
                          ? const Icon(Icons.check, color: _teal)
                          : null,
                      onTap: () {
                        setState(() => paymentMethod = method);
                        Navigator.pop(context);
                      },
                    );
                  }).toList(),
              ),
          );
        },
    );
  }
  String _formatDate(DateTime d) {
    return "${d.day}/${d.month}/${d.year}";
  }
  IconData _getPaymentIcon(String method) {
    switch (method) {
      case "Cash":
        return Icons.money;
      case "UPI":
        return Icons.qr_code;
      case "Card":
        return Icons.credit_card;
      case "Wallet":
        return Icons.account_balance_wallet;
      default:
        return Icons.payment;
    }
  }


@override
Widget build(BuildContext context)
{
  return Scaffold(
    backgroundColor: _bg,
    appBar: AppBar( backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Edit Expense",
          style: TextStyle(color: Colors.black87,
              fontWeight: FontWeight.w600),

        ),
      foregroundColor: Colors.black,

    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(20),
    child: Column(
      children: [
        const Text("Transaction Amount",
            style: TextStyle(color: _muted)),
        TextField(
          controller: amountController,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 40, fontWeight: FontWeight.bold),
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: "₹${0.00}",
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: titleController,
          decoration:  InputDecoration(
            hintText: "Title",
            filled: true,
            fillColor: Colors.grey.shade200,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
        ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: _pickDate,
                child: _infoBox(
                    Icons.calendar_today, _formatDate(selectedDate)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: GestureDetector(
                onTap: _showPaymentSheet,
                child: _infoBox(
                    _getPaymentIcon(paymentMethod), paymentMethod),
              ),
            ),
          ],
        ),
        SizedBox(height: 30,),
        GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: _categories.map((cat) {
              final isSelected = selectedCategory == cat["name"];

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedCategory = cat["name"];
                  });
                },
                child: Container(
                  margin: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color:
                    isSelected ? _teal : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      Icon(cat["icon"],
                      color: isSelected
                          ? Colors.white
                          : Colors.black),
                  const SizedBox(height: 6),
                  Text(
                    cat["name"],
                    style: TextStyle(
                      fontSize: 10,
                      color: isSelected
                          ? Colors.white
                          : Colors.black,
                    ),
                  )
                      ],
                  ),
                ),
              );
            }).toList(),
        ),
       const SizedBox(height: 30,),
        ElevatedButton(onPressed: _updateExpense,
          style: ElevatedButton.styleFrom(
            backgroundColor: _teal,
            minimumSize: const Size(double.infinity, 50),
          ),    child: const Text("Update",style: TextStyle(color: Colors.white),),
        ),
      ],
    ),
    ),
  );
}
Widget _infoBox(IconData icon, String text) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: 8),
        Text(text),
      ],
    ),
  );
}
}