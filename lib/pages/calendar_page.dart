import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitnessapp/pages/workout_page.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Calendar',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFA71414),
        centerTitle: true,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/calendar.webp',
            fit: BoxFit.cover,
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const WorkoutPage()),
                    );
                  },
                  child: const Text('Record Your Workout'),
                ),
                const SizedBox(height: 16),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => const CustomWorkoutDialog(),
                    );
                  },
                  child: const Text('Custom Workout'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomWorkoutDialog extends StatefulWidget {
  const CustomWorkoutDialog({super.key});

  @override
  _CustomWorkoutDialogState createState() => _CustomWorkoutDialogState();
}

class _CustomWorkoutDialogState extends State<CustomWorkoutDialog> {
  final _formKey = GlobalKey<FormState>();
  String _bodyPart = '';
  int? _reps;
  double? _weight;
  int? _sets;
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Custom Workout'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Body Part'),
                validator: (v) => v == null || v.isEmpty
                    ? 'Enter a body part'
                    : null,
                onSaved: (v) => _bodyPart = v ?? '',
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Reps'),
                keyboardType: TextInputType.number,
                validator: (v) => int.tryParse(v ?? '') == null
                    ? 'Enter valid reps'
                    : null,
                onSaved: (v) => _reps = int.parse(v!),
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Weight (lbs)'),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (v) => double.tryParse(v ?? '') == null
                    ? 'Enter valid weight'
                    : null,
                onSaved: (v) => _weight = double.parse(v!),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Sets'),
                keyboardType: TextInputType.number,
                validator: (v) => int.tryParse(v ?? '') == null
                    ? 'Enter valid sets'
                    : null,
                onSaved: (v) => _sets = int.parse(v!),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saving
              ? null
              : () async {
                  if (!_formKey.currentState!.validate()) return;
                  _formKey.currentState!.save();
                  setState(() => _saving = true);
                  final user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .collection('workouts')
                        .add({
                      'bodyPart': _bodyPart,
                      'reps': _reps,
                      'weight': _weight,
                      'sets': _sets,
                      'timestamp': FieldValue.serverTimestamp(),
                    });
                  }
                  setState(() => _saving = false);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Workout added to log')),
                  );
                },
          child: _saving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('Add'),
        ),
      ],
    );
  }
}






















