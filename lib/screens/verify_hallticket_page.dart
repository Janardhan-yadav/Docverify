import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';

import 'validation_results_page.dart';
import 'settings_page.dart';
import 'login_screen.dart';
import 'faq_help_screen.dart'; // Add this if missing

class VerifyHallTicketPage extends StatefulWidget {
  const VerifyHallTicketPage({super.key});

  @override
  State<VerifyHallTicketPage> createState() => _VerifyHallTicketPageState();
}

class _VerifyHallTicketPageState extends State<VerifyHallTicketPage> {
  final TextEditingController _hallTicketController = TextEditingController();
  final TextEditingController _registrationController = TextEditingController();
  String? _selectedCategory;
  String? _uploadedFileName;
  String? _filePath;
  String _userName = 'Not available';
  String _fatherName = 'Not available';

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        DocumentSnapshot userDoc =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(currentUser.uid)
                .get();

        if (userDoc.exists) {
          setState(() {
            _userName = userDoc.get('name') ?? 'Not available';
            _fatherName = userDoc.get('fatherName') ?? 'Not available';
          });
        }
      } catch (e) {
        debugPrint("Error fetching user details: $e");
      }
    }
  }

  @override
  void dispose() {
    _hallTicketController.dispose();
    _registrationController.dispose();
    super.dispose();
  }

  Widget _buildInfoField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: _labelStyle()),
        const SizedBox(height: 5),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          decoration: _inputDecoration(),
          child: Text(value, style: _inputTextStyle()),
        ),
      ],
    );
  }

  Widget _buildEditableField(
    String label,
    String hintText,
    TextEditingController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: _labelStyle()),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: GoogleFonts.poppins(color: Colors.grey),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 12,
            ),
          ),
          style: _inputTextStyle(),
        ),
      ],
    );
  }

  Widget _buildCategoryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('CATEGORY', style: _labelStyle()),
        const SizedBox(height: 5),
        DropdownButtonFormField<String>(
          value: _selectedCategory,
          hint: Text(
            'Select category',
            style: GoogleFonts.poppins(color: Colors.grey),
          ),
          items:
              ['GENERAL', 'OBC', 'SC/ST', 'OTHER'].map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category, style: _inputTextStyle()),
                );
              }).toList(),
          onChanged: (value) => setState(() => _selectedCategory = value),
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('UPLOAD DOCUMENT', style: _labelStyle()),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: _inputDecoration(),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: _uploadedFileName != null ? 1.0 : 0,
                    strokeWidth: 8,
                    backgroundColor: Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.blue,
                    ),
                  ),
                  Icon(
                    Icons.description,
                    size: 40,
                    color:
                        _uploadedFileName != null ? Colors.blue : Colors.grey,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (_uploadedFileName != null)
                Text(
                  _uploadedFileName!,
                  style: _inputTextStyle(),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Drag files to upload, or', style: _hintTextStyle()),
                  const SizedBox(width: 5),
                  ElevatedButton(
                    onPressed: _pickFile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 8,
                      ),
                    ),
                    child: Text(
                      'Choose File',
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                  ),
                ],
              ),
              if (_uploadedFileName != null)
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: const Icon(Icons.clear, color: Colors.red),
                    onPressed:
                        () => setState(() {
                          _uploadedFileName = null;
                          _filePath = null;
                        }),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _pickFile() async {
    await FilePicker.platform.clearTemporaryFiles();
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );
      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _uploadedFileName = result.files.first.name;
          _filePath = result.files.first.path;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error picking file: $e')));
    }
  }

  TextStyle _labelStyle() => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.indigo,
  );
  TextStyle _inputTextStyle() =>
      GoogleFonts.poppins(fontSize: 16, color: Colors.black87);
  TextStyle _hintTextStyle() =>
      GoogleFonts.poppins(fontSize: 14, color: Colors.grey);
  BoxDecoration _inputDecoration() => BoxDecoration(
    border: Border.all(color: Colors.grey),
    borderRadius: BorderRadius.circular(10),
  );

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Verify Hall Ticket',
          style: GoogleFonts.poppins(fontSize: 20, color: Colors.white),
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
      ),
      drawer: _buildDrawer(currentUser),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildInfoField('NAME', _userName),
            const SizedBox(height: 20),
            _buildInfoField("FATHER'S NAME", _fatherName),
            const SizedBox(height: 20),
            _buildEditableField(
              'HALLTICKET NUMBER',
              'Enter your hall ticket number',
              _hallTicketController,
            ),
            const SizedBox(height: 20),
            _buildEditableField(
              'REGISTRATION NUMBER',
              'Enter your registration number',
              _registrationController,
            ),
            const SizedBox(height: 20),
            _buildCategoryDropdown(),
            const SizedBox(height: 20),
            _buildUploadButton(),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => ValidationResultsHallTicketPage(
                            name: _userName,
                            hallTicketNumber: _hallTicketController.text,
                            registrationNumber: _registrationController.text,
                            category: _selectedCategory ?? 'GENERAL',
                          ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                ),
                child: Text(
                  'VERIFY',
                  style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Drawer _buildDrawer(User? currentUser) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              _userName,
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
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      )
                      : const Icon(Icons.person, size: 40, color: Colors.blue),
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
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                ),
          ),
          ListTile(
            leading: const Icon(Icons.help, color: Colors.blue),
            title: Text('Help & FAQ', style: GoogleFonts.poppins(fontSize: 16)),
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FAQHelpScreen(),
                  ),
                ),
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text('Logout', style: GoogleFonts.poppins(fontSize: 16)),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
