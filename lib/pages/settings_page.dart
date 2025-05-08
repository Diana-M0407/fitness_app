import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitnessapp/theme/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String? _name;
  @override
  void initState() {
    super.initState();
    _loadName();
  }
  Future<void> _loadName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('displayName') ?? 'User';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: const Text('Settings'),
        title: Text('Settings - ${_name ?? ""}'),
        backgroundColor: Color(0xFFA71414),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // add at the top of your ListView children:
const Text('Profile', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
const SizedBox(height: 16),
TextFormField(
  initialValue: _name,
  decoration: const InputDecoration(labelText: 'Display Name'),
  onChanged: (v) => _name = v,
),
const SizedBox(height: 8),
ElevatedButton(
  onPressed: () async {
    final prefs = await SharedPreferences.getInstance();
    await FirebaseFirestore.instance
  .collection('users')
  .doc(FirebaseAuth.instance.currentUser!.uid)
  .set({'displayName': _name}, SetOptions(merge: true));

    await prefs.setString('displayName', _name ?? 'User');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Name updated!')),
    );
    setState(() {}); // refresh title
  },
  child: const Text('Save Name'),
),
const Divider(height: 48),

          const Text(
            'Appearance',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode),
            title: const Text('Dark Mode'),
            value: Provider.of<ThemeProvider>(context).isDarkMode,
            onChanged: (value) =>
                Provider.of<ThemeProvider>(context, listen: false)
                    .toggleTheme(),
          ),
          const Divider(height: 48),
          const Text(
            'App Info',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Version'),
            subtitle: const Text('1.0.0'),
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('Terms of Service'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Terms of Service coming soon!')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('Privacy Policy'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Privacy Policy coming soon!')),
              );
            },
          ),
        ],
      ),
    );
  }
}

