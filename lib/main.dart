import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:random_break_timer/data/model/study_data.dart';
import 'package:random_break_timer/ui/auth/auth_gate.dart';
import 'package:random_break_timer/ui/loading/loading_screen.dart';

late final Box<StudyData> datas;

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(StudyDataAdapter());
  datas = await Hive.openBox<StudyData>('todolist.db');
  runApp(MyApp());

  AwesomeNotifications().initialize(
      'resource://drawable/ic_stat_name',
      [
        NotificationChannel(
          channelKey: 'scheduled_channel',
          channelName: 'Scheduled Notifications',
          defaultColor: Colors.teal,
          locked: true,
          importance: NotificationImportance.High,
          channelDescription: '',
        )
      ],
      channelGroups: [
        NotificationChannelGroup(
            channelGroupkey: 'scheduled_channel_group',
            channelGroupName: 'Scheduled group')
      ],
      debug: true);
}

class MyApp extends StatefulWidget {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static const String name = 'Awesome Notifications - Example App';
  static const Color mainColor = Colors.deepPurple;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loading Screen Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoadingScreen(),
    );
  }
}
