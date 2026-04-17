import 'package:go_router/go_router.dart';
import 'package:spendwise/features/expense/presentation/screens/add_expense_screen.dart';
import 'package:spendwise/features/expense/presentation/screens/dashboard.dart';
class AppRouter {
  static GoRouter router(String userId) =>GoRouter
    (
    initialLocation: '/dashboard',
    routes: [
      GoRoute(path: '/dashboard',
builder: (context,state) =>
DashboardScreen(userId: userId),

),
GoRoute(path: '/add',
builder: (context,state) =>
AddExpenseScreen(userId: userId),
),
    ],
  );
}