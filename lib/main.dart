import 'package:fitnessapp/pages/home.dart';
import 'package:fitnessapp/pages/workout.dart';
import 'package:flutter/material.dart';
import 'package:fitnessapp/pages/calendar.dart';
import 'package:fitnessapp/pages/profile.dart';
import 'package:fitnessapp/pages/navigator_page.dart';
import 'package:fitnessapp/theme/theme_provider.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const NavigatorPage(),
      theme: Provider.of<ThemeProvider>(context).themeData,
      routes: {
        '/navigator': (context) => const NavigatorPage(),
        '/home': (context) => const HomePage(),
        '/workout': (context) => const WorkoutPage(),
        '/calendar': (context) => const CalendarPage(),
        '/profile': (context) => const ProfilePage(),
      },
    );
  }
}