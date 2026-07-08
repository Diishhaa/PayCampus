import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../models/student.dart';

class NotificationsScreen extends StatelessWidget {
  final Student student;

  const NotificationsScreen({super.key, required this.student});

  // Mock Notification timeline list
  static final List<Map<String, dynamic>> _mockNotifications = [
    {
      'title': 'Payment Verified',
      'description': 'Term 1 Tuition Fee payment of ₹30,500 has been verified by the school office.',
      'time': '2 hours ago',
      'type': 'verified',
      'icon': Icons.check_circle,
      'color': AppColors.success,
    },
    {
      'title': 'Fee Due Reminder',
      'description': 'Term 2 Tuition Fee (₹12,000) is due in 7 days on 15 Jul 2026.',
      'time': '1 day ago',
      'type': 'due_reminder',
      'icon': Icons.alarm,
      'color': AppColors.primary,
    },
    {
      'title': 'Late Fee Warning',
      'description': 'Bus fee for Q2 is past due. A late fee penalty of ₹250 has been active.',
      'time': '3 days ago',
      'type': 'warning',
      'icon': Icons.warning_amber_rounded,
      'color': AppColors.error,
    },
    {
      'title': 'E-Receipt Generated',
      'description': 'Official receipt REC-2026-9481 for Quarterly Exam Fee is now available for download.',
      'time': '12 days ago',
      'type': 'receipt_ready',
      'icon': Icons.receipt,
      'color': AppColors.success,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Timeline Alerts",
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
                padding: const EdgeInsets.only(left: 4.0, bottom: 16.0),
                child: Text(
                  "Activity history for ${student.name}",
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? const Color(0xFF94A3B8) : AppColors.textSecondary,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _mockNotifications.length,
                  itemBuilder: (context, index) {
                    final item = _mockNotifications[index];
                    final isLast = index == _mockNotifications.length - 1;
                    return _buildTimelineItem(context, item, isLast, isDark);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineItem(BuildContext context, Map<String, dynamic> item, bool isLast, bool isDark) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline indicator line and dot
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                // Node dot
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: item['color'].withOpacity(0.12),
                    shape: BoxShape.circle,
                    border: Border.all(color: item['color'], width: 2),
                  ),
                  child: Icon(
                    item['icon'],
                    size: 16,
                    color: item['color'],
                  ),
                ),
                // Connector line
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: isDark ? const Color(0xFF334155) : AppColors.border,
                    ),
                  ),
              ],
            ),
          ),
          
          // Card content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? const Color(0xFF334155) : AppColors.border,
                    width: 1,
                  ),
                  boxShadow: isDark ? [] : AppColors.softShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item['title'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          item['time'],
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? const Color(0xFF64748B) : AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item['description'],
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? const Color(0xFF94A3B8) : AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
