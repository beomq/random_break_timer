import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:random_break_timer/ui/auth/auth_gate.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  Future<void> loadApp() async {
    await Future.delayed(const Duration(milliseconds: 2000), () {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadApp(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset('assets/Lottie1.json',
                      height: 200, fit: BoxFit.cover),
                ],
              ),
            ),
          );
        } else {
          return const AuthGate();
        }
      },
    );
  }
}
