import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendwise/features/expense/domain/entities/expense.dart';
import 'package:spendwise/features/expense/presentation/bloc/expense_bloc.dart';
import 'package:spendwise/features/expense/presentation/bloc/expense_event.dart';
import 'package:spendwise/features/expense/presentation/bloc/expense_state.dart';

class DashboardScreen extends StatelessWidget{
  final String userId;
  const DashboardScreen({super.key,required this.userId});
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SpendWise"),
      ),
      body: BlocBuilder
          <ExpenseBloc,ExpensesState>
        (
          builder: (context,state)
      {
        if(state.isLoading)
          {
            return const Center(child: CircularProgressIndicator(),);
          }
        final expenses=state.expenses;
        return SingleChildScrollView(
          child: Column(
            children: [
              _buildTotalCard(expenses),
              _buildCategorySection(expenses),
              _buildRecentList(expenses),
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(onPressed: ()
      {

      },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildRecentList(List<Expense> expenses)
  {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: expenses.length,
        itemBuilder: (context,index)
        {
        final expense=expenses[index];
        return Dismissible(key: Key(expense.id),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.delete,color:Colors.white),
            ),
            onDismissed: (direction)
            {
              context.read<ExpenseBloc>().add(DeleteExpense(expense.id,
                  userId),
              );
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Expense deleted")),
            );
              },
    child:  ListTile(
        title:Text(expense.title),
    subtitle:Text(expense.category),
    trailing:Text("₹${expense.amount}"),
    ),);
    },
    );
  }
  Widget _buildCategorySection(List<Expense> expenses)
  {
    Map<String,double> categoryTotal={};
    for(var e in expenses)
      {
        categoryTotal[e.category]=
            (categoryTotal[e.category]??0)+e.amount;
      }
    return Column(
      children: categoryTotal.entries.map((entry)
      {
        return ListTile(
          title: Text(entry.key),
          trailing: Text("₹${entry.value.toStringAsFixed(2)}"),
        );
      }).toList(),
    );
  }
  Widget _buildTotalCard(List<Expense> expenses)
  {
    double total=0;
    for(var e in expenses)
      {
        total+=e.amount;
      }
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text("Total Expense"),
          const SizedBox(height: 10,),
          Text(
            "₹${total.toStringAsFixed(2)}",
            style: const TextStyle(fontSize: 24,
            fontWeight: FontWeight.bold),
            ),

        ],
      ),
      ),
    );
  }
  }

