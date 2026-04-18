import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spendwise/features/expense/domain/entities/expense.dart';
import 'package:spendwise/features/expense/presentation/bloc/expense_bloc.dart';
import 'package:spendwise/features/expense/presentation/bloc/expense_event.dart';
import 'package:spendwise/features/expense/presentation/bloc/expense_state.dart';
import 'package:spendwise/features/expense/presentation/widgets/monthly_chart.dart';

class DashboardScreen extends StatefulWidget {
  final String userId;

  const DashboardScreen({super.key, required this.userId});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}
class _DashboardScreenState extends State<DashboardScreen>
{
  @override
  void initState()
  {
    super.initState();
    context.read<ExpenseBloc>().add(
      LoadExpenses(widget.userId),
    );
  }
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SpendWise"),

      ),
      body: BlocBuilder<ExpenseBloc,ExpensesState>
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
              const  SizedBox(height: 20,),
MonthlyChart(data: state.monthlyTotals),
              _buildCategorySection(expenses),
              _buildRecentList(expenses),

            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
      context.push('/add');
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
        return 
          Dismissible(key: Key(expense.id),
            direction: DismissDirection.endToStart,
              confirmDismiss: (direction) async
              {print("Deleting ID from UI: ${expense.id}");
              final shouldDelete=await showDialog(
                  context: context, 
                  builder: (context)
                  {
                    return AlertDialog(

                      title: const Text("Delete Expense"),
                      content: const Text("Are you sure?"),
                      actions: [
                        TextButton(onPressed: ()  =>Navigator.pop(context,true),
                            child: const Text("Delete"),
                        ),

                      ],
                    );
                  },
              );
            if(shouldDelete==true)
{
  context.read<ExpenseBloc>().add(
DeleteExpense(expense.id,widget.userId),
);
}
  return shouldDelete;
            },
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.delete,color: Colors.white),
            ),
              child: ListTile(
                onTap: (){
                  context.push('/edit',extra:expense);
                },
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

