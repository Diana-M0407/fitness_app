import 'package:fitnessapp/pages/calendar.dart';
import 'package:fitnessapp/pages/home.dart';
import 'package:fitnessapp/pages/navigator_page.dart';
import 'package:fitnessapp/pages/profile.dart';
import 'package:fitnessapp/pages/workout.dart';

import 'package:fitnessapp/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//import 'theme/theme_provider.dart';
//import 'pages/navigator_page.dart';



void main() {
  newMethod();
}

void newMethod() {
  return runApp(
  ChangeNotifierProvider(
    //create: (context) => ThemeProvider(),
    create:(_) => ThemeProvider(),
    //child: const MyApp(),
    child: const FitnessApp(),
  ),
);
}

class FitnessApp extends StatelessWidget {
  const FitnessApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fitness App',
      //theme: Provider.of<ThemeProvider>(context).themeData,
      theme: themeProvider.themeData,
      home: const NavigatorPage(),
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
