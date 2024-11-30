import 'dart:ui';
import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  Future<void> _register(String email, String password, String confirmPassword) async {
    if (password != confirmPassword) {
      // Obsługa błędu: hasła się nie zgadzają
      print('Passwords do not match!');
      return;
    }

    final response = await http.post(
      Uri.parse('https://twoj-backend.com/api/register'),
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      // Obsługa rejestracji
      print('Registration successful!');
    } else {
      // Obsługa błędów
      print('Registration error: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'), // Path to your background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Blur effect overlay
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0), // Adjust blur intensity
            child: Container(
              color: Colors.white54.withOpacity(0.1), // Add semi-transparent overlay
            ),
          ),
          // Main content
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Header text
                  Text(
                    'Create your account',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textColor,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Email field
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 10),
                  // Password field
                  TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 10),
                  // Confirm Password field
                  TextField(
                    controller: confirmPasswordController,
                    decoration: const InputDecoration(
                      labelText: 'Confirm Password',
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 30),
                  // Register button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonColor,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    onPressed: () {
                      _register(
                        emailController.text,
                        passwordController.text,
                        confirmPasswordController.text,
                      );
                    },
                    child: Text(
                      'Create Account',
                      style: TextStyle(
                        color: AppColors.buttonTextColor,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
