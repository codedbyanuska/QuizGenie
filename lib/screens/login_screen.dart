import 'package:flutter/material.dart';
import 'package:quizgenie/screens/student/student_home_screen.dart';
import 'package:quizgenie/screens/teacher/tutor_home_screen.dart';
import 'package:quizgenie/services/firestore_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Login",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 20,
              ),
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
              FloatingActionButton.extended(
                backgroundColor: const Color.fromARGB(255, 69, 164, 74),
                onPressed: () async {
                  String email = _emailController.text.trim();
                  String password = _passwordController.text.trim();
                  String? message = await FirestoreService.loginWith(
                      email, password); // Dummy login validation
                  if (message == 'student') {
                    // Show success message
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Logged in successfully!")),
                    );

                    // Navigate to next screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const StudentHomeScreen()),
                    );
                  } else if (message == 'tutor') {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Logged in successfully!")),
                    );

                    // Navigate to next screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TutorHomeScreen()),
                    );
                  } else {
                    // Show error message
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(message!)),
                    );
                  }
                },
                label: Text(
                  "Login",
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
