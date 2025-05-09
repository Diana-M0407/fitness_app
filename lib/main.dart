
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitnessapp/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fitnessapp/pages/navigator_page.dart';
import 'pages/home_page.dart';
import 'pages/workout_page.dart';
import 'pages/calendar_page.dart';
import 'pages/login_page.dart';
import 'package:fitnessapp/pages/profile_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Firebase setup

  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ??
      false; // ← Change this later with real auth logic
  final user = FirebaseAuth.instance.currentUser;
  final bool finalIsLoggedIn = isLoggedIn && user != null;
  final String displayName = prefs.getString('displayName') ?? '';


  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: FitnessApp(isLoggedIn: finalIsLoggedIn, name: displayName),
    ),
  );
}

class FitnessApp extends StatelessWidget {
  final bool isLoggedIn;
  final String name;
  const FitnessApp({super.key, required this.isLoggedIn, required this.name});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fitness App',
      theme: themeProvider.themeData,
      home: isLoggedIn
          ? NavigatorPage(name: name) : LoginPage(), // pass the name here
      routes: {
        '/navigator': (context) => NavigatorPage(),
        '/home': (context) => HomePage(),
        '/workout': (context) => const WorkoutPage(),
        '/calendar': (context) => const CalendarPage(),
        '/profile': (context) => const ProfilePage(),
        //'/profile': (context) => HomePage(),
      },
    );
  }
}
