import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';
import 'settings_page.dart';

class VerifyHallTicketPage extends StatelessWidget {
  const VerifyHallTicketPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Hall Ticket'),
        backgroundColor: Colors.blue,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Colors.blue),
              accountName: Text(
                currentUser?.displayName ?? 'No Name',
                style: const TextStyle(fontSize: 18),
              ),
              accountEmail: Text(
                currentUser?.email ?? 'No Email',
                style: const TextStyle(fontSize: 16),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child:
                    currentUser?.photoURL != null
                        ? ClipOval(
                          child: Image.network(
                            currentUser!.photoURL!,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
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
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                try {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                    (route) => false,
                  );
                } catch (e) {
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
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Verify Hall Ticket:',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            _buildInfoField(
              'NAME',
              currentUser?.displayName ?? 'Not available',
            ),
            const SizedBox(height: 20),
            _buildInfoField("EMAIL", currentUser?.email ?? 'Not available'),
            const SizedBox(height: 20),
            _buildEditableField(
              'HALLTICKET NUMBER',
              'Enter your hall ticket number',
            ),
            const SizedBox(height: 20),
            _buildEditableField(
              'REGISTRATION NUMBER',
              'Enter your registration number',
            ),
            const SizedBox(height: 20),
            _buildCategoryDropdown(),
            const SizedBox(height: 20),
            const Text(
              'UPLOAD DOCUMENT',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              height: 150,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.upload_file, size: 40, color: Colors.blue),
                  SizedBox(height: 10),
                  Text(
                    'UPLOAD A DOCUMENT',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'GENERAL',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Add verification logic here
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

  Widget _buildEditableField(String label, String hintText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        TextFormField(
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

  Widget _buildCategoryDropdown() {
    const List<String> categories = ['GENERAL', 'OBC', 'SC/ST', 'OTHER'];
    String? selectedCategory = categories[0];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'CATEGORY',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        DropdownButtonFormField<String>(
          value: selectedCategory,
          items:
              categories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
          onChanged: (String? newValue) {
            selectedCategory = newValue;
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
}
