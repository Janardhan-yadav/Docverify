import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Map<String, dynamic> _userData = {};
  bool _isEditing = false;
  bool _isLoading = true;
  final _formKey = GlobalKey<FormState>();

  // Controllers for editable fields
  final _nameController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _motherNameController = TextEditingController();
  final _dobController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    setState(() => _isLoading = true);
    final user = _auth.currentUser;
    if (user != null) {
      try {
        final doc = await _firestore.collection('users').doc(user.uid).get();
        if (doc.exists) {
          setState(() {
            _userData = doc.data()!;
            _nameController.text = _userData['name'] ?? '';
            _fatherNameController.text = _userData['fatherName'] ?? '';
            _motherNameController.text = _userData['motherName'] ?? '';
            _dobController.text = _userData['dob'] ?? '';
            _addressController.text = _userData['address'] ?? '';
            _isLoading = false;
          });
        } else {
          setState(() => _isLoading = false);
        }
      } catch (e) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error fetching data: $e')));
      }
    } else {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateUserData() async {
    if (_formKey.currentState!.validate()) {
      final user = _auth.currentUser;
      if (user != null) {
        try {
          await _firestore.collection('users').doc(user.uid).update({
            'name': _nameController.text,
            'fatherName': _fatherNameController.text,
            'motherName': _motherNameController.text,
            'dob': _dobController.text,
            'address': _addressController.text,
            'updatedAt': FieldValue.serverTimestamp(),
          });
          setState(() => _isEditing = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully!')),
          );
          await _fetchUserData();
        } catch (e) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error updating profile: $e')));
        }
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _dobController.text =
            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.blue,
        actions: [
          if (!_isEditing && !_isLoading && _userData.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => _isEditing = true),
            )
          else if (_isEditing)
            TextButton(
              onPressed: _updateUserData,
              child: const Text('SAVE', style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _userData.isEmpty
              ? const Center(child: Text('No personal details found'))
              : Padding(
                padding: const EdgeInsets.all(20.0),
                child: _isEditing ? _buildEditForm() : _buildViewMode(),
              ),
    );
  }

  Widget _buildViewMode() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Personal Details:',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          _buildDetailItem('Name:', _userData['name'] ?? 'Not provided'),
          _buildDetailItem(
            "Father's Name:",
            _userData['fatherName'] ?? 'Not provided',
          ),
          _buildDetailItem(
            "Mother's Name:",
            _userData['motherName'] ?? 'Not provided',
          ),
          _buildDetailItem(
            "Date of Birth:",
            _userData['dob'] ?? 'Not provided',
          ),
          _buildDetailItem("Address:", _userData['address'] ?? 'Not provided'),
          _buildDetailItem(
            "Email:",
            _auth.currentUser?.email ?? 'Not available',
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 16, color: Colors.grey)),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(fontSize: 18),
            maxLines: label == 'Address:' ? 3 : 1,
            overflow: TextOverflow.ellipsis,
          ),
          const Divider(height: 20),
        ],
      ),
    );
  }

  Widget _buildEditForm() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Edit Your Details:',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildEditableField(
              'Name',
              _nameController,
              'Enter your full name',
            ),
            const SizedBox(height: 15),
            _buildEditableField(
              "Father's Name",
              _fatherNameController,
              "Enter father's name",
            ),
            const SizedBox(height: 15),
            _buildEditableField(
              "Mother's Name",
              _motherNameController,
              "Enter mother's name",
            ),
            const SizedBox(height: 15),
            _buildDateField('Date of Birth', _dobController),
            const SizedBox(height: 15),
            _buildAddressField('Address', _addressController),
            const SizedBox(height: 15),
            _buildReadOnlyField(
              'Email',
              _auth.currentUser?.email ?? 'Not available',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableField(
    String label,
    TextEditingController controller,
    String hint,
  ) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      validator:
          (value) => value == null || value.isEmpty ? 'Required field' : null,
    );
  }

  Widget _buildDateField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: () => _selectDate(context),
        ),
      ),
      readOnly: true,
      validator:
          (value) => value == null || value.isEmpty ? 'Required field' : null,
    );
  }

  Widget _buildAddressField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      maxLines: 3,
      decoration: InputDecoration(
        labelText: label,
        alignLabelWithHint: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      validator:
          (value) => value == null || value.isEmpty ? 'Required field' : null,
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return TextFormField(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      enabled: false,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _fatherNameController.dispose();
    _motherNameController.dispose();
    _dobController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}
