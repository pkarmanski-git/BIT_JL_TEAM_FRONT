import 'dart:ui'; // Required for blur effect
import 'package:flutter/material.dart';
import 'package:jl_team_front_bit/screens/RegisterScreen.dart';
import 'package:jl_team_front_bit/screens/SwipeScreen.dart';
import '../constants/colors.dart';
import '../service/service.dart';
import 'CommunitiesScreen.dart';
import 'LoginScreen.dart';

class WelcomeScreen extends StatelessWidget {
  final Service service;

  const WelcomeScreen({
    super.key,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Blur effect overlay
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
            child: Container(
              color: Colors.white54.withOpacity(0.1), // Add semi-transparent overlay
            ),
          ),
          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Logo in the center with Hero animation
                Hero(
                  tag: 'logo', // Matching tag for Hero animation
                  child: Image.asset(
                    'assets/logo.png', // Path to your logo
                    height: 200, // Adjust the size as needed
                  ),
                ),
                const SizedBox(height: 40),
                // Log In button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0), // Add padding to restrict width
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
                          builder: (context) => LoginScreen(service: service),
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
                // Register button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0), // Same padding for consistency
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
                          builder: (context) => RegisterScreen(service: service),
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
                const SizedBox(height: 20),
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
                          builder: (context) => CommunitiesScreen(service: service),
                        ),
                      );
                    },
                    child: const Text(
                      'Explore Communities',
                      style: TextStyle(
                        color: AppColors.buttonTextColor,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                // Test SwipeScreen button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0), // Same padding for consistency
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
                          builder: (context) => SwipeScreen(service: service),
                        ),
                      );
                    },
                    child: Text(
                      'Test Swipe Screen',
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
    );
  }
}
