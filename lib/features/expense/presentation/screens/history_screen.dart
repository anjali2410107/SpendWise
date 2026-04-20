import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spendwise/features/expense/domain/entities/expense.dart';
import 'package:spendwise/features/expense/presentation/bloc/expense_bloc.dart';
import 'package:spendwise/features/expense/presentation/bloc/expense_event.dart';
import 'package:spendwise/features/expense/presentation/bloc/expense_state.dart';

class HistoryScreen extends StatefulWidget {
  final String userId;
  const HistoryScreen({super.key, required this.userId});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  
  final Map<String, IconData> categoryIcons = {
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _formatDateString(DateTime d) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final eDate = DateTime(d.year, d.month, d.day);

    if (eDate == today) return "Today";
    if (eDate == yesterday) return "Yesterday";

    const months = [
      "", "JAN", "FEB", "MAR", "APR", "MAY", "JUN", 
      "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"
    ];
    return "${months[d.month]} ${d.day}, ${d.year}";
  }

  String _formatDateShort(DateTime d) {
    const months = [
      "", "JAN", "FEB", "MAR", "APR", "MAY", "JUN", 
      "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"
    ];
    return "${months[d.month]} ${d.day}, ${d.year}";
  }
  
  String _formatTime(DateTime d) {
    int h = d.hour;
    int m = d.minute;
    String meridian = h >= 12 ? "PM" : "AM";
    if (h == 0) h = 12;
    if (h > 12) h -= 12;
    String mm = m < 10 ? "0$m" : "$m";
    return "$h:$mm $meridian";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        title: const Text("SpendWise"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: BlocBuilder<ExpenseBloc, ExpensesState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          List<Expense> filtered = state.expenses.where((e) {
            if (_searchQuery.isEmpty) return true;
            final lowerTitle = e.title.toLowerCase();
            final lowerQuery = _searchQuery.toLowerCase();
            return lowerTitle.contains(lowerQuery) || e.category.toLowerCase().contains(lowerQuery);
          }).toList();

          filtered.sort((a, b) => b.date.compareTo(a.date));

          Map<String, List<Expense>> grouped = {};
          for (var e in filtered) {
            String key = _formatDateString(e.date);
            if (!grouped.containsKey(key)) {
              grouped[key] = [];
            }
            grouped[key]!.add(e);
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Search transactions...",
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: const Icon(Icons.tune),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: grouped.keys.length,
                  itemBuilder: (context, index) {
                    String dateKey = grouped.keys.elementAt(index);
                    List<Expense> dayExpenses = grouped[dateKey]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                dateKey,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0A3D4D),
                                ),
                              ),
                              if (dateKey == "Today" || dateKey == "Yesterday")
                                Text(
                                  _formatDateShort(dayExpenses.first.date),
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                    letterSpacing: 1,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        ...dayExpenses.map((expense) {
                          final icon = categoryIcons[expense.category] ?? Icons.category;
                          final color = categoryColors[expense.category] ?? Colors.grey;

                          return Dismissible(
                            key: Key(expense.id),
                            direction: DismissDirection.endToStart,
                            confirmDismiss: (direction) async {
                              final shouldDelete = await showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text("Delete Expense"),
                                    content: const Text("Are you sure?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, true),
                                        child: const Text("Delete"),
                                      ),
                                    ],
                                  );
                                },
                              );
                              if (shouldDelete == true) {
                                context.read<ExpenseBloc>().add(
                                  DeleteExpense(expense.id, widget.userId),
                                );
                              }
                              return shouldDelete;
                            },
                            background: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: const Icon(Icons.delete, color: Colors.white),
                            ),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.02),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  )
                                ],
                              ),
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                onTap: () => context.push('/edit', extra: expense),
                                leading: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: color,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(icon, color: Colors.white),
                                ),
                                title: Text(
                                  expense.title,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  "${expense.category} • ${_formatTime(expense.date)}",
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                                trailing: Text(
                                  "₹${expense.amount.toStringAsFixed(0)}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          );
                        })
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
