import 'dart:async';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:spendwise/enum.dart';
import 'package:spendwise/features/expense/domain/repositories/expense_repository.dart';
import 'package:spendwise/features/expense/presentation/bloc/expense_event.dart';
import 'package:spendwise/features/expense/presentation/bloc/expense_state.dart';
import '../../domain/entities/expense.dart';

class ExpenseBloc extends Bloc<ExpenseEvent,ExpensesState>
{
  final ExpenseRepository repository;
  StreamSubscription? _subscription;
  String? selectedCategory;
  TimeFilter selectedFilter = TimeFilter.monthly;
  ExpenseBloc(this.repository):super(ExpensesState())
  {
    on<LoadExpenses>((event,emit) async
    {
      emit(state.copyWith(isLoading: true));
      await _subscription?.cancel();
      _subscription=repository
      .getExpenses(event.userId)
      .listen((expenses)
      {
        add(_ExpensesUpdated(expenses));
      });
    });
    on<_ExpensesUpdated>((event,emit)
    { final allExpenses=event.expenses;
      final timeFiltered=_filterExpenses(allExpenses,selectedFilter);
      final finalFiltered=selectedCategory==null
    ? timeFiltered
      : timeFiltered
    .where((e) =>e.category ==selectedCategory)
    .toList();
      final monthlyTotals=_getMonthlyTotals(allExpenses);
      emit(state.copyWith(
        expenses: allExpenses,
        filteredExpenses:finalFiltered,
        monthlyTotals: monthlyTotals,
        isLoading: false,
      ));});

    on<AddExpense>((event,emit)async
    {
      await repository.addExpense(event.expense, event.userId);
    });
    on<DeleteExpense>((event,emit) async
    {
      await repository.deleteExpense(event.expenseId, event.userId);
    });
    on<UpdateExpense>((event,emit) async
    {
      await repository.updateExpense(event.expense, event.userId);
    });
    on<FilterByCategory>((event,emit) {
      selectedCategory=event.category;
      final filtered = state.expenses
          .where((e) => e.category == event.category)
          .toList();
      emit(state.copyWith(filteredExpenses: filtered));
    });
  on<ChangeTimeFilter>((event,emit)
  {
    final filtered=_filterExpenses(state.expenses, event.filter);
    final monthlyTotals=_getMonthlyTotals(filtered);
    emit(state.copyWith(selectedFilter: event.filter,
    filteredExpenses: filtered,
      monthlyTotals: monthlyTotals,
    ));
  }
  );
  }
  @override
  Future<void> close()
  {
    _subscription?.cancel();
    return super.close();
  }
  Map<String,double> _getMonthlyTotals(List<Expense> expenses)
  {
    final Map<String,double> data={};
    for(var e in expenses)
      {
        final key="${e.date.year}-${e.date.month}";
        data[key]=(data[key]?? 0)+e.amount;
      }
    return data;
  }
  List<Expense> _filterExpenses
      (
      List<Expense> expenses,TimeFilter filter)
  {
    final now=DateTime.now();
    return expenses.where((e){
      final diff=now.difference(e.date).inDays;
      switch(filter)
          {
        case TimeFilter.weekly:
          return diff<=7;
        case TimeFilter.monthly:
          return e.date.month == now.month && e.date.year== now.year;
        case TimeFilter.yearly:
          return e.date.year ==now.year;
      }
    }).toList();
  }

}
class _ExpensesUpdated extends ExpenseEvent {
  final List<Expense> expenses;

  _ExpensesUpdated(this.expenses);
}