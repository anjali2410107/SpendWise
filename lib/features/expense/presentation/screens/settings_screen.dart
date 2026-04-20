
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spendwise/auth/presentaion/bloc/auth_bloc.dart';
import 'package:spendwise/auth/presentaion/bloc/auth_event.dart';

class SettingsScreen extends StatefulWidget{
  const  SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() =>_SettingsScreenState();
}
class _SettingsScreenState extends State<SettingsScreen>
{
  bool isDarkMode=false;
  bool biometric=true;
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10,),
            _buildProfile(),
            const SizedBox(height: 20),

            _buildPreferences(),

            const SizedBox(height: 20),

            _buildSecurity(),

            const SizedBox(height: 20),

            _buildFooter(),
          ],
        ),
      ),
    );
  }
  Widget _chip(String text,Color color)
  {
    return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 4),
  decoration: BoxDecoration(
  color: color.withOpacity(0.1),
  borderRadius: BorderRadius.circular(20),
  ),
  child: Text(
  text,
  style: TextStyle(color: color, fontSize: 10),  ),
    );
}
  Widget _buildProfile()
  {
    final user=FirebaseAuth.instance.currentUser;
    final String email=user?.email??"";
     String name;
     if(user?.displayName!=null&&
     user!.displayName!.isNotEmpty
     )
       {
         name=user.displayName!;
       }
     else if(email.isNotEmpty)
       {
         name=email.split('@')[0];
       }
     else
       {
         name="User";
       }
    String initial=name.isNotEmpty
    ? name[0].toUpperCase()
        :"U";
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: _getAvatarColor(initial),
          child: Text(initial,
          style: const TextStyle(
            fontWeight: FontWeight.bold,fontSize: 28,color: Colors.white,
          ),),
        ),
        const SizedBox(height: 10,),
        Text(name,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4,),
        Text(email,style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
  Widget _buildPreferences()
  {
    return _section(
      title:"PREFERENCES",
      children:[
        _tile(
          icon:Icons.dark_mode,
          title:"Dark Mode",
          subtitle:"Follow system theme",
          trailing: Switch(
            value: isDarkMode,
            onChanged: (val){
              setState(() =>
                isDarkMode=val);
              })
    ),
    _tile(
      icon:Icons.attach_money,
    title:"Currency",
    trailing:const Text("USD"),
  ),
  _tile(
  icon:Icons.notifications,
    title:"Notifications Settings",
    subtitle:"Manage Alerts",

          ),],
        );


  }
  Widget _buildSecurity()
  {
    return _section(
      title:"SECURITY",
      children:[
        _tile(
          icon:Icons.lock,
          title:"Change Password",
        ),
        _tile(
          icon:Icons.fingerprint,
          title:"Biometruc Login",
          subtitle:"Enabled",
          trailing:Switch(value:
          biometric,
          onChanged:(val)
            {
              setState(() =>biometric=val
              );}),

        ),
    _tile(icon:Icons.logout,
    title:"Log Out",
  textColor:Colors.red,
    onTap:()
    async
  {
    context.read<AuthBloc>().add(LogoutEvent());
    context.go('/login');
  }
    ),
      ],
    );
  }
  Widget _buildFooter()
  {
    return Column(
      children: [
        const CircleAvatar(
          radius: 25,
          backgroundColor: Color(0xFF0A3D4D),
          child: Text("SW",style: TextStyle(color: Colors.white),),
        ),
        const SizedBox(height: 10,),
        const Text("SpendWise Premium"),
        const SizedBox(height: 4,),
      const Text(
        "Version 4.2.1",
        style: TextStyle(color: Colors.grey),
      ),
        const SizedBox(height: 10,),
        const Text("Terms of Service & Privacy Policy ",
    style: TextStyle(fontSize: 12,
    color: Colors.grey,
    ),),
    const SizedBox(height: 10,),
  ElevatedButton(

      style:ElevatedButton.styleFrom(
  backgroundColor: const Color(0xFF0A3D4D),
  shape: RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(20),
  ),
  ),
  onPressed: (){},
      child: const Text("Check for Updates",style: TextStyle(color: Colors.white),),
  ),
        const SizedBox(height: 30,),
      ],
    );
  }
  Widget _section({required String title,required List<Widget> children})
  {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text(title,style: TextStyle(fontSize: 12,
        color: Colors.grey
        ),),
        const SizedBox(height: 10,),
          ...children,
        ],
      ),
    );
  }
Widget _tile({
    required IconData icon,
  required String title,
  String? subtitle,
  Widget? trailing,
  VoidCallback? onTap,
  Color textColor=Colors.black,
})
{
  return ListTile(
    onTap: onTap,
    leading: CircleAvatar(
      backgroundColor: Colors.grey.shade200,
      child: Icon(icon,color: Colors.black,),
    ),
    title:Text(
      title,
      style: TextStyle(color: textColor),
    ),
    subtitle: subtitle !=null ? Text(subtitle):null,
    trailing: trailing??
        const Icon(Icons.arrow_forward_ios,size: 16,),
  );
}
Color _getAvatarColor(String input)
{
  final colors =[
    Color(0xFF0A3D4D),
    Color(0xFF1B5E20),
    Color(0xFF7A0C0C),
    Color(0xFF3C6E71),
    Color(0xFF6A1B9A),
    Color(0xFFEF6C00),  ];
  final index=input.codeUnitAt(0)%colors.length;
  return colors[index];
}
}