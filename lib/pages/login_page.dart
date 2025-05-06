//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter/material.dart';
//import 'package:fitnessapp/pages/navigator_page.dart';
//
//class LoginPage extends StatefulWidget {
//  const LoginPage({super.key});
//
//  @override
//  _LoginPageState createState() => _LoginPageState();
//}
//
//class _LoginPageState extends State<LoginPage> {
//  final _formKey = GlobalKey<FormState>();
//  String _email = '';
//  String _password = '';
//
//  void _submitForm() {
//    if (_formKey.currentState!.validate()) {
//      _formKey.currentState!.save();
//      // TODO: Implement authentication logic here
//      print('Email: $_email, Password: $_password');
//    }
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      backgroundColor: Colors.grey[100],
//      body: Center(
//        child: Padding(
//          padding: const EdgeInsets.all(24.0),
//          child: Form(
//            key: _formKey,
//            child: Column(
//              mainAxisSize: MainAxisSize.min,
//              children: [
//                Text("Login", style: Theme.of(context).textTheme.headlineMedium),
//                const SizedBox(height: 24),
//                TextFormField(
//                  decoration: const InputDecoration(labelText: 'Email'),
//                  keyboardType: TextInputType.emailAddress,
//                  validator: (value) =>
//                      value!.isEmpty ? 'Please enter your email' : null,
//                  onSaved: (value) => _email = value!,
//                ),
//                const SizedBox(height: 16),
//                TextFormField(
//                  decoration: const InputDecoration(labelText: 'Password'),
//                  obscureText: true,
//                  validator: (value) =>
//                      value!.isEmpty ? 'Please enter your password' : null,
//                  onSaved: (value) => _password = value!,
//                ),
//                const SizedBox(height: 32),
//                ElevatedButton(
//                  onPressed: _submitForm,
//                  child: const Text('Login'),
//                ),
//              ],
//            ),
//          ),
//        ),
//      ),
//    );
//  }
//}




import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fitnessapp/pages/navigator_page.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitnessapp/pages/signup_page.dart';
import 'package:fitnessapp/pages/reset_password_page.dart';


class LoginPage extends StatefulWidget {
  final FirebaseAuth auth;

  LoginPage({super.key, FirebaseAuth? auth})
      : auth = auth ?? FirebaseAuth.instance;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _error = '';
  bool _isLoading = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      await widget.auth.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );

      // Save login state
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      final displayName = prefs.getString('displayName') ?? 'User'; // fetch saved name

      if (!mounted) return; 
        // Navigate to the main page on successful login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => NavigatorPage(name: displayName)),
        );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _error = e.message ?? 'Login failed';
      });
    } catch (e) {
      setState(() {
        _error = 'Unexpected error occurred';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Login", style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 24),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => value!.isEmpty ? 'Enter your email' : null,
                    onSaved: (value) => _email = value!.trim(),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (value) => value!.isEmpty ? 'Enter your password' : null,
                    onSaved: (value) => _password = value!.trim(),
                  ),
                  const SizedBox(height: 32),
                  if (_error.isNotEmpty)
                    Text(_error, style: const TextStyle(color: Colors.red)),
                  if (_isLoading)
                    const CircularProgressIndicator()
                  else
                    ElevatedButton(
                      onPressed: _login,
                      child: const Text('Login'),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, 
                          MaterialPageRoute(builder: (_) => const SignUpPage())
                          );
                    },
                    child: const Text("Don't have an account? Sign up"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const ResetPasswordPage())
                        );
                      },
                      child: const Text("Forgot password?"),
                    ),
                ],              
              ),
            ),
          ),
        ),
      ),
    );
  }
}
