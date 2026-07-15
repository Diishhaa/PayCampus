import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../models/student.dart';
import '../../../core/services/mock_database.dart';

class StudentProfileScreen extends StatefulWidget {
  final Student student;

  const StudentProfileScreen({super.key, required this.student});

  @override
  State<StudentProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  final _notesController = TextEditingController(text: "Parent requested waiver for transportation fees due to medical leave. Under review.");
  bool _isEditingNotes = false;

  Student get student => MockDatabase().getStudentById(widget.student.id) ?? widget.student;

  void _sendReminder() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Alert: Custom reminder SMS sent to the parent of ${student.name}."),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: MockDatabase(),
      builder: (context, _) {
        final currentStudent = student;

        return Scaffold(
          appBar: AppBar(
            title: const Text("Student Billing Ledger", style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : AppColors.textPrimary),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Summary Profile Header Card
                    _buildHeaderCard(currentStudent, isDark),
                    const SizedBox(height: 24),

                    // AI insight snippet
                    _buildInsightSnippet(isDark),
                    const SizedBox(height: 24),
                    
                    // Tabs / Sections: Timeline, Waivers, Notes
                    Text(
                      "Billing Timeline",
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    _buildTimelineList(isDark),

                    const SizedBox(height: 24),

                    // Notes Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Administrative Notes",
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isEditingNotes = !_isEditingNotes;
                            });
                          },
                          child: Text(_isEditingNotes ? "Save Notes" : "Edit"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildNotesCard(isDark),
                    
                    const SizedBox(height: 32),
                    
                    // Send Reminder / Action Row
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              // Mock waiver adjustment dialog
                              _showWaiverDialog(context);
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text("Adjust Waivers"),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _sendReminder,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              backgroundColor: AppColors.primary,
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.notifications_active_rounded, size: 16),
                                SizedBox(width: 8),
                                Text("Send Reminder"),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeaderCard(Student student, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? const Color(0xFF334155) : AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.primary.withOpacity(0.08),
                child: Text(
                  student.name[0],
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.name,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${student.grade} • Roll ${student.rollNo}",
                      style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(color: AppColors.border, height: 1),
          ),
          Row(
            children: [
              Expanded(child: _buildMetric("TOTAL ANNUAL", "₹${student.totalAmount.toStringAsFixed(0)}", isDark)),
              Expanded(child: _buildMetric("COLLECTED", "₹${(student.totalAmount - student.pendingAmount).toStringAsFixed(0)}", isDark, color: AppColors.success)),
              Expanded(child: _buildMetric("PENDING", "₹${student.pendingAmount.toStringAsFixed(0)}", isDark, color: student.pendingAmount > 0 ? AppColors.warning : AppColors.success)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(String label, String value, bool isDark, {Color? color}) {
    return Column(
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            color: isDark ? const Color(0xFF64748B) : AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildInsightSnippet(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.12)),
      ),
      child: const Row(
        children: [
          Icon(Icons.auto_awesome, color: AppColors.primary, size: 18),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              "AI Prediction: Parent has high credit confidence. Expected repayment probability is 92%.",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineList(bool isDark) {
    final timeline = [
      {
        'title': 'Term 2 Tuition Fee Particulars',
        'sub': '₹12,000 pending • Due in 7 days',
        'status': 'pending',
        'icon': Icons.radio_button_checked,
        'color': AppColors.warning,
      },
      {
        'title': 'Bus Transport Q2 Charges',
        'sub': '₹2,500 pending • Late fee ₹250 applied (overdue)',
        'status': 'overdue',
        'icon': Icons.warning_amber_rounded,
        'color': AppColors.error,
      },
      {
        'title': 'Term 1 Tuition Fee Settlement',
        'sub': '₹30,500 verified via UPI • UTR829402948293',
        'status': 'paid',
        'icon': Icons.check_circle,
        'color': AppColors.success,
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? const Color(0xFF334155) : AppColors.border),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: timeline.length,
        separatorBuilder: (context, index) => const Divider(height: 1, color: AppColors.border),
        itemBuilder: (context, index) {
          final entry = timeline[index];
          return ListTile(
            leading: Icon(entry['icon'] as IconData, color: entry['color'] as Color),
            title: Text(
              entry['title'] as String,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              entry['sub'] as String,
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNotesCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? const Color(0xFF334155) : AppColors.border),
      ),
      child: _isEditingNotes
          ? TextField(
              controller: _notesController,
              maxLines: 3,
              style: const TextStyle(fontSize: 14),
              decoration: const InputDecoration(
                border: InputBorder.none,
                filled: false,
                contentPadding: EdgeInsets.zero,
              ),
            )
          : Text(
              _notesController.text,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? Colors.white70 : AppColors.textPrimary,
                height: 1.4,
              ),
            ),
    );
  }

  void _showWaiverDialog(BuildContext context) {
    final amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Adjust Fee Waivers"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: amountController,
                decoration: const InputDecoration(
                  labelText: "Waiver Amount (₹)",
                  hintText: "Enter waiver amount",
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  labelText: "Reason for Waiver",
                  hintText: "Medical / Scholarship etc.",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final amount = double.tryParse(amountController.text) ?? 0.0;
                MockDatabase().waiveFeeForStudent(student.id, amount);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Waiver adjustment of ₹${amount.toStringAsFixed(0)} applied successfully!"),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
              child: const Text("Apply Waiver"),
            ),
          ],
        );
      },
    );
  }
}
