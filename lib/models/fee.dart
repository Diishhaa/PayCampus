enum FeeStatus {
  paid,
  pending,
  overdue,
}

class Fee {
  final String id;
  final String studentId;
  final String name;
  final double amount;
  final DateTime dueDate;
  final FeeStatus status;
  final String category;
  final double lateFee;
  final String lateFeeStatus; // "Active", "Waived", "None"
  final double waiverAmount;

  const Fee({
    required this.id,
    required this.studentId,
    required this.name,
    required this.amount,
    required this.dueDate,
    required this.status,
    required this.category,
    this.lateFee = 0.0,
    this.lateFeeStatus = "None",
    this.waiverAmount = 0.0,
  });

  double get netAmount => amount + lateFee - waiverAmount;

  String get statusText {
    switch (status) {
      case FeeStatus.paid:
        return 'Paid';
      case FeeStatus.pending:
        return 'Pending';
      case FeeStatus.overdue:
        return 'Overdue';
    }
  }
}
