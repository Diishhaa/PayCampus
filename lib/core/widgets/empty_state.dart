import 'package:flutter/material.dart';
import '../constants/colors.dart';

class PremiumEmptyState extends StatelessWidget {
  final String title;
  final String description;
  final String? actionLabel;
  final VoidCallback? onAction;
  final IconData? icon;

  const PremiumEmptyState({
    super.key,
    required this.title,
    required this.description,
    this.actionLabel,
    this.onAction,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Elegant vector-style custom drawn icon container
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                shape: BoxShape.circle,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Custom drawn circular line decoration
                  CustomPaint(
                    size: const Size(100, 100),
                    painter: _EmptyStateGraphicPainter(isDark: isDark),
                  ),
                  Icon(
                    icon ?? Icons.inbox_outlined,
                    size: 40,
                    color: isDark ? const Color(0xFF64748B) : AppColors.textSecondary,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.2,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isDark ? const Color(0xFF64748B) : AppColors.textSecondary,
                    height: 1.5,
                  ),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 24),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: onAction,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(actionLabel!),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _EmptyStateGraphicPainter extends CustomPainter {
  final bool isDark;
  _EmptyStateGraphicPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isDark ? const Color(0xFF334155).withOpacity(0.4) : const Color(0xFFCBD5E1).withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Draw an elegant dashed outer ring
    final center = Offset(size.width / 2, size.height / 2);
    const radius = 40.0;

    // Draw rotating orbit line
    canvas.drawCircle(center, radius, paint);

    // Draw small satellite dots
    final paintDot = Paint()
      ..color = AppColors.primary.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(center.dx + radius * 0.707, center.dy - radius * 0.707), 3, paintDot);

    final paintDot2 = Paint()
      ..color = AppColors.accent.withOpacity(0.4)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(center.dx - radius * 0.707, center.dy + radius * 0.707), 4, paintDot2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
