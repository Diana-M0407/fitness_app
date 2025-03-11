import 'package:flutter/material.dart';
import 'package:fitnessapp/pages/workout.dart';
import 'package:fitnessapp/pages/calendar.dart';
import 'package:fitnessapp/pages/profile.dart';
import 'package:fitnessapp/pages/home.dart';


class NavigatorPage extends StatefulWidget {
  const NavigatorPage({super.key});

  @override
  State<NavigatorPage> createState() => _NavigatorPageState();
}

class _NavigatorPageState extends State<NavigatorPage> {
  int _selectedIndex = 0;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List _pages = [
    HomePage(),
    WorkoutPage(),
    CalendarPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Welcome!')),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type : BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _navigateBottomBar,
        items: [
        // home
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
          ),

        // workout
        BottomNavigationBarItem(
          icon: Icon(Icons.fitness_center),
          label: 'Workout',
          ),

        // calendar
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Calendar',
          ),

        // profile
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
          ),
        ],
      ),
    );
  }
}