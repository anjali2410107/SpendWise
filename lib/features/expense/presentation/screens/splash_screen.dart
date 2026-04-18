import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State <SplashScreen> createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen>
{
  @override
  void initState()
  {
    super.initState();
    Timer(const Duration(seconds: 3),()
    {
      context.go('/dashboard');
    });
  }
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Color(0xFF0B1C24),
          Color(0xFF06141B),
          ],
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
        child: Opacity(
        opacity: 0.08,
            child:Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Colors.white,
                Colors.transparent,
                    ],
                )
              ),
            ),
            ),),
    Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.account_balance_wallet_rounded,
            color: Colors.white70,
              size: 34,
            ),
          ),
          const SizedBox(height: 25,),
          const Text("S P E N D W I S E",style: TextStyle(color: Colors.white70,
          fontSize: 20,
            letterSpacing: 4,
            fontWeight: FontWeight.w300,
          ),),
          const SizedBox(
            height: 10,
          ),
          const Text("THE FINANCIAL CURATOR",
            style: TextStyle(
              color: Colors.white38,
              fontSize: 10,
              letterSpacing: 2,)),

          const SizedBox(height: 40,),
          const CircularProgressIndicator(
            color: Colors.white70,
            strokeWidth: 2,
          ) ],

      ),

    ),
          ],
        ),
      ),
    );
  }
}