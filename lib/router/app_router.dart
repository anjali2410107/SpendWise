import 'package:go_router/go_router.dart';
import 'package:spendwise/features/expense/presentation/screens/add_expense_screen.dart';
import 'package:spendwise/features/expense/presentation/screens/dashboard.dart';
import 'package:spendwise/features/expense/presentation/screens/edit_expense_screen.dart';
import 'package:spendwise/features/expense/presentation/screens/history_screen.dart';
import 'package:spendwise/features/expense/presentation/screens/splash_screen.dart';
import 'package:spendwise/main_shell.dart';

import '../features/expense/domain/entities/expense.dart';
import '../features/expense/presentation/screens/login_screen.dart';
import '../features/expense/presentation/screens/settings_screen.dart';
import '../features/expense/presentation/screens/signup_screen.dart';
class AppRouter {
  static GoRouter router(String userId) =>
      GoRouter(
    initialLocation: '/',
    routes:[
      GoRoute(path: '/',builder: (context,state) => const SplashScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/signup', builder: (context, state) => const SignUpScreen()),
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
      GoRoute(
        path: '/history',
        builder: (context, state) => HistoryScreen(userId: userId),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  ),
  ],
  );
}