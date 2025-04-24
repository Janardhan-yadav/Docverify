import 'package:flutter/material.dart';

class FAQHelpScreen extends StatelessWidget {
  const FAQHelpScreen({super.key});

  static const List<Map<String, String>> faqs = [
    {
      "question": "What is DocVerify?",
      "answer":
          "DocVerify is a student-friendly app used for verifying your admission documents easily and quickly.",
    },
    {
      "question": "What documents do I need to upload?",
      "answer":
          "You’ll be asked to upload: Hall Ticket, Rank Card, Allotment Order, Income Certificate, Caste Certificate, SSC Memo.",
    },
    {
      "question": "What does ✅ and ❌ mean?",
      "answer":
          "✅ means the document information matches what you entered.\n❌ means there’s a difference – double-check your entry.",
    },
    {
      "question": "Can I continue even if there's a ❌?",
      "answer":
          "Yes, you're allowed to proceed to the next document even if there's a mismatch. Ensure the details are correct before final submission.",
    },
    {
      "question": "Can I edit my information later?",
      "answer":
          "Yes, you can edit your details before reaching the summary page.",
    },
    {
      "question": "Is my data safe?",
      "answer": "Yes, your data is handled with care and is kept secure.",
    },
    {
      "question": "Still Need Help?",
      "answer":
          "If you're stuck or unsure, contact your college helpdesk for assistance.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Help & FAQs"),
        backgroundColor: Colors.blue, // Blue color
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            "👋 Welcome to DocVerify – Help & FAQs",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF003087), // Blue color
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "This app helps you verify all your admission-related documents step-by-step. Whether you're using it for the first time or just need a refresher, this guide will walk you through everything you need to know.",
            style: TextStyle(fontSize: 16, color: Colors.grey[800]),
          ),
          const SizedBox(height: 24),
          Text(
            "🚀 How to Use DocVerify",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF003087),
            ),
          ),
          const SizedBox(height: 12),
          _buildStep(
            "1. Login/Register",
            "Start by entering your mobile number. You’ll get a one-time password (OTP) to log in.",
          ),
          _buildStep(
            "2. Enter Personal Details",
            "Fill in your full name, parents' names, date of birth, gender, category, and contact info.",
          ),
          _buildStep(
            "3. Upload and Validate Documents",
            "Choose a document, enter info, upload it, and see if it matches.",
          ),
          _buildStep(
            "4. Summary Page",
            "You’ll see which documents were verified or mismatched before final submission.",
          ),
          const SizedBox(height: 24),
          Text(
            "❓ Frequently Asked Questions",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF003087),
            ),
          ),
          const SizedBox(height: 12),
          ...faqs.map(
            (faq) => ExpansionTile(
              title: Text(
                faq['question']!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF003087),
                  fontSize: 16,
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Text(
                    faq['answer']!,
                    style: const TextStyle(color: Colors.black87, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep(String title, String detail) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_outline, color: const Color(0xFF003087)),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: "$title\n",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: detail,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 15,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
