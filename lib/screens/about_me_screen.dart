import 'package:flutter/material.dart';
import 'intro_screen.dart';
import '../model/profile_me.dart';
import 'quiz_screen.dart';
import '../constants/colors.dart';
import '../service/service.dart';

class AboutMeScreen extends StatefulWidget {
  final Service service;

  const AboutMeScreen({super.key, required this.service});

  @override
  _AboutMeScreenState createState() => _AboutMeScreenState();
}

class _AboutMeScreenState extends State<AboutMeScreen> {
  final _nicknameController = TextEditingController();
  final _ageController = TextEditingController();
  String? _selectedLocation;

  final List<String> _locations = ['New York', 'London', 'Tokyo'];

  String? _errorMessage;

  void _validateAndContinue() {
    setState(() {
      _errorMessage = null;
    });

    if (_nicknameController.text.isEmpty) {
      setState(() {
        _errorMessage = "Nickname is required.";
      });
      return;
    }
    if (_ageController.text.isEmpty) {
      setState(() {
        _errorMessage = "Age is required.";
      });
      return;
    }
    if (int.tryParse(_ageController.text) == null || int.parse(_ageController.text) <= 0) {
      setState(() {
        _errorMessage = "Please enter a valid age.";
      });
      return;
    }
    if (_selectedLocation == null) {
      setState(() {
        _errorMessage = "Location is required.";
      });
      return;
    }
    ProfileMe profileMe = ProfileMe(
        _nicknameController.text,
        int.tryParse(_ageController.text) ?? 0,
        _selectedLocation ?? ""
    );
    widget.service.profileUser(profileMe);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => IntroScreen(service: widget.service),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.psychology,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              'About Me',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal, Colors.greenAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        centerTitle: true,
        elevation: 4,
        toolbarHeight: 70,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Tell us about yourself',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _nicknameController,
                decoration: const InputDecoration(
                  labelText: 'Nickname',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _ageController,
                decoration: const InputDecoration(
                  labelText: 'Age',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedLocation,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  prefixIcon: Icon(Icons.location_on),
                ),
                items: _locations.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedLocation = newValue;
                  });
                },
              ),
              const SizedBox(height: 20),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonColor,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                onPressed: _validateAndContinue,
                child: Text(
                  'Continue',
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
    );
  }
}
