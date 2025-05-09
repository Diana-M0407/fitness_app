import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitnessapp/pages/navigator_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '', _email = '', _password = '', _error = '';
  int _age = 0;
  double _weight = 0.0;
  //double _currentWeight = 0.0;
  bool _loading = false;

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => _loading = true);

    try {
      // Create account and capture the credential
      final credential = 
        await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: _email, password: _password);

      // Update the Firebase User's displayName
      await credential.user!.updateDisplayName(_name);

      // Persist everything locally
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('displayName', _name);
      await prefs.setInt('age', _age);
      await prefs.setDouble('weight', _weight);
      //await prefs.setString('email', _email);
      //await prefs.setDouble('Current weight', _weight);

      final uid = credential.user!.uid;
      await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set({
          'currentWeight': _weight,
          'weightGoal': 0.0,
          'gender': 'Male',
          'disability': '',
        }, SetOptions(merge: true));

 /*     if (context.mounted) {
      /*  Navigator.pushReplacementNamed(
          context,
          '/navigator',
          arguments: _name,
        );      */
        Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => NavigatorPage(name: _name),
        ),
      );
    }   */
  } 



      /*
      on FirebaseAuthException catch (e) {
      setState(() => _error = e.message ?? 'Sign-up failed');
      } finally {
      if (mounted) {
        setState(() => _loading = false);
        }
      }
      */

on FirebaseAuthException catch (e) {
    setState(() {
      _error = e.message ?? 'Sign-up failed';
    });
    return;              // skip navigation if auth error
  } catch (e) {
    setState(() {
      _error = 'Unexpected error: $e';
    });
    return;
  } finally {
    if (mounted) setState(() => _loading = false);
    }

  // only get here if everything succeeded
  if (!mounted) return;
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (_) => NavigatorPage(name: _name)),
  );






}

  





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) =>
                      value!.isEmpty ? 'Enter your name' : null,
                  onSaved: (value) => _name = value!.trim(),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Age'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    final age = int.tryParse(value ?? '');
                    return (age == null || age <= 0)
                        ? 'Enter a valid age'
                        : null;
                  },
                  onSaved: (value) => _age = int.parse(value!),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Weight (lbs)'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    final weight = double.tryParse(value ?? '');
                    return (weight == null || weight <= 0)
                        ? 'Enter a valid weight'
                        : null;
                  },
                  onSaved: (value) => _weight = double.parse(value!),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) =>
                      value!.isEmpty ? 'Enter an email' : null,
                  onSaved: (value) => _email = value!.trim(),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) => value!.length < 6
                      ? 'Password must be at least 6 characters'
                      : null,
                  onSaved: (value) => _password = value!.trim(),
                ),
                const SizedBox(height: 24),

                if (_error.isNotEmpty) ...[
                  Text(_error, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 12),
                ],

                if (_loading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: _signUp,
                    child: const Text('Create Account'),
                  ),

                const SizedBox(height: 12),

                // Cancel as a read-only TextFormField
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NavigatorPageWithGreeting extends StatelessWidget {
  final String name;
  const NavigatorPageWithGreeting({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Welcome, $name! Ready to work out?')),
      );
    });
    return const NavigatorPage();
  }
}
