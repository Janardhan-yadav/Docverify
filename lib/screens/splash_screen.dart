import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'personal_details_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'verify_hallticket_page.dart';
import 'intro_screen.dart'; // Add this import

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 2));

    User? user = FirebaseAuth.instance.currentUser;
    await user?.reload(); // Refresh user info

    if (user != null && user.emailVerified) {
      // Check if personal details exist
      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

      if (doc.exists && doc.data()?['name'] != null) {
        // Personal details exist, go to main app
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const VerifyHallTicketPage()),
        );
      } else if (doc.exists) {
        // No personal details yet
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const PersonalDetailsScreen()),
        );
      }
    } else {
      // New or logged out users go to intro screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const IntroScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: const Center(
        child: Text(
          'DocVerify',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}
