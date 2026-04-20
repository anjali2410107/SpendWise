import 'dart:math';
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
  final Map<String,IconData> categoryIcons={
    "Food": Icons.restaurant,
    "Transport": Icons.directions_car,
    "Retail": Icons.shopping_bag,
    "Rent": Icons.home,
    "Fun": Icons.sports_esports,
    "Health": Icons.medical_services,
    "Travel": Icons.flight,
    "Other": Icons.more_horiz,
  };
  final Map<String, Color> categoryColors = {
    "Food": const Color(0xFF0A3D4D),
    "Transport": const Color(0xFF1D3557),
    "Retail": const Color(0xFFB8860B),
    "Rent": const Color(0xFF8B3A3A),
    "Fun": const Color(0xFF4A148C),
    "Health": const Color(0xFF006064),
    "Travel": const Color(0xFF146339),
    "Other": const Color(0xFF424242),
  };
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        title: const Text("SpendWise"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,

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
        Map<String,double> categoryTotal={};
        for(var e in expenses) {
          categoryTotal[e.category]=(categoryTotal[e.category]??0)+e.amount;
        }
        
        return SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10,),
        _buildToggle(state),
              const SizedBox(height: 20,),
              _buildDonutCard(expenses,categoryTotal),
              const  SizedBox(height: 20,),
              _buildCategorySection(expenses),
              const  SizedBox(height: 20,),
              _buildRecentList(expenses),

            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0A3D4D),
        onPressed: () {
      context.push('/add');
      },
        child: const Icon(Icons.add,color: Colors.white,),
      ),
    );
  }

  Widget _buildRecentList(List<Expense> expenses)
  {
    final recent=expenses.take(3).toList();
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        const Text("Recent Transactions",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18, color: Color(0xFF0A3D4D)),),
      GestureDetector(
        onTap: ()
        {
          context.push('/history');
        },
        child: const Text("View All",
          style: TextStyle(color: Color(0xFF0A3D4D),
              fontWeight: FontWeight.bold),),
      ),],),
        const SizedBox(height: 10,),
        ...recent.map((expense)
        {
          final icon=categoryIcons[expense.category] ?? Icons.category;
          final color=categoryColors[expense.category]?? Colors.grey;
          return Container(
            margin: const EdgeInsets.only(bottom:10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
              child: ListTile(
               contentPadding:EdgeInsets.zero,
                onTap: () =>
                  context.push('/edit',extra:expense),

                leading: CircleAvatar(
                  backgroundColor: color,
                  child: Icon(icon, color: Colors.white),
                ),
        title:Text(expense.title,
          style: TextStyle(fontWeight: FontWeight.bold),),
    subtitle:Text("${expense.category} • ${expense.date.day}/${expense.date.month}/${expense.date.year}"),
    trailing:Text("₹${expense.amount.toStringAsFixed(0)}",style: const TextStyle(
      fontWeight: FontWeight.bold,color: Color(0xFF7A2828), fontSize: 16
    ),
    ),
    ),
          );
    },)
    ],
    ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          const Text("Monthly Breakdown",
          style:
          TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0A3D4D))),
      const SizedBox(height: 10),
      ...categoryTotal.entries.map((entry)
    {
      final icon = categoryIcons[entry.key] ?? Icons.category;
      final color = categoryColors[entry.key] ?? Colors.grey;
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color,
              child:  Icon(icon,color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(entry.key,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),),
            Text("₹${entry.value.toStringAsFixed(0)}",
              style: const TextStyle(color: Color(0xFF7A2828),fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      );
    })
      ],
    ),);
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
    child: MonthlyChart(data: data,colors:categoryColors),

  ),
  Column(
    children: [
      const Text(
        "TOTAL SPENT",
        style: TextStyle(
            fontSize: 12, letterSpacing: 1, color: Colors.grey, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 5),
      Text(
        "₹${total.toStringAsFixed(0)}",
        style: const TextStyle(
            fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF0A3D4D)),
      ),
    ],
  )
]
  ),
    const SizedBox(height: 20),
Row(
  children: [
    Expanded(child: _statBox(
"AVG. DAILY", "₹${avg.toStringAsFixed(0)}", false),
),
   const SizedBox(width: 10),
   Expanded(
   child: _statBox("BUDGET LEFT", "₹1,180", true),
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
        child: Text(text,style: TextStyle(
          color: isSelected ? const Color(0xFF0A3D4D) : Colors.grey,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
        ),),
      ),
    );
  }
  Widget _statBox(String title, String value, bool isGreen) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(title,
              style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
          const SizedBox(height: 5),
          Text(value,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 16, color: isGreen ? const Color(0xFF147A46) : const Color(0xFF0A3D4D))),
        ],
      ),
    );
  }

  }

