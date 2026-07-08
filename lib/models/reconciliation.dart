class ReconciliationItem {
  final String id;
  final String studentName;
  final String grade;
  final String feeName;
  final double amountExtracted;
  final double amountExpected;
  final String utrExtracted;
  final DateTime dateExtracted;
  final String paymentMethod;
  final double confidenceScore; // e.g. 0.98 for 98%
  final String imageUrl;
  String status; // "Processing", "Matched", "Verified", "Rejected", "Requested Proof"

  ReconciliationItem({
    required this.id,
    required this.studentName,
    required this.grade,
    required this.feeName,
    required this.amountExtracted,
    required this.amountExpected,
    required this.utrExtracted,
    required this.dateExtracted,
    required this.paymentMethod,
    required this.confidenceScore,
    required this.imageUrl,
    required this.status,
  });
}
