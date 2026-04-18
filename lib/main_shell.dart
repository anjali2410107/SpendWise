import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainShell extends StatelessWidget{
  final Widget child;
  const MainShell({super.key,required this.child});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _getIndex(context),
          onTap: (index)
      {
      if(index==0)
      {
      context.go('/dashboard');
      }
      else
      context.go('/add');
      },
      items: const[
        BottomNavigationBarItem(icon: Icon(Icons.dashboard),
          label: "Dashboard",
        ),
        BottomNavigationBarItem(icon:Icon (Icons.add),
          label: "Add",
        ),
      ],
    ),);
  }
  int _getIndex(BuildContext context)
  {
   final location=GoRouterState.of(context).uri.toString();
   if(location =='/add') return 1;
     return 0;

  }
}