import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendwise/auth/data/firestore_datasource.dart';
import 'package:spendwise/features/expense/data/repositories/repository_implementation.dart';
import 'package:spendwise/features/expense/presentation/bloc/expense_bloc.dart';
import 'package:spendwise/router/app_router.dart';
import 'auth/data/auth_repository_impl.dart';
import 'auth/presentaion/bloc/auth_bloc.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}
class _MyAppState extends State<MyApp>
{
  final _auth=FirebaseAuth.instance;
   final _dataSource=ExpenseRemoteDataSource(FirebaseFirestore.instance);
  final _firestore = FirebaseFirestore.instance;
late  final _authRepository = AuthRepositoryImpl(_auth);
 late final _repository=ExpenseRepositoryImpl(_dataSource);
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc(_authRepository)),
        BlocProvider(create: (_) => ExpenseBloc(_repository)),
      ],
      child:StreamBuilder<User?>
        (stream: _auth.authStateChanges(),
          builder: (context,snapshot) {
            final userId = snapshot.data?.uid ??'';
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              title: 'SpendWise',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              ),
              routerConfig: AppRouter.router(userId),
            );
          },
      ),
    );
  }
}