import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //–– Controllers & state ––
  final _formKey               = GlobalKey<FormState>();
  final _nameController        = TextEditingController();
  final _emailController       = TextEditingController();
  final _weightController      = TextEditingController();
  final _goalController        = TextEditingController();
  final _disabilityController  = TextEditingController();
  String _gender               = 'Male';

  bool _isEditing = false;  // ← toggle between summary & form

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Load name/email from Auth
    _nameController.text  = user.displayName ?? '';
    _emailController.text = user.email ?? '';

    // Load the rest from Firestore, if it exists
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

    setState(() {});
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .set({
        'currentWeight': double.parse(_weightController.text),
        'weightGoal':    double.parse(_goalController.text),
        'gender':        _gender,
        'disability':    _disabilityController.text,
      }, SetOptions(merge: true)); // ← preserves email/password

    ScaffoldMessenger.of(context)
      .showSnackBar(const SnackBar(content: Text('Info added!')));

    // Switch back to summary view
    setState(() => _isEditing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Update Profile' : 'My Profile'),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => _isEditing = true),
            )
        ],
      ),
      body: _isEditing ? _buildForm() : _buildSummary(),
    );
  }

  Widget _buildSummary() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          Text('Name: ${_nameController.text}'),
          Text('Email: ${_emailController.text}'),
          const SizedBox(height: 8),
          if (_weightController.text.isNotEmpty)
            Text('Current Weight: ${_weightController.text} kg'),
          if (_goalController.text.isNotEmpty)
            Text('Weight Goal: ${_goalController.text} kg'),
          Text('Gender: $_gender'),
          if (_disabilityController.text.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text('Disability Notes:\n${_disabilityController.text}'),
          ],
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            // Name & Email (read-only)
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

            // Weight fields
            TextFormField(
              controller: _weightController,
              decoration: const InputDecoration(labelText: 'Current Weight (kg)'),
              keyboardType: TextInputType.number,
              validator: (v) => (v?.isEmpty ?? true) ? 'Enter your weight' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _goalController,
              decoration: const InputDecoration(labelText: 'Weight Goal (kg)'),
              keyboardType: TextInputType.number,
              validator: (v) => (v?.isEmpty ?? true) ? 'Enter goal weight' : null,
            ),

            // Gender picker
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

            // Disability notes
            const SizedBox(height: 16),
            TextFormField(
              controller: _disabilityController,
              decoration: const InputDecoration(labelText: 'Disability Info (if any)'),
              maxLines: 3,
            ),

            // Save button
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveProfile,
              child: const Text('Save Info'),
            ),
          ],
        ),
      ),
    );
  }
}
