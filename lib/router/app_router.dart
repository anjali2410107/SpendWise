import 'package:go_router/go_router.dart';
import 'package:spendwise/features/expense/presentation/screens/add_expense_screen.dart';
import 'package:spendwise/features/expense/presentation/screens/dashboard.dart';
import 'package:spendwise/features/expense/presentation/screens/edit_expense_screen.dart';
import 'package:spendwise/features/expense/presentation/screens/splash_screen.dart';
import 'package:spendwise/main_shell.dart';

import '../features/expense/domain/entities/expense.dart';
class AppRouter {
  static GoRouter router(String userId) =>
      GoRouter(
    initialLocation: '/',
    routes:[
      GoRoute(path: '/',builder: (context,state) => const SplashScreen()),
      ShellRoute(builder: (context,state,child)
      {
        return MainShell(child: child);
      },
    routes: [
      GoRoute(
  path: '/dashboard',
builder: (context,state) =>
DashboardScreen(userId: userId),

),
GoRoute(path: '/add',
builder: (context,state) =>
AddExpenseScreen(userId: userId),
),
      GoRoute(path: '/edit',
      builder: (context,state)
      {
        final expense=state.extra as Expense;
        return EditExpenseScreen(expense: expense, userId: userId);
      }
      ),
    ],
  ),
  ],
  );
}