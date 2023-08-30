import 'package:flutter/material.dart';
import 'package:random_break_timer/ui/widget/custom_button.dart';
import 'package:random_break_timer/ui/widget/custom_text_form_field.dart';

class StudyTimeInputScreen extends StatefulWidget {
  final Function(Duration, Duration, Duration) onStudyStart;

  const StudyTimeInputScreen({super.key, required this.onStudyStart});

  @override
  State<StudyTimeInputScreen> createState() => _StudyTimeInputScreenState();
}

class _StudyTimeInputScreenState extends State<StudyTimeInputScreen> {
  final TextEditingController studyTimeController = TextEditingController();

  final TextEditingController pomodoroController = TextEditingController();

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
        body: SingleChildScrollView(
      child: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Welcome to \nRandom Break Timer!',
                style: TextStyle(
                    fontSize: 24,
                    fontFamily: 'MavenPro',
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                '얼마나 쉬어야 공부 효율이 좋을까요? \n내가 설정한 범위 내의 랜덤한 시간이 쉬는시간으로 주어집니다.',
                style: TextStyle(fontSize: 13),
              ),
              const SizedBox(
                height: 100,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      CustomTextFormField(
                        controller: studyTimeController,
                        hintText: 'ex) 12:00:00',
                        labelText: 'Total Study Time',
                        validator: (String? value) {
                          if (!RegExp(r'^([01]\d|2[0-3]):([0-5]\d):([0-5]\d)$')
                              .hasMatch(value!)) {
                            return '00:00:00 ~ 23:59:59 사이의 시간을 입력해주세요';
                          }
                          return null;
                        },
                        icon: Icons.timer_sharp,
                      ),
                      // CustomTextFormField(
                      //   controller: pomodoroController,
                      //   hintText: 'ex) 15:00',
                      //   labelText: 'Pomodoro',
                      //   validator: (String? value) {
                      //     if (!RegExp(r'^([0-5]?\d):([0-5]\d)$')
                      //         .hasMatch(value!)) {
                      //       return '00:01 ~ 59:59 사이의 시간을 입력해주세요';
                      //     }
                      //     return null;
                      //   },
                      //   icon: Icons.tips_and_updates_outlined,
                      // ),
                      CustomTextFormField(
                        controller: minBreakTimeController,
                        hintText: 'ex) 15:00',
                        labelText: 'Min Break Time',
                        validator: (String? value) {
                          if (!RegExp(r'^([0-5]?\d):([0-5]\d)$')
                              .hasMatch(value!)) {
                            return '00:01 ~ 59:59 사이의 시간을 입력해주세요';
                          }
                          return null;
                        },
                        icon: Icons.local_cafe_outlined,
                      ),
                      CustomTextFormField(
                        controller: maxBreakTimeController,
                        hintText: 'ex) 20:00',
                        labelText: 'Max Break Time',
                        validator: (String? value) {
                          if (!RegExp(r'^([0-5]?\d):([0-5]\d)$')
                              .hasMatch(value!)) {
                            return '00:01 ~ 59:59 사이의 시간을 입력해주세요';
                          }
                          return null;
                        },
                        icon: Icons.local_cafe,
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: CustomButton(
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
                      widget.onStudyStart(
                        timeStringToSeconds(studyTimeController.text),
                        timeStringToSeconds(minBreakTimeController.text),
                        timeStringToSeconds(maxBreakTimeController.text),
                      );
                    }
                  },
                  text: 'Start Study',
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
