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
      bottomNavigationBar:
      BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF0A3D4D),
          unselectedItemColor: Colors.grey,
          currentIndex: _getIndex(context),
          onTap: (index)
      {
        switch(index)
        {
          case 0:
      context.go('/dashboard');
      break;
      case 1:
      context.go('/add');
      break;
          case 2:
            context.go('/history');
            break;
            case 3:
            context.go('/settings');
            break;
            }
      },
      items: const[
        BottomNavigationBarItem(icon: Icon(Icons.dashboard),
          label: "Dashboard",
        ),
        BottomNavigationBarItem(icon:Icon (Icons.add),
          label: "Add",
        ),
        BottomNavigationBarItem(icon:Icon (Icons.history),
          label: "History",
        ), BottomNavigationBarItem(icon: Icon(Icons.settings),
        label: 'Settings',
        ),
      ],
    ),);
  }
  int _getIndex(BuildContext context)
  {
   final location=GoRouterState.of(context).uri.toString();
   if(location.startsWith('/dashboard')) return 0;
   if(location.startsWith('/add')) return 1;
   if(location.startsWith('/history')) return 2;
   if(location.startsWith('/settings')) return 3;
     return 0;

  }
}