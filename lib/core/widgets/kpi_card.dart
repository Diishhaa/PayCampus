import 'package:flutter/material.dart';
import '../constants/colors.dart';

class KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final String? trend;
  final bool isPositive;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final VoidCallback? onTap;

  const KpiCard({
    super.key,
    required this.title,
    required this.value,
    this.trend,
    this.isPositive = true,
    required this.icon,
    this.iconColor = AppColors.primary,
    this.iconBgColor = const Color(0xFFEFF6FF),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16), // Reduced padding from 20 to 16
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
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 11, // Slightly smaller font
                      fontWeight: FontWeight.w600,
                      color: isDark ? const Color(0xFF94A3B8) : AppColors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0F172A) : iconBgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 16, // Reduced icon size
                    color: isDark ? AppColors.primary : iconColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: theme.textTheme.displayMedium?.copyWith(
                fontSize: 22, // Reduced font size
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (trend != null) ...[
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(
                    isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                    size: 12,
                    color: isPositive ? AppColors.success : AppColors.error,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: trend!,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: isPositive ? AppColors.success : AppColors.error,
                            ),
                          ),
                          TextSpan(
                            text: ' vs last mo', // Shortened text
                            style: TextStyle(
                              fontSize: 10,
                              color: isDark ? const Color(0xFF64748B) : AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
