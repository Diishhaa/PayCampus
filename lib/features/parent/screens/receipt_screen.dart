import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/widgets/receipt_widget.dart';
import '../../../models/student.dart';
import 'child_selection_screen.dart';

class ReceiptScreen extends StatelessWidget {
  final Student student;
  final String transactionId;
  final String feeName;
  final double amount;
  final DateTime date;
  final String paymentMethod;

  const ReceiptScreen({
    super.key,
    required this.student,
    required this.transactionId,
    required this.feeName,
    required this.amount,
    required this.date,
    required this.paymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9), // darker background to contrast with white ticket receipt
      appBar: AppBar(
        title: const Text("Transaction E-Receipt", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const ChildSelectionScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
            child: Column(
              children: [
                // Render our premium perforated receipt widget
                ReceiptWidget(
                  transactionId: transactionId,
                  studentName: student.name,
                  rollNo: student.rollNo,
                  grade: student.grade,
                  feeName: feeName,
                  amount: amount,
                  date: date,
                  paymentMethod: paymentMethod,
                  status: "Verified",
                ),
                
                const SizedBox(height: 32),

                // Floating Action row
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          // Mock share action
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Row(
                                children: [
                                  Icon(Icons.share, color: Colors.white),
                                  SizedBox(width: 12),
                                  Text("Generating PDF Share sheet..."),
                                ],
                              ),
                              backgroundColor: AppColors.primary,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.share_outlined, size: 18),
                            SizedBox(width: 8),
                            Text("Share PDF"),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Mock download action
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Row(
                                children: [
                                  Icon(Icons.download_done, color: Colors.white),
                                  SizedBox(width: 12),
                                  Text("Receipt downloaded successfully!"),
                                ],
                              ),
                              backgroundColor: AppColors.success,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.file_download_outlined, size: 18),
                            SizedBox(width: 8),
                            Text("Download"),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                TextButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const ChildSelectionScreen()),
                      (route) => false,
                    );
                  },
                  child: const Text("Return to Dashboard"),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
