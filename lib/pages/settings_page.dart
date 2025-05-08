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














//import 'package:flutter/material.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//
//// --- DISPLAY PAGE ---
//class ProfilePage extends StatefulWidget {
//  const ProfilePage({super.key});
//
//  @override
//  _ProfilePageState createState() => _ProfilePageState();
//}
//
//class _ProfilePageState extends State<ProfilePage> {
//  bool _loading = true;
//  String _name = '';
//  String _email = '';
//  String _weight = '';
//  String _goal = '';
//  String _gender = '';
//  String _disability = '';
//
//  @override
//  void initState() {
//    super.initState();
//    _loadProfile();
//  }
//
//  Future<void> _loadProfile() async {
//    setState(() => _loading = true);
//    final user = FirebaseAuth.instance.currentUser;
//    if (user != null) {
//      _name    = user.displayName ?? '';
//      _email   = user.email ?? '';
//      final doc = await FirebaseFirestore.instance
//          .collection('users')
//          .doc(user.uid)
//          .get();
//      if (doc.exists) {
//        final data = doc.data()!;
//        _weight     = data['currentWeight']?.toString() ?? '';
//        _goal       = data['weightGoal']?.toString()   ?? '';
//        _gender     = data['gender']                   ?? '';
//        _disability = data['disability']              ?? '';
//      }
//    }
//    setState(() => _loading = false);
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    if (_loading) {
//      return const Scaffold(
//        body: Center(child: CircularProgressIndicator()),
//      );
//    }
//    return Scaffold(
//      appBar: AppBar(title: const Text('My Profile')),
//      body: Padding(
//        padding: const EdgeInsets.all(16),
//        child: Column(
//          crossAxisAlignment: CrossAxisAlignment.start,
//          children: [
//            Text('Name: $_name'),
//            Text('Email: $_email'),
//            const SizedBox(height: 8),
//            if (_weight.isNotEmpty) Text('Current Weight: $_weight lbs'),
//            if (_goal.isNotEmpty)   Text('Weight Goal: $_goal lbs'),
//            if (_gender.isNotEmpty) Text('Gender: $_gender'),
//            if (_disability.isNotEmpty) ...[
//              const SizedBox(height: 8),
//              Text('Disability: $_disability'),
//            ],
//            const Spacer(),
//            Center(
//              child: ElevatedButton(
//                onPressed: () async {
//                  await Navigator.push(
//                    context,
//                    MaterialPageRoute(builder: (_) => const EditProfilePage()),
//                  );
//                  await _loadProfile(); // refresh display
//                },
//                child: const Text('Edit Info'),
//              ),
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//}
//
//// --- EDIT PAGE ---
//class EditProfilePage extends StatefulWidget {
//  const EditProfilePage({super.key});
//
//  @override
//  _EditProfilePageState createState() => _EditProfilePageState();
//}
//
//class _EditProfilePageState extends State<EditProfilePage> {
//  final _formKey               = GlobalKey<FormState>();
//  final _weightController      = TextEditingController();
//  final _goalController        = TextEditingController();
//  final _disabilityController  = TextEditingController();
//  String _gender               = 'Male';
//
//  bool _saving = false;
//
//  @override
//  void initState() {
//    super.initState();
//    _loadExisting();
//  }
//
//  Future<void> _loadExisting() async {
//    final user = FirebaseAuth.instance.currentUser;
//    if (user != null) {
//      final doc = await FirebaseFirestore.instance
//          .collection('users')
//          .doc(user.uid)
//          .get();
//      if (doc.exists) {
//        final data = doc.data()!;
//        _weightController.text     = data['currentWeight']?.toString() ?? '';
//        _goalController.text       = data['weightGoal']?.toString()   ?? '';
//        _gender                    = data['gender']                   ?? _gender;
//        _disabilityController.text = data['disability']              ?? '';
//      }
//    }
//    setState(() {});
//  }
//
//  Future<void> _saveProfile() async {
//    if (!_formKey.currentState!.validate()) return;
//    final user = FirebaseAuth.instance.currentUser;
//    if (user == null) return;
//
//    setState(() => _saving = true);
//    await FirebaseFirestore.instance
//        .collection('users')
//        .doc(user.uid)
//        .set({
//          'currentWeight': double.parse(_weightController.text),
//          'weightGoal':    double.parse(_goalController.text),
//          'gender':        _gender,
//          'disability':    _disabilityController.text,
//        }, SetOptions(merge: true));
//    final prefs = await SharedPreferences.getInstance();
//    await prefs.setBool('profileComplete', true);
//
//    if (mounted) Navigator.pop(context);
//  }
//
//  @override
//  void dispose() {
//    _weightController.dispose();
//    _goalController.dispose();
//    _disabilityController.dispose();
//    super.dispose();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(title: const Text('Edit Profile')),
//      body: Padding(
//        padding: const EdgeInsets.all(16),
//        child: Form(
//          key: _formKey,
//          child: ListView(
//            children: [
//              TextFormField(
//                controller: _weightController,
//                decoration: const InputDecoration(labelText: 'Current Weight (lbs)'),
//                keyboardType: TextInputType.number,
//                validator: (v) => (v?.isEmpty ?? true) ? 'Enter your weight' : null,
//              ),
//              const SizedBox(height: 16),
//              TextFormField(
//                controller: _goalController,
//                decoration: const InputDecoration(labelText: 'Weight Goal (lbs)'),
//                keyboardType: TextInputType.number,
//                validator: (v) => (v?.isEmpty ?? true) ? 'Enter goal weight' : null,
//              ),
//              const SizedBox(height: 16),
//              const Text('Gender'),
//              Row(children: [
//                Expanded(child: RadioListTile(
//                  title: const Text('Male'), value: 'Male',
//                  groupValue: _gender,
//                  onChanged: (v) => setState(() => _gender = v!),
//                )),
//                Expanded(child: RadioListTile(
//                  title: const Text('Female'), value: 'Female',
//                  groupValue: _gender,
//                  onChanged: (v) => setState(() => _gender = v!),
//                )),
//              ]),
//              const SizedBox(height: 16),
//              TextFormField(
//                controller: _disabilityController,
//                decoration: const InputDecoration(labelText: 'Disability Info (if any)'),
//                maxLines: 3,
//              ),
//              const SizedBox(height: 24),
//              ElevatedButton(
//                onPressed: _saving ? null : _saveProfile,
//                child: _saving
//                    ? const SizedBox(
//                        width: 20, height: 20,
//                        child: CircularProgressIndicator(strokeWidth: 2),
//                      )
//                    : const Text('Save changes'),
//              ),
//            ],
//          ),
//        ),
//      ),
//    );
//  }
//}
//