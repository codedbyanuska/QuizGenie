// import 'package:flutter/material.dart';
// import 'package:quizgenie/screens/student/student_home_screen.dart';
// import 'package:quizgenie/screens/teacher/tutor_dashboard_screen.dart'; // Add this import
// import 'package:quizgenie/services/firestore_service.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//         child: Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 "Login",
//                 style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 30,
//                     fontWeight: FontWeight.w600),
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               TextField(
//                 controller: _emailController,
//                 decoration: InputDecoration(
//                   hintText: 'Enter Email',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                   contentPadding:
//                       EdgeInsets.symmetric(vertical: 16, horizontal: 24),
//                 ),
//               ),
//               SizedBox(height: 20),
//               TextField(
//                   controller: _passwordController,
//                   obscureText: true,
//                   decoration: InputDecoration(
//                     hintText: 'Enter Password',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                     contentPadding:
//                         EdgeInsets.symmetric(vertical: 16, horizontal: 24),
//                   )),
//               SizedBox(
//                 height: 20,
//               ),
//               FloatingActionButton.extended(
//                 backgroundColor: const Color.fromARGB(255, 69, 164, 74),
//                 onPressed: () async {
//                   String email = _emailController.text.trim();
//                   String password = _passwordController.text.trim();
//                   String? message = await FirestoreService.loginWith(
//                       email, password); // Dummy login validation
//                   if (message == 'student') {
//                     // Show success message
//                     if (!mounted) return;
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(content: Text("Logged in successfully!")),
//                     );

//                     // Navigate to next screen
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => const StudentHomeScreen()),
//                     );
//                   } else if (message == 'tutor') {
//                     if (!mounted) return;
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(content: Text("Logged in successfully!")),
//                     );

//                     // Navigate to next screen
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => const TutorDashboard()),
//                     );
//                   } else {
//                     // Show error message
//                     if (!mounted) return;
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text(message!)),
//                     );
//                   }
//                 },
//                 label: Text(
//                   "Login",
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     ));
//   }
// }



import 'package:flutter/material.dart';
import 'package:quizgenie/screens/student/student_home_screen.dart';
import 'package:quizgenie/screens/teacher/tutor_dashboard_screen.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [const Color(0xFF0F2027), const Color(0xFF203A43)]
                : [const Color(0xFFE3F2FD), const Color(0xFFBBDEFB)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Email Field
                  _buildInputField(
                    controller: _emailController,
                    hint: "Enter Email",
                    icon: Icons.email,
                  ),
                  const SizedBox(height: 20),

                  // Password Field
                  _buildInputField(
                    controller: _passwordController,
                    hint: "Enter Password",
                    icon: Icons.lock,
                    obscure: true,
                  ),
                  const SizedBox(height: 30),

                  // Login Button
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isDark ? const Color(0xFF64FFDA) : Colors.indigo,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 6,
                    ),
                    onPressed: () async {
                      final email = _emailController.text.trim();
                      final password = _passwordController.text.trim();

                      final message = await FirestoreService.loginWith(
                          email, password);

                      if (!mounted) return;

                      if (message == 'student') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Logged in successfully!")),
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const StudentHomeScreen()),
                        );
                      } else if (message == 'tutor') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Logged in successfully!")),
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const TutorDashboard()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(message ?? "Login failed")),
                        );
                      }
                    },
                    icon: const Icon(Icons.login, color: Colors.white),
                    label: const Text(
                      "Login",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/signup');
                    },
                    child: const Text("Don't have an account? Sign Up"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.white10 : Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: isDark ? Colors.tealAccent : null),
          hintText: hint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        ),
      ),
    );
  }
}
