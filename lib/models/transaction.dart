class PaymentTransaction {
  final String id;
  final String studentId;
  final String studentName;
  final String feeName;
  final double amount;
  final DateTime date;
  final String status; // "Verified", "Processing", "Rejected"
  final String method; // "UPI", "Bank Transfer", "Cheque", "Cash"
  final String utr;
  final String receiptNo;

  const PaymentTransaction({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.feeName,
    required this.amount,
    required this.date,
    required this.status,
    required this.method,
    required this.utr,
    required this.receiptNo,
  });
}
