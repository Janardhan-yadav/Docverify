import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import 'faq_help_screen.dart'; // Import FAQHelpScreen

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue, // Deep blue background
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            // Logo
            Image.asset(
              'assets/doc_verify_logo.jpg', // Placeholder for the logo image
              height: 100,
            ),
            const SizedBox(height: 20),
            // Main content
            Column(
              children: [
                Text(
                  'DocVerify',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // White text for contrast
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  'Your trusted document verification app',
                  style: TextStyle(
                    fontSize: 16,
                    color:
                        Colors
                            .white70, // Slightly lighter white for description
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const Spacer(),
            // Sign In Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // White button background
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      10,
                    ), // Slightly rounded for toggle-like look
                  ),
                  elevation: 5, // Shadow for toggle effect
                ),
                child: const Text(
                  'Sign In',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF003087), // Blue text
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16), // Space between buttons
            // Register Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // White button background
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      10,
                    ), // Slightly rounded for toggle-like look
                  ),
                  elevation: 5, // Shadow for toggle effect
                ),
                child: const Text(
                  'Signup',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF003087), // Blue text
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const Spacer(flex: 1), // Reduced flex to adjust spacing
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16.0, right: 16.0),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FAQHelpScreen()),
            );
          },
          backgroundColor: Colors.white, // White circular background
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.question_mark,
                color: const Color(0xFF003087), // Blue question mark
                size: 24,
              ),
              Text(
                'Help',
                style: TextStyle(
                  color: const Color(0xFF003087), // Blue text
                  fontSize: 10, // Smaller font to fit within the circle
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
