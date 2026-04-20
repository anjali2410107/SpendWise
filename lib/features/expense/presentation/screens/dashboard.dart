import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spendwise/enum.dart';
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
        final expenses=state.filteredExpenses;
        return SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10,),
        _buildToggle(state),
              const SizedBox(height: 20,),
              _buildDonutCard(expenses,state.monthlyTotals),
              const  SizedBox(height: 20,),
              _buildCategorySection(expenses),
              const  SizedBox(height: 20,),
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
    return Container(
      margin: const EdgeInsets.all(16),
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          const Text("Monthly Breakdown",
          style:
          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 10),
      ...categoryTotal.entries.map((entry)
    {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(10),
              ),),
            const SizedBox(width: 12),
            Expanded(child: Text(entry.key,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),),
            Text("₹${entry.value.toStringAsFixed(2)}"),

          ],
        ),

      );
    }
      )],
    ),);
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

 Widget _buildDonutCard(List<Expense> expenses,Map<String,double> data)
 {
   double total = expenses.fold(0, (sum, e) => sum + e.amount);
   double avg = 0;
   if (expenses.isNotEmpty) {
     final firstDate = expenses.first.date;
     final days =
         DateTime.now().difference(firstDate).inDays + 1;
     avg = total / days;
   }
return Container(
  margin: const EdgeInsets.symmetric(horizontal: 16),
  padding: const EdgeInsets.all(20),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(24),
  ),
  child: Column(
    children: [
    Stack(
    alignment: Alignment.center,
    children: [
    SizedBox(
    height: 200,
    child: MonthlyChart(data: data),

  ),
  Column(
    children: [
      const Text(
        "TOTAL SPENT",
        style: TextStyle(
            fontSize: 12, letterSpacing: 1, color: Colors.grey),
      ),
      const SizedBox(height: 5),
      Text(
        "₹${total.toStringAsFixed(0)}",
        style: const TextStyle(
            fontSize: 26, fontWeight: FontWeight.bold),
      ),
    ],
  )
]
  ),
    const SizedBox(height: 20),
Row(
  children: [
    Expanded(child: _statBox(
"AVG. DAILY", "₹${avg.toStringAsFixed(2)}"),
),
   const SizedBox(width: 10),
   Expanded(
   child: _statBox("BUDGET LEFT", "₹1,180"),
   ),],
)
  ],
));}

    Widget _buildToggle(ExpensesState state)
  {
    return Container(
      margin:  const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(30),
      ),
        child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _toggleItem("Weekly",TimeFilter.weekly,state),
    _toggleItem("Monthly",TimeFilter.monthly,state) ,
  _toggleItem("Yearly",TimeFilter.yearly,state) ,

  ],
    ),
    );
  }
  Widget _toggleItem(
      String text,TimeFilter filter,ExpensesState state)
  {
    final isSelected=state.selectedFilter==filter;
    return GestureDetector(
      onTap: (){
        context.read<ExpenseBloc>().add
          (
          ChangeTimeFilter(filter),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 8),
        decoration: BoxDecoration(
          color: isSelected?Colors.white:Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(text),
      ),
    );
  }
  Widget _statBox(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(title,
              style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 5),
          Text(value,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }

  }

