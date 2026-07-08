import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../models/fee.dart';
import '../../../models/student.dart';
import 'payment_screen.dart';

class FeeDetailsScreen extends StatefulWidget {
  final Student student;

  const FeeDetailsScreen({super.key, required this.student});

  @override
  State<FeeDetailsScreen> createState() => _FeeDetailsScreenState();
}

class _FeeDetailsScreenState extends State<FeeDetailsScreen> {
  late List<Fee> _fees;

  @override
  void initState() {
    super.initState();
    _fees = [
      Fee(
        id: "fee_1",
        studentId: widget.student.id,
        name: "Term 2 Tuition Fee",
        amount: 12000.0,
        dueDate: DateTime.now().add(const Duration(days: 7)),
        status: FeeStatus.pending,
        category: "Tuition",
        lateFee: 0.0,
        lateFeeStatus: "None",
      ),
      Fee(
        id: "fee_2",
        studentId: widget.student.id,
        name: "Q2 Transport & Bus Charges",
        amount: 2500.0,
        dueDate: DateTime.now().subtract(const Duration(days: 3)),
        status: FeeStatus.overdue,
        category: "Transport",
        lateFee: 250.0,
        lateFeeStatus: "Active",
      ),
      Fee(
        id: "fee_3",
        studentId: widget.student.id,
        name: "Term 1 Tuition Fee",
        amount: 30500.0,
        dueDate: DateTime.now().subtract(const Duration(days: 45)),
        status: FeeStatus.paid,
        category: "Tuition",
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Fee Particulars",
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 16),
                child: Text(
                  "Billing records for ${widget.student.name}",
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? const Color(0xFF94A3B8) : AppColors.textSecondary,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _fees.length,
                  itemBuilder: (context, index) {
                    final fee = _fees[index];
                    return _buildFeeCard(context, fee, isDark);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeeCard(BuildContext context, Fee fee, bool isDark) {
    final theme = Theme.of(context);
    final isOverdue = fee.status == FeeStatus.overdue;
    final isPaid = fee.status == FeeStatus.paid;
    
    Color statusColor;
    Color statusBgColor;
    if (isPaid) {
      statusColor = AppColors.success;
      statusBgColor = AppColors.success.withOpacity(0.1);
    } else if (isOverdue) {
      statusColor = AppColors.error;
      statusBgColor = AppColors.error.withOpacity(0.1);
    } else {
      statusColor = AppColors.warning;
      statusBgColor = AppColors.warning.withOpacity(0.1);
    }

    final formattedDate = "${fee.dueDate.day} ${_getMonth(fee.dueDate.month)} ${fee.dueDate.year}";

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row with Category and Status Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getCategoryIcon(fee.category),
                        color: AppColors.primary,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      fee.category.toUpperCase(),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                        color: isDark ? const Color(0xFF94A3B8) : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusBgColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    fee.statusText.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Fee Name
            Text(
              fee.name,
              style: theme.textTheme.titleMedium?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // Due Date & Late Fee Indicators
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 14,
                  color: isDark ? const Color(0xFF64748B) : AppColors.textSecondary,
                ),
                const SizedBox(width: 6),
                Text(
                  "Due by $formattedDate",
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? const Color(0xFF64748B) : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            
            if (fee.lateFee > 0) ...[
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 14,
                    color: AppColors.error,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "Late Fee Applied: ₹${fee.lateFee.toStringAsFixed(0)} (${fee.lateFeeStatus})",
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.error,
                    ),
                  ),
                ],
              ),
            ],
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Divider(color: AppColors.border, height: 1),
            ),

            // Amount and Action row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "TOTAL AMOUNT",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                        color: isDark ? const Color(0xFF64748B) : AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "₹${fee.netAmount.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                if (!isPaid)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentScreen(student: widget.student),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Pay Now"),
                        SizedBox(width: 6),
                        Icon(Icons.arrow_forward, size: 14),
                      ],
                    ),
                  )
                else
                  OutlinedButton(
                    onPressed: () {
                      // Already paid - navigate to profile history or view receipt mockup
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Receipt available in profile history"),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check, size: 14, color: AppColors.success),
                        SizedBox(width: 6),
                        Text("View Receipt"),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'tuition':
        return Icons.menu_book;
      case 'transport':
        return Icons.directions_bus;
      case 'exam':
        return Icons.assessment;
      default:
        return Icons.category;
    }
  }

  String _getMonth(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    if (month >= 1 && month <= 12) return months[month - 1];
    return '';
  }
}
