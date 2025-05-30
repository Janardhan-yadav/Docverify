class ValidationResponse {
  final String documentType;
  final String filename;
  final String extractedText;
  final Map<String, String> extractedEntities;
  final Map<String, ValidationResult> validationResult;
  final String status;

  ValidationResponse({
    required this.documentType,
    required this.filename,
    required this.extractedText,
    required this.extractedEntities,
    required this.validationResult,
    required this.status,
  });

  factory ValidationResponse.fromJson(Map<String, dynamic> json) {
    return ValidationResponse(
      documentType: json['document_type'] as String,
      filename: json['filename'] as String,
      extractedText: json['extracted_text'] as String,
      extractedEntities: Map<String, String>.from(
        json['extracted_entities'] as Map,
      ),
      validationResult: (json['validation_result'] as Map).map(
        (key, value) => MapEntry(
          key,
          ValidationResult.fromJson(value as Map<String, dynamic>),
        ),
      ),
      status: json['status'] as String,
    );
  }
}

class ValidationResult {
  final String formValue;
  final String extractedValue;
  final bool isValid;

  ValidationResult({
    required this.formValue,
    required this.extractedValue,
    required this.isValid,
  });

  factory ValidationResult.fromJson(Map<String, dynamic> json) {
    return ValidationResult(
      formValue: json['form_value'] as String,
      extractedValue: json['extracted_value'] as String,
      isValid: json['is_valid'] as bool,
    );
  }
}
