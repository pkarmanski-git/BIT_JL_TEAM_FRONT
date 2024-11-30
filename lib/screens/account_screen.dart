import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {

  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTopSection(context),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildTopSection(BuildContext context) {
    return Column();
  }
}