import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:random_break_timer/data/model/duration_adapter.dart';
import 'package:random_break_timer/data/model/study_data.dart';
import 'package:random_break_timer/firebase_options.dart';
import 'package:random_break_timer/ui/auth/auth_gate.dart';

late final Box<StudyData> datas;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  } catch (e) {
    print("Firebase initialization error: $e");
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  User? user = auth.currentUser;
  await Hive.initFlutter();
  Hive.registerAdapter(StudyDataAdapter());
  Hive.registerAdapter(DurationAdapter());
  if (user != null) {
    try {
      datas = await Hive.openBox<StudyData>(user.uid);
    } catch (e) {
      print(e);
    }
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static const String name = 'Awesome Notifications - Example App';
  static const Color mainColor = Colors.deepPurple;

  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loading Screen Example',
      theme: ThemeData(
        primaryColor: const Color(0xffa8c7fa),
        fontFamily: 'MavenPro',
      ),
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
    );
  }
}
