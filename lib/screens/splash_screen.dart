import 'package:flutter/material.dart';
import 'welcome_screen.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
        super.initState();
        navigateToWelcome();
  }
  Future navigateToWelcome() async
  {
    Future.delayed(Duration(seconds: 3));
    Navigator.pushReplacement(context, MaterialPageRoute(builder:(context) => const WelcomeScreen()));
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:Center(
        child: Column(
          children: [
            Image.asset('images/quizapp_logo.png'),
            SizedBox(height: 15),
            CircularProgressIndicator()
          ],
        ),
      )
    );
  }
}
