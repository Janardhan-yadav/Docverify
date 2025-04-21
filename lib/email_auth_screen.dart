import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmailAuthScreen extends StatefulWidget {
  const EmailAuthScreen({super.key});

  @override
  _EmailAuthScreenState createState() => _EmailAuthScreenState();
}

class _EmailAuthScreenState extends State<EmailAuthScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isVerified = false;

  Future<void> _register() async {
    try {
      UserCredential userCred = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!userCred.user!.emailVerified) {
        await userCred.user!.sendEmailVerification();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Verification email sent. Please check your inbox."),
          ),
        );
      }
    } catch (e) {
      print("Registration Failed: $e");
    }
  }

  Future<void> _login() async {
    try {
      UserCredential userCred = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await userCred.user!.reload(); // Reload to get updated emailVerified
      bool verified = userCred.user!.emailVerified;

      setState(() {
        isVerified = verified;
      });

      if (verified) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Email verified! Login successful.")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Email not verified. Please verify your email."),
          ),
        );
      }
    } catch (e) {
      print("Login Failed: $e");
    }
  }

  Future<void> _checkVerificationStatus() async {
    User? user = _auth.currentUser;
    await user?.reload();
    setState(() {
      isVerified = user?.emailVerified ?? false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isVerified
              ? "Your email is verified ✅"
              : "Your email is NOT verified ❌",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Email Auth')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Enter Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Enter Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _register, child: Text('Register')),
            ElevatedButton(onPressed: _login, child: Text('Login')),
            ElevatedButton(
              onPressed: _checkVerificationStatus,
              child: Text('Check Email Verification Status'),
            ),
          ],
        ),
      ),
    );
  }
}
