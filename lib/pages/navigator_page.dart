import 'package:fitnessapp/pages/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fitnessapp/pages/workout_page.dart';
import 'package:fitnessapp/pages/calendar_page.dart';
import 'package:fitnessapp/pages/profile_page.dart';
import 'package:fitnessapp/pages/home_page.dart';
import 'package:provider/provider.dart';
import 'package:fitnessapp/theme/theme_provider.dart';
import 'package:fitnessapp/widgets/app_icon.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings_page.dart';

class NavigatorPage extends StatefulWidget {
  final String? name; //Nullable to avoid issues when coming from login
  const NavigatorPage({super.key, this.name});

  @override
  State<NavigatorPage> createState() => _NavigatorPageState();
}

class _NavigatorPageState extends State<NavigatorPage> {
  int _selectedIndex = 0;
  String _currentName = '';

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadName();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final name = ModalRoute.of(context)!.settings.arguments as String?;
      if (name != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Welcome, $name! Ready to work out?')),
        );
      }
    });
  }

  String _generateGreeting() {
    final hour = DateTime.now().hour;
    String greeting;

    if (hour < 12) {
      greeting = 'Good morning';
    } else if (hour < 18) {
      greeting = 'Good afternoon';
    } else {
      greeting = 'Good evening';
    }

    if (_currentName.isNotEmpty) {
      return '$greeting, $_currentName!';
    } else {
      return '$greeting!';
    }
  }

  CupertinoSwitch newMethod(BuildContext context) {
    return CupertinoSwitch(
      value: Provider.of<ThemeProvider>(context).isDarkMode,
      //value: ThemeProvider.isDarkMode,
      onChanged: (value) =>
          Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
    );
  }

  final List<Widget> _pages = [
    HomePage(),
    const WorkoutPage(),
    const CalendarPage(),
    const ProfilePage(),
  ];

  Widget _buildSettingsButton(BuildContext context) {
    return IconButton(
      tooltip: 'Settings',
      icon: const AppIcon(
        materialIcon: Icons.settings,
        svgPath: 'assets/icons/settings.svg',
        useCustom: false,
        color: Colors.white,
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SettingsPage()),
        );
      },
    );
  }

  Future<void> _loadName() async {
    final prefs = await SharedPreferences.getInstance();
    // 1) try the passed‐in name, 2) fall back to prefs, 3) finally empty
    final fromParam = widget.name ?? '';
    final fromPrefs = prefs.getString('displayName') ?? '';
    setState(() {
      _currentName = fromParam.isNotEmpty ? fromParam : fromPrefs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: const Color(0xFFA71414),
        centerTitle: false, // Don't center greeting anymore
        title: Text(
          _generateGreeting(),
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: const Color.fromARGB(179, 45, 4, 60),
              ),
        ),
        actions: [
         // _buildSettingsButton(context),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsPage()),
            ),
          )
        ],
        //overflow: TextOverflow.ellipsis,
        //style: const TextStyle(fontSize: 18)),
      ),
      drawer: Drawer(
        child: ListView(
          //padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFFA71414)),
              child: Text(
                'Menu',
                style: TextStyle(fontSize: 45, color: Colors.black),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
                _navigateBottomBar(0);
                //Navigator.push(
                //    context,
                //    MaterialPageRoute(
                //        builder: (_) => const HomePage())); // closes drawer
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
            // 4) Re-add your Settings item in the drawer:
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsPage()),
                );
              },
            ),
            const Divider(),
            ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Log Out'),
                onTap: () async {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => const Dialog(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      child: Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text(
                              "Logging you out...",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );

                  // Sign out
                  try {
                    await FirebaseAuth.instance.signOut();
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('isLoggedIn', false);
                    await prefs.remove('displayName');

                    // Give spinner a short moment: bried pause for smoother UX
                    await Future.delayed(const Duration(milliseconds: 500));

                    if (context.mounted) {
                      Navigator.of(context).pop(); // close spinner dialog
                      //Navigator.pushReplacementNamed(context, '/');
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                        (route) => false,
                      );
                    }
                  } catch (e) {
                    Navigator.of(context).pop(); // Remove spinner
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Logout failed')),
                    );
                  }
                }),
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
