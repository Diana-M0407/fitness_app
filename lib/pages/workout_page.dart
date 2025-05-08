import 'package:flutter/material.dart';

class WorkoutPage extends StatelessWidget {
  const WorkoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Workout',
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
        child: Column(
          children: [
            const SizedBox(height: 20),
            _imageWithButton(
              context,
              'assets/images/csuf_weights.jpg',
              'Upper Body',
              () {
                // Navigate to workout details
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const WorkoutPage()),
                );
              },
            ),
            const SizedBox(height: 20),
            _imageWithButton(
              context,
              'assets/images/dumbells.jpg',
              'Lower Body',
              () {
                // Show custom workout dialog or page
                // TODO: implement custom workout flow
              },
            ),
            const SizedBox(height: 20),
            _imageWithButton(
              context,
              'assets/images/gym_layout.jpg',
              'Core Strenght',
              () {
                // Navigate to workout log
                // TODO: implement log page
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _imageWithButton(
      BuildContext context, String imagePath, String label, VoidCallback onPressed) {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            imagePath,
            fit: BoxFit.cover,
          ),
          Center(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: onPressed,
              child: Text(label),
            ),
          ),
        ],
      ),
    );
  }
}
