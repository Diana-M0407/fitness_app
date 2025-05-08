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
