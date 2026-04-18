import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:spendwise/features/expense/domain/repositories/expense_repository.dart';
import 'package:spendwise/features/expense/presentation/bloc/expense_event.dart';
import 'package:spendwise/features/expense/presentation/bloc/expense_state.dart';
import '../../domain/entities/expense.dart';

class ExpenseBloc extends Bloc<ExpenseEvent,ExpensesState>
{
  final ExpenseRepository repository;
  StreamSubscription? _subscription;
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
    {
      emit(state.copyWith(
        expenses:event.expenses,
        isLoading:false,
      ));
    });
    on<AddExpense>((event,emit)async
    {
      await repository.addExpense(event.expense, event.userId);
    });
    on<DeleteExpense>((event,emit) async
    {  print("Delete event triggered: ${event.expenseId}");
      await repository.deleteExpense(event.expenseId, event.userId);
    print("Deleted from repo");
    });
    on<UpdateExpense>((event,emit) async
    {
      await repository.updateExpense(event.expense, event.userId);
    });
  }
  @override
  Future<void> close()
  {
    _subscription?.cancel();
    return super.close();
  }
}
class _ExpensesUpdated extends ExpenseEvent {
  final List<Expense> expenses;

  _ExpensesUpdated(this.expenses);
}