import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';

import 'package:random_break_timer/ui/tab_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(const Color(0xffa8c7fa)),
            foregroundColor: MaterialStateProperty.all<Color>(
              const Color(0xff072f71),
            ),
            elevation: const MaterialStatePropertyAll(2),
          ),
        ),
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SignInScreen(
              providerConfigs: const [
                EmailProviderConfiguration(),
              ],
              headerBuilder: (context, constraints, _) {
                return const Center(
                  child: Text(
                    'random break timer',
                    style: TextStyle(fontSize: 40),
                  ),
                );
              },
            );
          }

          // Render your application if authenticated
          return const TabPage();
        },
      ),
    );
  }
}
