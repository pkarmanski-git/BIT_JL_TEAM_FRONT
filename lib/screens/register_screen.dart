import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:jl_team_front_bit/screens/quiz_screen.dart';
import '../constants/colors.dart';
import '../enums/service_errors.dart';
import '../model/service_response.dart';
import '../service/service.dart';

class RegisterScreen extends StatefulWidget {
  final Service service;

  const RegisterScreen({super.key, required this.service});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Form key for validation

  bool isLoading = false;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) {
      return; // Stop registration if the form is invalid
    }

    setState(() {
      isLoading = true;
    });

    ServiceResponse response = await widget.service.register(
      emailController.text,
      passwordController.text,
      confirmPasswordController.text,
    );

    setState(() {
      isLoading = false;
    });

    if (response.error == ServiceErrors.ok) {
      widget.service.login(emailController.text, passwordController.text);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => QuizScreen(service: widget.service),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred during registration')),
      );
    }
  }

  String? _validateEmail(String? value) {
    final emailRegExp =
    RegExp(r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');
    if (value == null || value.isEmpty) {
      return 'Email is required';
    } else if (!emailRegExp.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    } else if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirm your password';
    } else if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
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
              child: Form(
                key: _formKey, // Attach form key
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
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: _validateEmail, // Attach email validator
                    ),
                    const SizedBox(height: 10),
                    // Password field
                    TextFormField(
                      controller: passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock),
                      ),
                      obscureText: true,
                      validator: _validatePassword, // Attach password validator
                    ),
                    const SizedBox(height: 10),
                    // Confirm Password field
                    TextFormField(
                      controller: confirmPasswordController,
                      decoration: const InputDecoration(
                        labelText: 'Confirm Password',
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                      obscureText: true,
                      validator: _validateConfirmPassword, // Attach confirm password validator
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
          // Positioned Register button at the bottom
          Positioned(
            bottom: 30, // Distance from bottom edge of screen
            left: 40, // Same left padding as the other elements
            right: 40, // Same right padding as the other elements
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.buttonColor,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onPressed: isLoading ? null : _register, // Call _register if not loading
              child: isLoading
                  ? CircularProgressIndicator(color: AppColors.buttonTextColor)
                  : Text(
                'Create Account',
                style: TextStyle(
                  color: AppColors.buttonTextColor,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
