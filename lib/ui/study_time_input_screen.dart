import 'package:flutter/material.dart';
import 'package:random_break_timer/ui/timer_screen.dart';

class StudyTimeInputScreen extends StatelessWidget {
  final TextEditingController studyTimeController = TextEditingController();
  final TextEditingController breakTimeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TextField(
              controller: studyTimeController,
              decoration: InputDecoration(hintText: "Enter Study Time"),
            ),
            TextField(
              controller: breakTimeController,
              decoration: InputDecoration(hintText: "Enter Break Time"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => TimerScreen(
                      studyTime: int.parse(studyTimeController.text),
                      breakTime: int.parse(breakTimeController.text),
                    ),
                  ),
                );
              },
              child: Text("Start"),
            ),
          ],
        ),
      ),
    );
  }
}
