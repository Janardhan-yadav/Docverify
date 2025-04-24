import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'validation_results_page.dart';
import 'settings_page.dart';
import 'login_screen.dart'; // Adjust the import based on your project structure

class VerifyHallTicketPage extends StatefulWidget {
  const VerifyHallTicketPage({super.key});

  @override
  _VerifyHallTicketPageState createState() => _VerifyHallTicketPageState();
}

class _VerifyHallTicketPageState extends State<VerifyHallTicketPage> {
  final _hallTicketController = TextEditingController();
  final _registrationController = TextEditingController();
  String? _selectedCategory;
  String? _uploadedFileName;
  String? _filePath;

  @override
  void dispose() {
    _hallTicketController.dispose();
    _registrationController.dispose();
    super.dispose();
  }

  // Build non-editable info field
  Widget _buildInfoField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(value, style: const TextStyle(fontSize: 16)),
        ),
      ],
    );
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
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
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

  // Build category dropdown
  Widget _buildCategoryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'CATEGORY',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        DropdownButtonFormField<String>(
          value: _selectedCategory,
          hint: const Text('Select category'),
          items:
              ['GENERAL', 'OBC', 'SC/ST', 'OTHER']
                  .map(
                    (category) => DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    ),
                  )
                  .toList(),
          onChanged: (value) {
            setState(() {
              _selectedCategory = value;
            });
          },
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

  // Build upload button with updated UI
  Widget _buildUploadButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'UPLOAD DOCUMENT',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                  style: const TextStyle(fontSize: 14, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Drag files to upload, or',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
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
                              allowedExtensions: ['pdf', 'jpg', "jpeg", 'png'],
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
                    child: const Text(
                      'Choose File',
                      style: TextStyle(color: Colors.white, fontSize: 14),
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
        title: const Text('Verify Hall Ticket'),
        backgroundColor: Colors.blue,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(currentUser?.displayName ?? 'No Name'),
              accountEmail: Text(currentUser?.email ?? 'No Email'),
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
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
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
            const Text(
              'Verify Hall Ticket:',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildInfoField(
              'NAME',
              currentUser?.displayName ?? 'Not available',
            ),
            const SizedBox(height: 20),
            _buildInfoField("FATHER'S NAME", 'Not available'),
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
                          (context) => ValidationResultsPage(
                            name: currentUser?.displayName ?? 'Not available',
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
                child: const Text(
                  'VERIFY',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
