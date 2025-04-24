import 'package:flutter/material.dart';

class ValidationResultsPage extends StatelessWidget {
  final String name;
  final String hallTicketNumber;
  final String registrationNumber;
  final String category;

  const ValidationResultsPage({
    super.key,
    required this.name,
    required this.hallTicketNumber,
    required this.registrationNumber,
    required this.category,
  });

  // Simple validation logic (replace with actual backend validation)
  bool _isValidField(String field) {
    return field.isNotEmpty && field.length >= 3; // Example validation rule
  }

  @override
  Widget build(BuildContext context) {
    // Simulate validation results
    bool isHallTicketNumberValid = _isValidField(hallTicketNumber);
    bool isRegistrationNumberValid = _isValidField(registrationNumber);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verification Results'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Based on the submitted documents, the following columns have been matched:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            _buildResultRow('NAME', true),
            _buildResultRow(
              "FATHER'S NA...",
              true,
            ), // Placeholder for Father's Name
            _buildResultRow('HALL TICKET', true),
            _buildResultRow('CATEGORY', true),
            const SizedBox(height: 30),
            const Text(
              'The following columns have discrepancies:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            _buildResultRow('HALL TICKET NUMBER', isHallTicketNumberValid),
            _buildResultRow('REGISTRATION NUMBER', isRegistrationNumberValid),
            const Spacer(),
            Row(
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
                  child: const Text(
                    'Reload',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Add logic for the "Next" button (e.g., navigate to another page)
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
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, bool isValid) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          Icon(
            isValid ? Icons.check : Icons.close,
            color: isValid ? Colors.green : Colors.red,
            size: 24,
          ),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
