import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:random_break_timer/data/model/duration_adapter.dart';
import 'package:random_break_timer/data/model/study_data.dart';
import 'package:random_break_timer/firebase_options.dart';
import 'package:random_break_timer/ui/loading/loading_screen.dart';

late final Box<StudyData> datas;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? user = auth.currentUser;
  await Hive.initFlutter();
  Hive.registerAdapter(StudyDataAdapter());
  Hive.registerAdapter(DurationAdapter());
  if (user != null) {
    try {
      datas = await Hive.openBox<StudyData>(user.uid);
    } catch (e) {
      print('Failed to open Hive box: $e');
    }
  }
  runApp(MyApp());
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
        primaryColor: const Color(0xffa8c7fa),
        fontFamily: 'MavenPro',
      ),
      home: LoadingScreen(),
    );
  }
}
