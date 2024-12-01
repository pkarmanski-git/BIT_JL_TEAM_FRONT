import 'dart:ui'; // Required for blur effect
import 'package:flutter/material.dart';
import 'package:jl_team_front_bit/screens/register_screen.dart';
import 'package:jl_team_front_bit/screens/login_screen.dart';
import '../constants/colors.dart';
import '../service/service.dart';

class WelcomeScreen extends StatefulWidget {
  final Service service;

  const WelcomeScreen({
    super.key,
    required this.service,
  });

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with TickerProviderStateMixin {
  late AnimationController _fadeAnimationController;
  late Animation<double> _fadeAnimation;

  late AnimationController _logoAnimationController;
  late Animation<double> _logoAnimation;

  @override
  void initState() {
    super.initState();

    _fadeAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeAnimationController, curve: Curves.easeIn),
    );

    _logoAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _logoAnimation = Tween<double>(begin: 3.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoAnimationController, curve: Curves.easeOut),
    );

    _logoAnimationController.forward();

    Future.delayed(const Duration(seconds: 2), () {
      _fadeAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _fadeAnimationController.dispose();
    _logoAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
            child: Container(
              color: Colors.white54.withOpacity(0.1),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: ScaleTransition(
                    scale: _logoAnimation,
                    child: Image.asset(
                      'assets/logo.png',
                      height: 350,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // Fade-in dla przycisków
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      // Przycisk Log In
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.buttonColor,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(service: widget.service),
                              ),
                            );
                          },
                          child: Text(
                            'Log In',
                            style: TextStyle(
                              color: AppColors.buttonTextColor,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Przycisk Register
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondaryColor,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterScreen(service: widget.service),
                              ),
                            );
                          },
                          child: Text(
                            'Create an account',
                            style: TextStyle(
                              color: AppColors.buttonTextColor,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
