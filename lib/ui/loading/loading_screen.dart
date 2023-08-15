import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:random_break_timer/ui/input/study_time_input_screen.dart';
import 'package:random_break_timer/ui/main/main_screen.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  Future<void> loadApp() async {
    await Future.delayed(const Duration(milliseconds: 2000), () {});
  }

  @override
  void initState() {
    super.initState();

    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('알람 권한'),
            content: const Text('열정 샤워 앱에서 알람 권한을 요청'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  '거절',
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
              ),
              TextButton(
                onPressed: () => AwesomeNotifications()
                    .requestPermissionToSendNotifications()
                    .then((_) => Navigator.pop(context)),
                child: const Text(
                  '허락',
                  style: TextStyle(
                    color: Colors.indigo,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      }
    });
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
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    '집중하세요',
                    style: TextStyle(fontSize: 40),
                  ),
                ],
              ),
            ),
          );
        } else {
          return StudyTimeInputScreen();
        }
      },
    );
  }
}
