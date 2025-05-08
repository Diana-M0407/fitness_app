import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fitnessapp/pages/navigator_page.dart';
import 'package:fitnessapp/pages/signup_page.dart';
import 'package:fitnessapp/pages/reset_password_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  final FirebaseAuth auth;
  LoginPage({super.key, FirebaseAuth? auth})
      : auth = auth ?? FirebaseAuth.instance;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // helper for the 2/3-height bottom sheet:
  void _showLoginSheet() {
    final sheetKey = GlobalKey<FormState>();
    String email = '', password = '';
    String error = '';
    bool isLoading = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // so we can round corners
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.66,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollCtrl) {
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Color(0xFFA71414), // your red
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: SingleChildScrollView(
              controller: scrollCtrl,
              child: Form(
                key: sheetKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Login',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          !.copyWith(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Colors.white70),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white54),
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) =>
                          v!.isEmpty ? 'Enter your email' : null,
                      onSaved: (v) => email = v!.trim(),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.white70),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white54),
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                      obscureText: true,
                      validator: (v) =>
                          v!.isEmpty ? 'Enter your password' : null,
                      onSaved: (v) => password = v!.trim(),
                    ),
                    if (error.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(error,
                          style: const TextStyle(color: Colors.yellowAccent)),
                    ],
                    const SizedBox(height: 24),

                    // — Elevated buttons in a COLUMN —
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color.fromARGB(255, 89, 44, 157),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: isLoading
                          ? null
                          : () async {
                              if (!sheetKey.currentState!.validate()) return;
                              sheetKey.currentState!.save();
                              setState(() => isLoading = true);
                              try {
                                await widget.auth.signInWithEmailAndPassword(
                                  email: email,
                                  password: password,
                                );
                                final prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.setBool('isLoggedIn', true);
                                final displayName = prefs
                                        .getString('displayName') ??
                                    'User';
                                if (!mounted) return;
                                Navigator.pop(context); // close sheet
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        NavigatorPage(name: displayName),
                                  ),
                                );
                              } on FirebaseAuthException catch (e) {
                                setState(() =>
                                    error = e.message ?? 'Login failed');
                              } catch (_) {
                                setState(
                                    () => error = 'Unexpected error occurred');
                              } finally {
                                setState(() => isLoading = false);
                              }
                            },
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xFFA71414),
                              ),
                            )
                          : const Text('Login'),
                    ),

                    const SizedBox(height: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color.fromARGB(255, 89, 44, 157),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop; // close sheet
                        Navigator.of(context).push(
                          //context,
                          MaterialPageRoute(
                              builder: (_) => const SignUpPage())                     
                        );
                      },
                      //onPressed: _showLoginSheet, // <- call the bottom-sheet
                      child: const Text('Sign Up'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA71414),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            // spaceBetween pushes Forgot Password link to bottom
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(), // spacer at top
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Hello!\n\n\nAre you ready to workout?",
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge
                        !.copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  // now in a column!
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Color(0xFFA71414),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: _showLoginSheet,
                    child: const Text('Login'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Color(0xFFA71414),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () =>
                        Navigator.push(context, MaterialPageRoute(
                      builder: (_) {
                        return const SignUpPage();
                      },
                    )),
                    child: const Text('Sign Up'),
                  ),
                ],
              ),

              // — Forgot Password at bottom —
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const ResetPasswordPage()),
                ),
                child: const Text(
                  "Forgot password?",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
