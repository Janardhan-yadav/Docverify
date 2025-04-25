import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'settings_page.dart';
import 'login_screen.dart';
import 'faq_help_screen.dart';
import 'validation_results_joiningreport.dart'; // Import for navigation

class VerifyJoiningReportPage extends StatefulWidget {
  const VerifyJoiningReportPage({super.key});

  @override
  _VerifyJoiningReportPageState createState() =>
      _VerifyJoiningReportPageState();
}

class _VerifyJoiningReportPageState extends State<VerifyJoiningReportPage> {
  final _nameController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _hallTicketController = TextEditingController();
  final _admissionController = TextEditingController();
  String? _uploadedFileName;
  String? _filePath;

  @override
  void dispose() {
    _nameController.dispose();
    _fatherNameController.dispose();
    _hallTicketController.dispose();
    _admissionController.dispose();
    super.dispose();
  }

  // Build editable input field
  Widget _buildEditableField(
    String label,
    String hintText,
    TextEditingController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.indigo,
          ),
        ),
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
          style: GoogleFonts.poppins(fontSize: 16),
        ),
      ],
    );
  }

  // Build upload button
  Widget _buildUploadButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'UPLOAD DOCUMENT',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.indigo,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(
                      value: _uploadedFileName != null ? 1.0 : 0,
                      strokeWidth: 8,
                      backgroundColor: Colors.grey[300],
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.blue,
                      ),
                    ),
                  ),
                  if (_uploadedFileName != null)
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        const Icon(
                          Icons.description,
                          size: 40,
                          color: Colors.blue,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green,
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    const Icon(Icons.description, size: 40, color: Colors.grey),
                ],
              ),
              const SizedBox(height: 10),
              if (_uploadedFileName != null)
                Text(
                  _uploadedFileName!,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Drag files to upload, or',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 5),
                  ElevatedButton(
                    onPressed: () async {
                      await FilePicker.platform.clearTemporaryFiles();
                      print('Cleared temporary files');

                      try {
                        FilePickerResult? result = await FilePicker.platform
                            .pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
                            );

                        if (result != null && result.files.isNotEmpty) {
                          setState(() {
                            _uploadedFileName = result.files.first.name;
                            _filePath = result.files.first.path;
                            print(
                              'File selected: $_uploadedFileName, Path: $_filePath',
                            );
                          });
                        } else {
                          print('No file selected');
                        }
                      } catch (e) {
                        print('Error picking file: $e');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error picking file: $e')),
                        );
                      }
                    },
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
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              if (_uploadedFileName != null)
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: const Icon(Icons.clear, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        _uploadedFileName = null;
                        _filePath = null;
                        print('File selection cleared');
                      });
                    },
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Verify Joining Report',
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
                  if (mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  }
                } catch (e) {
                  print('Logout failed: $e');
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Logout failed: $e')),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Verify Joining Report:',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 20),
            _buildEditableField('NAME', 'Enter your name', _nameController),
            const SizedBox(height: 20),
            _buildEditableField(
              "FATHER'S NAME",
              'Enter father\'s name',
              _fatherNameController,
            ),
            const SizedBox(height: 20),
            _buildEditableField(
              'HALL TICKET NUMBER',
              'Enter hall ticket number',
              _hallTicketController,
            ),
            const SizedBox(height: 20),
            _buildEditableField(
              'ADMISSION NUMBER',
              'Enter admission number',
              _admissionController,
            ),
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
                          (context) => ValidationResultsJoiningReportPage(
                            name: _nameController.text,
                            fatherName: _fatherNameController.text,
                            hallTicketNumber: _hallTicketController.text,
                            admissionNumber: _admissionController.text,
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
}
