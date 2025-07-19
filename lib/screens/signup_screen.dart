import 'package:flutter/material.dart';
import 'package:quizgenie/screens/login_screen.dart';
import 'package:quizgenie/services/firestore_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Enter Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Enter Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  )),
              SizedBox(
                height: 20,
              ),
              TextField(
                  controller: _roleController,
                  decoration: InputDecoration(
                    hintText: 'Enter Role(Tutor/Student)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  )),
              SizedBox(
                height: 20,
              ),
              FloatingActionButton.extended(
                backgroundColor: const Color.fromARGB(255, 69, 164, 74),
                onPressed: () async {
                  String email = _emailController.text.trim();
                  String password = _passwordController.text.trim();
                  String role = _roleController.text.trim().toLowerCase();
                  String? message = await FirestoreService.registerWithEmail(
                      email, password, role);
                  if (message == null) {
                    // Show success message
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Signed Up successfully!")),
                    );

                    // Navigate to next screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    );
                  } else {
                    // Show error message
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(message)),
                    );
                  }
                },
                label: Text(
                  "Sign up",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
