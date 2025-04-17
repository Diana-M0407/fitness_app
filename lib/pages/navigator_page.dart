import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fitnessapp/pages/workout.dart';
import 'package:fitnessapp/pages/calendar.dart';
import 'package:fitnessapp/pages/profile.dart';
import 'package:fitnessapp/pages/home.dart';
import 'package:provider/provider.dart';
import 'package:fitnessapp/theme/theme_provider.dart';
import 'package:fitnessapp/widgets/app_icon.dart';

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

// final List _pages = [
//   const HomePage(),
//   const WorkoutPage(),
//   const CalendarPage(),
//   const ProfilePage(),
// ];
//
// final List<String> _titles = [
//   'Home',
//   'Workout',
//   'Calendar',
//   'Profile',
// ];
//
// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     //appBar: AppBar(title: Text('Welcome!')),
//     appBar: AppBar(title:  Text(_titles[_selectedIndex])),
//     // drawer with theme switch
//     drawer: Drawer(
//       backgroundColor: Theme.of(context).colorScheme.surface,
//       child: Center(
//         child: newMethod(context),
//       ),
//     ),
//     body: _pages[_selectedIndex],
//     bottomNavigationBar: BottomNavigationBar(
//       type : BottomNavigationBarType.fixed,
//       currentIndex: _selectedIndex,
//       onTap: _navigateBottomBar,
//       items: [
//       // home
//       BottomNavigationBarItem(
//         icon: Icon(Icons.home),
//         label: 'Home',
//         ),
//
//       // workout
//       BottomNavigationBarItem(
//         icon: Icon(Icons.fitness_center),
//         label: 'Workout',
//         ),
//
//       // calendar
//       BottomNavigationBarItem(
//         icon: Icon(Icons.calendar_today),
//         label: 'Calendar',
//         ),
//
//       // profile
//       BottomNavigationBarItem(
//         icon: Icon(Icons.person),
//         label: 'Profile',
//         ),
//       ],
//     ),
//   );
// }
//
  CupertinoSwitch newMethod(BuildContext context) {
    return CupertinoSwitch(
      value: Provider.of<ThemeProvider>(context).isDarkMode,
      //value: ThemeProvider.isDarkMode,
      onChanged: (value) =>
          Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
    );
  }

  final List<Widget> _pages = [
    const HomePage(),
    const WorkoutPage(),
    const CalendarPage(),
    const ProfilePage(),
  ];

  final List<String> _titles = [
    'Home',
    'Workout',
    'Calendar',
    'Profile',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        centerTitle: true,
        backgroundColor: Colors.grey[700],
        //     leading: Builder(
        //       builder: (context) => IconButton(
        //       icon: const AppIcon(
        //         materialIcon: Icons.menu,
        //         svgPath: 'assets/icons/menu.svg',
        //         useCustom: false, //<---------------
        //         color: Colors.white,
        //       ),
        //       onPressed: () {
        //         //ScaffoldMessenger.of(context).showSnackBar(
        //         //  const SnackBar(content: Text("Menu tapped")),
        //         Scaffold.of(context).openDrawer();
        //       },
        //     ),
        //   ),
        actions: [
          IconButton(
            icon: const AppIcon(
              materialIcon: Icons.settings,
              svgPath: 'assets/icons/settings.svg',
              useCustom:
                  false, //<----Once you're ready to go full custom, just change to 'true'
              color: Colors.white,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Settings tapped")),
              );
            },
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.grey),
              child: Text(
                'Menu',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context); // closes drawer
                _navigateBottomBar(0);
                //_onItemTapped(0);
              },
            ),
            ListTile(
              leading: const Icon(Icons.fitness_center),
              title: const Text('Workout'),
              onTap: () {
                Navigator.pop(context);
                _navigateBottomBar(1);
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Calendar'),
              onTap: () {
                Navigator.pop(context);
                _navigateBottomBar(2);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                _navigateBottomBar(3);
              },
            ),
            const Divider(),
            SwitchListTile(
              secondary: const Icon(Icons.dark_mode),
              title: const Text("Dark Mode"),
              value: Provider.of<ThemeProvider>(context).isDarkMode,
              onChanged: (value) =>
                  Provider.of<ThemeProvider>(context, listen: false)
                      .toggleTheme(),
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _navigateBottomBar,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.fitness_center), label: 'Workout'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: 'Calendar'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
