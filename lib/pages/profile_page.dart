//import 'package:flutter/material.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:shared_preferences/shared_preferences.dart';//

//class ProfilePage extends StatefulWidget {
//  const ProfilePage({super.key});//

//  @override
//  _ProfilePageState createState() => _ProfilePageState();
//}//

//class _ProfilePageState extends State<ProfilePage> {
//  //–– Controllers & state ––
//  final _formKey = GlobalKey<FormState>();
//  final _nameController = TextEditingController();
//  final _emailController = TextEditingController();
//  final _weightController = TextEditingController();
//  final _goalController = TextEditingController();
//  final _disabilityController = TextEditingController();
//  String _gender = 'Male';//

//  //bool _isEditing = false;  // ← toggle between summary & form
//  bool _loading = true;
//  bool _profileComplete = false;//

//  @override
//  void initState() {
//    super.initState();
//    _loadProfile();
//  }//

//  Future<void> _loadProfile() async {
//    final prefs = await SharedPreferences.getInstance();
//    _profileComplete = prefs.getBool('profileComplete') ?? false;//

//    final user = FirebaseAuth.instance.currentUser;
//    //if (user == null) return;
//    if (user != null && _profileComplete) {
//      final doc = await FirebaseFirestore.instance
//          .collection('users')
//          .doc(user.uid)
//          .get();
//      if (doc.exists) {
//        final data = doc.data()!;
//        _weightController.text = data['currentWeight']?.toString() ?? '';
//        _goalController.text = data['weightGoal']?.toString() ?? '';
//        _gender = data['gender'] ?? _gender;
//        _disabilityController.text = data['disability'] ?? '';
//      }
//    }
//    setState(() => _loading = false);
//  }//

//  Future<void> _saveProfile() async {
//    if (!_formKey.currentState!.validate()) return;
//    final user = FirebaseAuth.instance.currentUser;
//    if (user == null) return;//

//    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
//      'currentWeight': double.parse(_weightController.text),
//      'weightGoal': double.parse(_goalController.text),
//      'gender': _gender,
//      'disability': _disabilityController.text,
//    }, SetOptions(merge: true)); // ← preserves email/password//

//    final prefs = await SharedPreferences.getInstance();
//    await prefs.setBool('profileComplete', true);//

//    ScaffoldMessenger.of(context)
//        .showSnackBar(const SnackBar(content: Text('Info added!')));//

//    // Switch back to summary view
//    setState(() => _profileComplete = true);
//  }//
//

//@override
//  Widget build(BuildContext context) {
//    if (_loading) {
//      return const Scaffold(
//        body: Center(child: CircularProgressIndicator()),
//      );
//    }//

//    // 1) If profile not complete → show form
//    if (!_profileComplete) {
//      return Scaffold(
//        appBar: AppBar(title: const Text('Complete your profile')),
//        body: Padding(
//          padding: const EdgeInsets.all(16),
//          child: Form(
//            key: _formKey,
//            child: ListView(children: [
//              TextFormField(
//                controller: _weightController,
//                decoration: const InputDecoration(labelText: 'Current Weight (lbs)'),
//                keyboardType: TextInputType.number,
//                validator: (v) => (v == null || v.isEmpty)
//                  ? 'Please enter your current weight' : null,
//              ),
//              const SizedBox(height: 16),
//              TextFormField(
//                controller: _goalController,
//                decoration: const InputDecoration(labelText: 'Weight Goal (lbs)'),
//                keyboardType: TextInputType.number,
//                validator: (v) => (v == null || v.isEmpty)
//                  ? 'Please enter your weight goal' : null,
//              ),
//              const SizedBox(height: 16),
//              const Text('Gender', style: TextStyle(fontWeight: FontWeight.bold)),
//              Row(children: [
//                Expanded(child: RadioListTile(
//                  title: const Text('Male'),
//                  value: 'Male',
//                  groupValue: _gender,
//                  onChanged: (v) => setState(() => _gender = v!),
//                )),
//                Expanded(child: RadioListTile(
//                  title: const Text('Female'),
//                  value: 'Female',
//                  groupValue: _gender,
//                  onChanged: (v) => setState(() => _gender = v!),
//                )),
//              ]),
//              const SizedBox(height: 16),
//              TextFormField(
//                controller: _disabilityController,
//                decoration: const InputDecoration(labelText: 'Disability Info'),
//                maxLines: 3,
//              ),
//              const SizedBox(height: 24),
//              ElevatedButton(
//                onPressed: _saveProfile,
//                child: const Text('Done'),
//              ),
//            ]),
//          ),
//        ),
//      );
//    }//

//    // 2) Otherwise → show read-only profile + “Edit” button
//    return Scaffold(
//      appBar: AppBar(title: const Text('Your Profile')),
//      body: Padding(
//        padding: const EdgeInsets.all(16),
//        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//          Text('Current Weight: ${_weightController.text} lbs'),
//          Text('Weight Goal:    ${_goalController.text} lbs'),
//          Text('Gender:         $_gender'),
//          Text('Disability:     ${_disabilityController.text.isEmpty ? 'None' : _disabilityController.text}'),
//          const Spacer(),
//          Center(
//            child: ElevatedButton(
//              child: const Text('Edit Profile'),
//              onPressed: () {
//                setState(() => _profileComplete = false);
//              },
//            ),
//          ),
//        ]),
//      ),
//    );
//  }
//}//
//
//

// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(
//       title: Text(_isEditing ? 'Update Profile' : 'My Profile'),
//       actions: [
//         if (!_isEditing)
//           IconButton(
//             icon: const Icon(Icons.edit),
//             onPressed: () => setState(() => _isEditing = true),
//           )
//       ],
//     ),
//     body: _isEditing ? _buildForm() : _buildSummary(),
//   );
// }//

// Widget _buildSummary() {
//   return Padding(
//     padding: const EdgeInsets.all(16),
//     child: ListView(
//       children: [
//         Text('Name: ${_nameController.text}'),
//         Text('Email: ${_emailController.text}'),
//         const SizedBox(height: 8),
//         if (_weightController.text.isNotEmpty)
//           Text('Current Weight: ${_weightController.text} lbs'),
//         if (_goalController.text.isNotEmpty)
//           Text('Weight Goal: ${_goalController.text} lbs'),
//         Text('Gender: $_gender'),
//         if (_disabilityController.text.isNotEmpty) ...[
//           const SizedBox(height: 8),
//           Text('Disability Notes:\n${_disabilityController.text}'),
//         ],
//       ],
//     ),
//   );
// }//

// Widget _buildForm() {
//   return Padding(
//     padding: const EdgeInsets.all(16),
//     child: Form(
//       key: _formKey,
//       child: ListView(
//         children: [
//           // Name & Email (read-only)
//           TextFormField(
//             controller: _nameController,
//             decoration: const InputDecoration(labelText: 'Name'),
//             readOnly: true,
//           ),
//           TextFormField(
//             controller: _emailController,
//             decoration: const InputDecoration(labelText: 'Email'),
//             readOnly: true,
//           ),
//           const SizedBox(height: 16),//

//           // Weight fields
//           TextFormField(
//             controller: _weightController,
//             decoration:
//                 const InputDecoration(labelText: 'Current Weight (lbs)'),
//             keyboardType: TextInputType.number,
//             validator: (v) =>
//                 (v?.isEmpty ?? true) ? 'Enter your weight' : null,
//           ),
//           const SizedBox(height: 16),
//           TextFormField(
//             controller: _goalController,
//             decoration: const InputDecoration(labelText: 'Weight Goal (lbs)'),
//             keyboardType: TextInputType.number,
//             validator: (v) =>
//                 (v?.isEmpty ?? true) ? 'Enter goal weight' : null,
//           ),//

//           // Gender picker
//           const SizedBox(height: 16),
//           const Text('Gender'),
//           Row(
//             children: [
//               Expanded(
//                 child: RadioListTile<String>(
//                   title: const Text('Male'),
//                   value: 'Male',
//                   groupValue: _gender,
//                   onChanged: (val) => setState(() => _gender = val!),
//                 ),
//               ),
//               Expanded(
//                 child: RadioListTile<String>(
//                   title: const Text('Female'),
//                   value: 'Female',
//                   groupValue: _gender,
//                   onChanged: (val) => setState(() => _gender = val!),
//                 ),
//               ),
//             ],
//           ),//

//           // Disability notes
//           const SizedBox(height: 16),
//           TextFormField(
//             controller: _disabilityController,
//             decoration:
//                 const InputDecoration(labelText: 'Disability Info (if any)'),
//             maxLines: 3,
//           ),//

//           // Save button
//           const SizedBox(height: 24),
//           ElevatedButton(
//             onPressed: _saveProfile,
//             child: const Text('Save changes'),
//           ),
//         ],
//       ),
//     ),
//   );
// 























/*

// OPTION 1: Good layout but font style needs adjusting. 
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

//DISPLAY PAGE--
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey               = GlobalKey<FormState>();
  final _nameController        = TextEditingController();
  final _emailController       = TextEditingController();
  final _weightController      = TextEditingController();
  final _goalController        = TextEditingController();
  final _disabilityController  = TextEditingController();
  String _gender               = 'Male';

  bool _loading = true;
  bool _saving  = false;
  bool _profileComplete = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    _profileComplete = prefs.getBool('profileComplete') ?? false;
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _nameController.text  = user.displayName ?? '';
      _emailController.text = user.email ?? '';
      if (_profileComplete) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (doc.exists) {
          final data = doc.data()!;
          _weightController.text     = data['currentWeight']?.toString() ?? '';
          _goalController.text       = data['weightGoal']?.toString()   ?? '';
          _gender                    = data['gender']                   ?? _gender;
          _disabilityController.text = data['disability']              ?? '';
        }
      }
    }
    setState(() => _loading = false);
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    setState(() => _saving = true);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .set({
          'currentWeight': double.parse(_weightController.text),
          'weightGoal':    double.parse(_goalController.text),
          'gender':        _gender,
          'disability':    _disabilityController.text,
        }, SetOptions(merge: true));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('profileComplete', true);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Profile saved!')));
    setState(() {
      _profileComplete = true;
      _saving = false;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _weightController.dispose();
    _goalController.dispose();
    _disabilityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(_profileComplete ? 'My Profile' : 'My Profile'),
      ),
      body: _profileComplete ? _buildSummary() : _buildForm(),
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              readOnly: true,
            ),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              readOnly: true,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _weightController,
              decoration: const InputDecoration(labelText: 'Current Weight (lbs)'),
              keyboardType: TextInputType.number,
              validator: (v) => (v?.isEmpty ?? true) ? 'Enter your weight' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _goalController,
              decoration: const InputDecoration(labelText: 'Weight Goal (lbs)'),
              keyboardType: TextInputType.number,
              validator: (v) => (v?.isEmpty ?? true) ? 'Enter goal weight' : null,
            ),
            const SizedBox(height: 16),
            const Text('Gender'),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Male'),
                    value: 'Male', groupValue: _gender,
                    onChanged: (val) => setState(() => _gender = val!),
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Female'),
                    value: 'Female', groupValue: _gender,
                    onChanged: (val) => setState(() => _gender = val!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _disabilityController,
              decoration: const InputDecoration(labelText: 'Disability Info (if any)'),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saving ? null : _saveProfile,
              child: const Text('Done'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Name: ${_nameController.text}'),
          Text('Email: ${_emailController.text}'),
          const SizedBox(height: 8),
          if (_weightController.text.isNotEmpty)
            Text('Current Weight: ${_weightController.text} lbs'),
          if (_goalController.text.isNotEmpty)
            Text('Weight Goal: ${_goalController.text} lbs'),
          Text('Gender: $_gender'),
          if (_disabilityController.text.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text('Disability: ${_disabilityController.text}'),
          ],
          const Spacer(),
          Center(
            child: ElevatedButton(
              onPressed: () => setState(() => _profileComplete = false),
              child: const Text('Edit Profile'),
            ),
          ),
        ],
      ),
    );
  }
}

*/













/*  //OPTION 2: Need to review further
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
//import 'package:fitnessapp/theme/theme_provider.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//
//class SettingsPage extends StatefulWidget {
//  const SettingsPage({super.key});
//  @override
//  _SettingsPageState createState() => _SettingsPageState();
//}
//
//class _SettingsPageState extends State<SettingsPage> {
//  String? _name;
//  @override
//  void initState() {
//    super.initState();
//    _loadName();
//  }
//  Future<void> _loadName() async {
//    final prefs = await SharedPreferences.getInstance();
//    setState(() {
//      _name = prefs.getString('displayName') ?? 'User';
//    });
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        //title: const Text('Settings'),
//        title: Text('Settings - ${_name ?? ""}'),
//        backgroundColor: Color(0xFFA71414),
//      ),
//      body: ListView(
//        padding: const EdgeInsets.all(24),
//        children: [
//          // add at the top of your ListView children:
//const Text('Profile', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//const SizedBox(height: 16),
//TextFormField(
//  initialValue: _name,
//  decoration: const InputDecoration(labelText: 'Display Name'),
//  onChanged: (v) => _name = v,
//),
//const SizedBox(height: 8),
//ElevatedButton(
//  onPressed: () async {
//    final prefs = await SharedPreferences.getInstance();
//    await FirebaseFirestore.instance
//  .collection('users')
//  .doc(FirebaseAuth.instance.currentUser!.uid)
//  .set({'displayName': _name}, SetOptions(merge: true));
//
//    await prefs.setString('displayName', _name ?? 'User');
//    ScaffoldMessenger.of(context).showSnackBar(
//      const SnackBar(content: Text('Name updated!')),
//    );
//    setState(() {}); // refresh title
//  },
//  child: const Text('Save Name'),
//),
//const Divider(height: 48),
//
//          const Text(
//            'Appearance',
//            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//          ),
//          const SizedBox(height: 16),
//          SwitchListTile(
//            secondary: const Icon(Icons.dark_mode),
//            title: const Text('Dark Mode'),
//            value: Provider.of<ThemeProvider>(context).isDarkMode,
//            onChanged: (value) =>
//                Provider.of<ThemeProvider>(context, listen: false)
//                    .toggleTheme(),
//          ),
//          const Divider(height: 48),
//          const Text(
//            'App Info',
//            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//          ),
//          const SizedBox(height: 16),
//          ListTile(
//            leading: const Icon(Icons.info),
//            title: const Text('Version'),
//            subtitle: const Text('1.0.0'),
//          ),
//          ListTile(
//            leading: const Icon(Icons.description),
//            title: const Text('Terms of Service'),
//            onTap: () {
//              ScaffoldMessenger.of(context).showSnackBar(
//                const SnackBar(content: Text('Terms of Service coming soon!')),
//              );
//            },
//          ),
//          ListTile(
//            leading: const Icon(Icons.privacy_tip),
//            title: const Text('Privacy Policy'),
//            onTap: () {
//              ScaffoldMessenger.of(context).showSnackBar(
//                const SnackBar(content: Text('Privacy Policy coming soon!')),
//              );
//            },
//          ),
//        ],
//      ),
//    );
//  }
//}
//
//
//

*/













/*

// OPTION 3: MY FAVORITE because it shows the view of Profile page. 
// allows for edits BUT 'save info' spins forever and does not return to view mode. 
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

// --- DISPLAY PAGE ---
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _loading = true;
  String _name = '';
  String _email = '';
  String _weight = '';
  String _goal = '';
  String _gender = '';
  String _disability = '';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _loading = true);
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _name    = user.displayName ?? '';
      _email   = user.email ?? '';
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (doc.exists) {
        final data = doc.data()!;
        _weight     = data['currentWeight']?.toString() ?? '';
        _goal       = data['weightGoal']?.toString()   ?? '';
        _gender     = data['gender']                   ?? '';
        _disability = data['disability']              ?? '';
      }
    }
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: $_name'),
            Text('Email: $_email'),
            const SizedBox(height: 8),
            if (_weight.isNotEmpty) Text('Current Weight: $_weight lbs'),
            if (_goal.isNotEmpty)   Text('Weight Goal: $_goal lbs'),
            if (_gender.isNotEmpty) Text('Gender: $_gender'),
            if (_disability.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('Disability: $_disability'),
            ],
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EditProfilePage()),
                  );
                  await _loadProfile(); // refresh display
                },
                child: const Text('Edit Info'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- EDIT PAGE ---
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey               = GlobalKey<FormState>();
  final _weightController      = TextEditingController();
  final _goalController        = TextEditingController();
  final _disabilityController  = TextEditingController();
  String _gender               = 'Male';

  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadExisting();
  }

  Future<void> _loadExisting() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (doc.exists) {
        final data = doc.data()!;
        _weightController.text     = data['currentWeight']?.toString() ?? '';
        _goalController.text       = data['weightGoal']?.toString()   ?? '';
        _gender                    = data['gender']                   ?? _gender;
        _disabilityController.text = data['disability']              ?? '';
      }
    }
    setState(() {});
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => _saving = true);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .set({
          'currentWeight': double.parse(_weightController.text),
          'weightGoal':    double.parse(_goalController.text),
          'gender':        _gender,
          'disability':    _disabilityController.text,
        }, SetOptions(merge: true));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('profileComplete', true);

    if (mounted) Navigator.pop(context);
  }

  @override
  void dispose() {
    _weightController.dispose();
    _goalController.dispose();
    _disabilityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(labelText: 'Current Weight (lbs)'),
                keyboardType: TextInputType.number,
                validator: (v) => (v?.isEmpty ?? true) ? 'Enter your weight' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _goalController,
                decoration: const InputDecoration(labelText: 'Weight Goal (lbs)'),
                keyboardType: TextInputType.number,
                validator: (v) => (v?.isEmpty ?? true) ? 'Enter goal weight' : null,
              ),
              const SizedBox(height: 16),
              const Text('Gender'),
              Row(children: [
                Expanded(child: RadioListTile(
                  title: const Text('Male'), value: 'Male',
                  groupValue: _gender,
                  onChanged: (v) => setState(() => _gender = v!),
                )),
                Expanded(child: RadioListTile(
                  title: const Text('Female'), value: 'Female',
                  groupValue: _gender,
                  onChanged: (v) => setState(() => _gender = v!),
                )),
              ]),
              const SizedBox(height: 16),
              TextFormField(
                controller: _disabilityController,
                decoration: const InputDecoration(labelText: 'Disability Info (if any)'),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saving ? null : _saveProfile,
                child: _saving
                    ? const SizedBox(
                        width: 20, height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Save changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

*/











/*

// BEST OPTION!!!!!!! JUST TRYING TO ADD A BETTER FONT STYLE AND PAGE PAYOUT!!!

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

// --- DISPLAY PAGE ---
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _loading = true;
  String _name = '';
  String _email = '';
  String _weight = '';
  String _goal = '';
  String _gender = '';
  String _disability = '';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _loading = true);
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _name  = user.displayName ?? '';
      _email = user.email ?? '';
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (doc.exists) {
        final data = doc.data()!;
        _weight     = data['currentWeight']?.toString() ?? '';
        _goal       = data['weightGoal']?.toString()   ?? '';
        _gender     = data['gender']                   ?? '';
        _disability = data['disability']              ?? '';
      }
    }
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFA71414),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: $_name'),
            Text('Email: $_email'),
            const SizedBox(height: 15),
            if (_weight.isNotEmpty) Text('Current Weight: $_weight lbs'),
            if (_goal.isNotEmpty)   Text('Weight Goal: $_goal lbs'),
            if (_gender.isNotEmpty) Text('Gender: $_gender'),
            if (_disability.isNotEmpty) ...[
              const SizedBox(height: 15),
              Text('Disability: $_disability'),
            ],
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EditProfilePage()),
                  );
                  await _loadProfile();
                },
                child: const Text('Edit Info'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- EDIT PAGE ---
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey              = GlobalKey<FormState>();
  final _weightController     = TextEditingController();
  final _goalController       = TextEditingController();
  final _disabilityController = TextEditingController();
  String _gender              = 'Male';

  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadExisting();
  }

  Future<void> _loadExisting() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (doc.exists) {
        final data = doc.data()!;
        _weightController.text     = data['currentWeight']?.toString() ?? '';
        _goalController.text       = data['weightGoal']?.toString()   ?? '';
        _gender                    = data['gender']                   ?? 'Male';
        _disabilityController.text = data['disability']              ?? '';
      }
    }
    setState(() {});
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => _saving = true);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .set({
          'currentWeight': double.parse(_weightController.text),
          'weightGoal':    double.parse(_goalController.text),
          'gender':        _gender,
          'disability':    _disabilityController.text,
        }, SetOptions(merge: true));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('profileComplete', true);

    if (mounted) Navigator.pop(context);
  }

  @override
  void dispose() {
    _weightController.dispose();
    _goalController.dispose();
    _disabilityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.normal,
          ),
        ),
        backgroundColor: const Color(0xFFA71414),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(labelText: 'Current Weight (lbs)'),
                keyboardType: TextInputType.number,
                validator: (v) => (v?.isEmpty ?? true) ? 'Enter your weight' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _goalController,
                decoration: const InputDecoration(labelText: 'Weight Goal (lbs)'),
                keyboardType: TextInputType.number,
                validator: (v) => (v?.isEmpty ?? true) ? 'Enter goal weight' : null,
              ),
              const SizedBox(height: 16),
              const Text('Gender'),
              Row(
                children: [
                  Expanded(child: RadioListTile<String>(
                    title: const Text('Male'),
                    value: 'Male',
                    groupValue: _gender,
                    onChanged: (val) => setState(() => _gender = val!),
                  )),
                  Expanded(child: RadioListTile<String>(
                    title: const Text('Female'),
                    value: 'Female',
                    groupValue: _gender,
                    onChanged: (val) => setState(() => _gender = val!),
                  )),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _disabilityController,
                decoration: const InputDecoration(labelText: 'Disability Info (if any)'),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saving ? null : _saveProfile,
                child: _saving
                    ? const SizedBox(
                        width: 20, height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Save changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

*/



import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

// --- DISPLAY PAGE ---
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _loading = true;
  String _name = '';
  String _email = '';
  String _weight = '';
  String _goal = '';
  String _gender = '';
  String _disability = '';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _loading = true);
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _name = user.displayName ?? '';
      _email = user.email ?? '';
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (doc.exists) {
        final data = doc.data()!;
        _weight = data['currentWeight']?.toString() ?? '';
        _goal = data['weightGoal']?.toString() ?? '';
        _gender = data['gender'] ?? '';
        _disability = data['disability'] ?? '';
      }
    }
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final headerStyle = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    );
    final cellStyle = TextStyle(
      fontSize: 16,
      color: Colors.black54,
    );

    return Scaffold(
      backgroundColor: const Color.fromARGB(179, 45, 4, 60), // purple background
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFA71414),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Table(
              border: TableBorder.all(color: Colors.grey.shade300),
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(3),
              },
              children: [
                _buildRow('Name', _name, headerStyle, cellStyle),
                _buildRow('Email', _email, headerStyle, cellStyle),
                _buildRow('Current Weight', '$_weight lbs', headerStyle, cellStyle),
                _buildRow('Weight Goal', '$_goal lbs', headerStyle, cellStyle),
                _buildRow('Gender', _gender, headerStyle, cellStyle),
                _buildRow('Disability', _disability.isNotEmpty ? _disability : 'None', headerStyle, cellStyle),
              ],
            ),
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFA71414),
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                ),
                onPressed: () => _showEditForm(context),
                child: const Text(
                  'Edit Profile',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildRow(String label, String value, TextStyle header, TextStyle cell) {
    return TableRow(
      decoration: BoxDecoration(color: Colors.grey.shade50),
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(label, style: header),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(value, style: cell),
        ),
      ],
    );
  }

  void _showEditForm(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EditProfilePage()),
    ).then((_) => _loadProfile());
  }
}

// --- EDIT PAGE ---
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  final _goalController = TextEditingController();
  final _disabilityController = TextEditingController();
  String _gender = 'Male';
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadExisting();
  }

  Future<void> _loadExisting() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (doc.exists) {
        final data = doc.data()!;
        _weightController.text = data['currentWeight']?.toString() ?? '';
        _goalController.text = data['weightGoal']?.toString() ?? '';
        _gender = data['gender'] ?? 'Male';
        _disabilityController.text = data['disability'] ?? '';
      }
    }
    setState(() {});
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    setState(() => _saving = true);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .set({
          'currentWeight': double.parse(_weightController.text),
          'weightGoal': double.parse(_goalController.text),
          'gender': _gender,
          'disability': _disabilityController.text,
        }, SetOptions(merge: true));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('profileComplete', true);
    if (mounted) Navigator.pop(context);
  }

  @override
  void dispose() {
    _weightController.dispose();
    _goalController.dispose();
    _disabilityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFA71414),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(labelText: 'Current Weight (lbs)'),
                keyboardType: TextInputType.number,
                validator: (v) => (v?.isEmpty ?? true) ? 'Enter your weight' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _goalController,
                decoration: const InputDecoration(labelText: 'Weight Goal (lbs)'),
                keyboardType: TextInputType.number,
                validator: (v) => (v?.isEmpty ?? true) ? 'Enter goal weight' : null,
              ),
              const SizedBox(height: 16),
              const Text('Gender'),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Male'),
                      value: 'Male',
                      groupValue: _gender,
                      onChanged: (val) => setState(() => _gender = val!),
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Female'),
                      value: 'Female',
                      groupValue: _gender,
                      onChanged: (val) => setState(() => _gender = val!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _disabilityController,
                decoration: const InputDecoration(labelText: 'Disability Info (if any)'),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saving ? null : _saveProfile,
                child: _saving
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Save changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
