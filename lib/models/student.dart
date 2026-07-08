class Student {
  final String id;
  final String name;
  final String rollNo;
  final String grade;
  final String schoolName;
  final String avatarUrl;
  final double pendingAmount;
  final double totalAmount;

  const Student({
    required this.id,
    required this.name,
    required this.rollNo,
    required this.grade,
    required this.schoolName,
    required this.avatarUrl,
    required this.pendingAmount,
    required this.totalAmount,
  });

  double get paidAmount => totalAmount - pendingAmount;
  double get paymentProgress => totalAmount > 0 ? paidAmount / totalAmount : 0.0;
}
