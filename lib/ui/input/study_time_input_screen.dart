import 'package:flutter/material.dart';
import 'package:random_break_timer/ui/main/main_screen.dart';
import 'package:random_break_timer/ui/widget/custom_button.dart';
import 'package:random_break_timer/ui/widget/custom_text_form_field.dart';

class StudyTimeInputScreen extends StatefulWidget {
  @override
  State<StudyTimeInputScreen> createState() => _StudyTimeInputScreenState();
}

class _StudyTimeInputScreenState extends State<StudyTimeInputScreen> {
  final TextEditingController studyTimeController = TextEditingController();

  final TextEditingController minBreakTimeController = TextEditingController();

  final TextEditingController maxBreakTimeController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    studyTimeController.dispose();
    minBreakTimeController.dispose();
    maxBreakTimeController.dispose();
    super.dispose();
  }

  Duration timeStringToSeconds(String timeString) {
    if (timeString.length == 5) {
      final parts = timeString.split(':');
      int minutes = int.parse(parts[0]);
      int seconds = int.parse(parts[1]);
      return Duration(minutes: minutes, seconds: seconds);
    } else {
      final parts = timeString.split(':');
      int hours = int.parse(parts[0]);
      int minutes = int.parse(parts[1]);
      int seconds = int.parse(parts[2]);
      return Duration(hours: hours, minutes: minutes, seconds: seconds);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Welcome to BreakSchedule!'),
            Text('a'),
            Form(
              key: formKey,
              child: Column(
                children: [
                  CustomTextFormField(
                    controller: studyTimeController,
                    hintText: '11:11:11',
                    labelText: '총공부시간',
                    validator: (String? value) {
                      if (!RegExp(r'^([01]\d|2[0-3]):([0-5]\d):([0-5]\d)$')
                          .hasMatch(value!)) {
                        return '00:00:00 ~ 23:59:59 사이의 시간을 입력해주세요';
                      }
                      return null;
                    },
                  ),
                  CustomTextFormField(
                    controller: minBreakTimeController,
                    hintText: '11:11',
                    labelText: '최소 쉬는시간',
                    validator: (String? value) {
                      if (!RegExp(r'^([0-5]?\d):([0-5]\d)$').hasMatch(value!)) {
                        return '00:01 ~ 59:59 사이의 시간을 입력해주세요';
                      }
                      return null;
                    },
                  ),
                  CustomTextFormField(
                    controller: maxBreakTimeController,
                    hintText: '11:11',
                    labelText: '최대 쉬는시간',
                    validator: (String? value) {
                      if (!RegExp(r'^([0-5]?\d):([0-5]\d)$').hasMatch(value!)) {
                        return '00:01 ~ 59:59 사이의 시간을 입력해주세요';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            CustomButton(
              onPressed: () {
                final formKeyState = formKey.currentState!;
                if (formKeyState.validate()) {
                  formKeyState.save();
                  final minTime =
                      timeStringToSeconds(minBreakTimeController.text);
                  final maxTime =
                      timeStringToSeconds(maxBreakTimeController.text);

                  if (minTime > maxTime) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('최대 쉬는시간은 항상 최소 쉬는시간 보다 커야 합니다'),
                        duration: Duration(seconds: 1), // 메시지 표시 시간 설정
                      ),
                    );
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TimerHomePage(
                              totalStudyTime:
                                  timeStringToSeconds(studyTimeController.text),
                              minBreakTime: timeStringToSeconds(
                                  minBreakTimeController.text),
                              maxBreakTime: timeStringToSeconds(
                                  maxBreakTimeController.text),
                            )),
                  );
                }
              },
              text: 'Start Study',
            ),
          ],
        ),
      ),
    ));
  }
}
