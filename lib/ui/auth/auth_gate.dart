import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutterfire_ui/auth.dart';
import 'dart:io' show Platform;

import 'package:random_break_timer/ui/main/main_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String? clientId;
    if (Platform.isIOS) {
      clientId = dotenv.env['APPLE_CLIENT_ID'];
    } else if (Platform.isAndroid) {
      clientId = dotenv.env['ANDROID_CLIENT_ID'];
    } else {
      clientId = '';
    }

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SignInScreen(
            providerConfigs: [
              const EmailProviderConfiguration(),
              GoogleProviderConfiguration(
                clientId: '$clientId',
              ),
              const AppleProviderConfiguration(),
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
        return TimerHomePage();
      },
    );
  }
}
