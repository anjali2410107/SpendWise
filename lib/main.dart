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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final firestore = FirebaseFirestore.instance;
    final firebaseAuth = FirebaseAuth.instance;

    final authRepository = AuthRepositoryImpl(firebaseAuth);
    final dataSource = ExpenseRemoteDataSource(firestore);
    final repository = ExpenseRepositoryImpl(dataSource);

    final userId = firebaseAuth.currentUser?.uid ?? '';

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc(authRepository)),
        BlocProvider(create: (_) => ExpenseBloc(repository)),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'SpendWise',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        routerConfig: AppRouter.router(userId),
      ),
    );
  }
}