// import 'package:fitnessapp/models/profile.dart';
// import 'package:flutter/material.dart';
// //import 'package:flutter_svg/flutter_svg.dart';
//
// class ProfilePage extends StatelessWidget {
//   const ProfilePage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final Profile demoProfile = Profile(
//       name: "Diana",
//       age: 99,
//       email: "test@example.com",
//     );
//
//     return Scaffold(
//
//   body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Name: ${demoProfile.name}'),
//             Text('Age: ${demoProfile.age}'),
//             Text('Email: ${demoProfile.email}'),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _weightController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _ageController = TextEditingController();
    _weightController = TextEditingController();
    _emailController = TextEditingController();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final user = FirebaseAuth.instance.currentUser;

    setState(() {
      _nameController.text = prefs.getString('displayName') ?? '';
      _ageController.text = (prefs.getInt('age') ?? '').toString();
      _weightController.text = (prefs.getDouble('weight') ?? '').toString();
      _emailController.text = user?.email ?? '';
    });
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('displayName', _nameController.text.trim());
    await prefs.setInt('age', int.parse(_ageController.text.trim()));
    await prefs.setDouble(
        'weight', double.parse(_weightController.text.trim()));

    final user = FirebaseAuth.instance.currentUser;
    if (user != null ){
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'displayName': _nameController.text.trim(),
      'age': int.parse(_ageController.text.trim()),
      'weight': double.parse(_weightController.text.trim()),
      'email': _emailController.text.trim(),
    });
    
    if (_emailController.text.trim() != user.email) {
      await user.updateEmail(_emailController.text.trim());
    }
  }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) => value!.isEmpty ? 'Enter your name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    (int.tryParse(value!) == null) ? 'Enter a valid age' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(labelText: 'Weight (lbs)'),
                keyboardType: TextInputType.number,
                validator: (value) => (double.tryParse(value!) == null)
                    ? 'Enter a valid weight'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                    value!.isEmpty ? 'Enter your email' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: _saveProfile,
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

