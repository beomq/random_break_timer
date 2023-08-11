import 'package:flutter/material.dart';
import 'package:random_break_timer/ui/timer/timer_screen.dart';

class SettingScreen extends StatefulWidget {
  SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final goalTimeController = TextEditingController();

  final minBreakTimeController = TextEditingController();

  final maxBreakTimeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    goalTimeController.dispose();
    minBreakTimeController.dispose();
    maxBreakTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ramdom Timer'),
      ),
      body: Column(
        children: [
          Container(
            child: Column(
              children: [
                Text('목표시간'),
                TextField(
                  controller: goalTimeController,
                ),
              ],
            ),
          ),
          Container(
            child: Column(
              children: [
                Text('쉬는시간 범위'),
                Row(
                  children: [
                    Expanded(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              validator: (String? value) {
                                if (value == null) {
                                  return 'Please enter a value';
                                }

                                List<String> parts = value.split(':');

                                if (parts.length != 3) {
                                  return 'Please enter time in HH:MM:SS format';
                                }

                                int? hours = int.tryParse(parts[0]);
                                int? minutes = int.tryParse(parts[1]);
                                int? seconds = int.tryParse(parts[2]);

                                if (hours == null ||
                                    minutes == null ||
                                    seconds == null) {
                                  return 'Please enter valid numbers';
                                }

                                if (hours < 0 || hours > 23) {
                                  return 'Hours must be between 0 and 23';
                                }

                                if (minutes < 0 || minutes > 59) {
                                  return 'Minutes must be between 0 and 59';
                                }

                                if (seconds < 0 || seconds > 59) {
                                  return 'Seconds must be between 0 and 59';
                                }

                                return null; // The input is valid
                              },
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text('Processing Data')));
                                }
                              },
                              child: Text('Submit'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Expanded(
                      child: TextField(
                        controller: maxBreakTimeController,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TimerScreen(
                          goalStudyTime: goalTimeController.text,
                          minBreakTime: minBreakTimeController.text,
                          maxBreakTime: maxBreakTimeController.text,
                        )),
              );
            },
            child: Text('타이머 시작'),
          )
        ],
      ),
    );
  }
}
