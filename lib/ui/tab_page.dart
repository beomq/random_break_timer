import 'package:flutter/material.dart';
import 'package:random_break_timer/ui/input/study_time_input_screen.dart';
import 'package:random_break_timer/ui/main/main_screen.dart';
import 'package:random_break_timer/ui/my_page/my_page_screen.dart';

class TabPage extends StatefulWidget {
  const TabPage({Key? key}) : super(key: key);

  @override
  State<TabPage> createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  int _currentIndex = 0;
  Duration? totalStudyTime;
  Duration? minBreakTime;
  Duration? maxBreakTime;

  List<Widget> get _pages {
    return [
      StudyTimeInputScreen(onStudyStart: _onStudyStart),
      (totalStudyTime != null && minBreakTime != null && maxBreakTime != null)
          ? TimerHomePage(
              totalStudyTime: totalStudyTime!,
              minBreakTime: minBreakTime!,
              maxBreakTime: maxBreakTime!,
              onMyPage: () {
                _onMyPage();
              },
            )
          : TimerHomePage(
              totalStudyTime: Duration(),
              minBreakTime: Duration(),
              maxBreakTime: Duration(),
              onMyPage: () {
                _onMyPage();
              },
            ),
      MyPageScreen()
    ];
  }

  void _onStudyStart(Duration total, Duration min, Duration max) {
    setState(() {
      totalStudyTime = total;
      minBreakTime = min;
      maxBreakTime = max;
      _currentIndex = 1;
    });
  }

  void _onMyPage() {
    setState(() {
      _currentIndex = 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.refresh),
            label: 'Refresh',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: 'Timer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'My Page',
          ),
        ],
      ),
    );
  }
}
