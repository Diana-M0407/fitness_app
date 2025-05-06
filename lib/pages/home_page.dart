//import 'package:flutter/material.dart';
  //import 'package:fitnessapp/widgets/app_icon.dart';
//
//class HomePage extends StatelessWidget {
//  const HomePage({super.key});

//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text(
//          ' ', //'Home'
//          style: TextStyle(
//            color: Colors.black,
//            fontSize: 18,
//            fontWeight: FontWeight.bold
//          ),
//        ),
//        backgroundColor: Colors.grey[700],
//        centerTitle: true,
//      ),
//    );
//  }
//}


//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//    //  appBar: AppBar(
    //    backgroundColor: Colors.grey[700],
    //    centerTitle: true,
    //    leading: IconButton(
    //      icon: const AppIcon(
    //        materialIcon: Icons.menu,
    //        svgPath: 'assets/icons/menu.svg',
    //        useCustom: false, // set to true later to use your custom svg
    //        color: Colors.white,
    //      ),
    //      onPressed: () {
    //        // example: open a drawer or show a message
    //        ScaffoldMessenger.of(context).showSnackBar(
    //          const SnackBar(content: Text("Menu clicked")),
    //        );
    //      },
    //    ),
    //    title: const Text(
    //      'Home',
    //      style: TextStyle(
    //        color: Colors.black,
    //        fontSize: 18,
    //        fontWeight: FontWeight.bold,
    //      ),
    //    ),
    //    actions: [
    //      IconButton(
    //        icon: const AppIcon(
    //          materialIcon: Icons.settings,
    //          svgPath: 'assets/icons/settings.svg',
    //          useCustom: false,
    //          color: Colors.white,
    //        ),
    //        onPressed: () {
    //          // navigate to settings or perform action
    //        },
    //      ),
    //    ],
    //  ),
//    body: Center(
//      child: Text('Home Page Content'),
//    ),
//    );
//  }
//}


import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _goalController = TextEditingController();
  String _gender = 'Male';
  final TextEditingController _disabilityController = TextEditingController();

  @override
  void dispose() {
    _weightController.dispose();
    _goalController.dispose();
    _disabilityController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set({
          'currentWeight': double.parse(_weightController.text),
          'weightGoal': double.parse(_goalController.text),
          'gender': _gender,
          'disability': _disabilityController.text,
        }, SetOptions(merge: true));

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile saved!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Your Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(
                  labelText: 'Current Weight (kg)',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your current weight';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _goalController,
                decoration: const InputDecoration(
                  labelText: 'Weight Goal (kg)',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your weight goal';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Gender',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
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
                decoration: const InputDecoration(
                  labelText: 'Disability Info (if any)',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveProfile,
                child: const Text('Save Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
