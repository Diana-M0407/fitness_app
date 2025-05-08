

/*
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

*/





// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(
//       title: const Text('Home'),
//       backgroundColor: const Color(0xFFA71414),
//     ),
//     body: const SizedBox.expand(), // blank page
//   );
// }
//


//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: const Text(
//          'Home',
//          style: TextStyle(
//            color: Colors.black,
//            fontSize: 20,
//            fontWeight: FontWeight.bold,
//          ),
//        ),
//        backgroundColor: const Color(0xFFA71414),
//        centerTitle: true,
//      ),
//      body: Column(
//        children: [
//          // Make sure the file exists at assets/images/csuf_rec.png and is registered in pubspec.yaml
//          Image.asset('assets/images/csuf_rec.jpg', scale: 1),
//          SizedBox(height: 16),
//          const Divider(color: Colors.black),
//          Container(
//            color: const Color.fromARGB(255, 229, 96, 55),
//            width: double.infinity,
//            padding: const EdgeInsets.all(16),
//            child: const Center(
//              child: Text(
//                'Ready to start your streak?',
//                style: TextStyle(
//                  color: Color.fromARGB(255, 53, 30, 71),
//                ),
//              ),
//            ),
//          ),
//        ],
//      ),
//    );
//  }
//}//


/*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFA71414),
        centerTitle: true,
      ),
     body: Column(
  children: [
    // this makes the image grow to fill all remaining vertical space:
    Expanded(
      child: Image.asset(
        'assets/images/csuf_rec.jpg',
        width: double.infinity,      // stretch to full width
        fit: BoxFit.cover,           // scale & crop to fill
      ),
    ),

    const SizedBox(height: 10),
    const Divider(color: Colors.black),
    // …other widgets…
  ],
),

    );
  }
}

*/



/*

//BEST OPTION!!!!
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFA71414),
        centerTitle: true,
      ),
      // Full-screen background image with overlaid buttons
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/csuf_rec.jpg',
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
                    // TODO: handle button 1
                  },
                  child: const Text('Today\'s Workout'),
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
                    // TODO: handle button 2
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


*/










import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitnessapp/pages/workout_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
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
            'assets/images/palms.webp',
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
                  child: const Text('Today\'s Workout'),
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






















