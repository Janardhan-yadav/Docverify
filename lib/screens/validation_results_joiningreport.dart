import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'settings_page.dart';
import 'login_screen.dart';
import 'faq_help_screen.dart';
import 'verify_joining_report.dart';
import 'verify_tenth_memo.dart'; // Import for navigation

class ValidationResultsJoiningReportPage extends StatelessWidget {
  final String name;
  final String fatherName;
  final String hallTicketNumber;
  final String admissionNumber;

  const ValidationResultsJoiningReportPage({
    super.key,
    required this.name,
    required this.fatherName,
    required this.hallTicketNumber,
    required this.admissionNumber,
  });

  // Validation logic (all fields are valid for this demo)
  bool _isValidField(String field) {
    return true; // Set all fields as valid to mark them as matched
  }

  @override
  Widget build(BuildContext context) {
    // Validation results (all fields are valid for demo)
    bool isNameValid = _isValidField(name);
    bool isFatherNameValid = _isValidField(fatherName);
    bool isHallTicketValid = _isValidField(hallTicketNumber);
    bool isAdmissionNumberValid = _isValidField(admissionNumber);
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Verification Results',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.indigo],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 4,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                currentUser?.displayName ?? 'No Name',
                style: GoogleFonts.poppins(fontSize: 16),
              ),
              accountEmail: Text(
                currentUser?.email ?? 'No Email',
                style: GoogleFonts.poppins(fontSize: 14),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child:
                    currentUser?.photoURL != null
                        ? ClipOval(
                          child: Image.network(
                            currentUser!.photoURL!,
                            fit: BoxFit.cover,
                            width: 60,
                            height: 60,
                          ),
                        )
                        : const Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.blue,
                        ),
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.indigo],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.blue),
              title: Text('Settings', style: GoogleFonts.poppins(fontSize: 16)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.help, color: Colors.blue),
              title: Text(
                'Help & FAQ',
                style: GoogleFonts.poppins(fontSize: 16),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FAQHelpScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: Text('Logout', style: GoogleFonts.poppins(fontSize: 16)),
              onTap: () async {
                try {
                  await FirebaseAuth.instance.signOut();
                  print('Logout successful');
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                } catch (e) {
                  print('Logout failed: $e');
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Logout failed: $e')));
                }
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Validation Results of Joining Report',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Matched Columns',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildResultRow('NAME', isNameValid),
                    _buildResultRow("FATHER'S NAME", isFatherNameValid),
                    _buildResultRow('HALL TICKET NUMBER', isHallTicketValid),
                    _buildResultRow('ADMISSION NUMBER', isAdmissionNumberValid),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Discrepancies',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // No discrepancies since all fields are valid
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 24,
            ), // Extra padding to prevent overlap with buttons
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context); // Go back to the previous screen
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.grey),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                ),
                child: Text(
                  'Reupload',
                  style: GoogleFonts.poppins(fontSize: 16, color: Colors.black),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const VerifyTenthMemoPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                  elevation: 2,
                ),
                child: Text(
                  'Next',
                  style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, bool isValid) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            isValid ? Icons.check_circle : Icons.cancel,
            color: isValid ? Colors.green : Colors.red,
            size: 28,
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
