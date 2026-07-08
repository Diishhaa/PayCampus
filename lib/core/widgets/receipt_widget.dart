import 'package:flutter/material.dart';
import '../constants/colors.dart';

class ReceiptWidget extends StatelessWidget {
  final String transactionId;
  final String studentName;
  final String rollNo;
  final String grade;
  final String feeName;
  final double amount;
  final DateTime date;
  final String paymentMethod;
  final String status;

  const ReceiptWidget({
    super.key,
    required this.transactionId,
    required this.studentName,
    required this.rollNo,
    required this.grade,
    required this.feeName,
    required this.amount,
    required this.date,
    required this.paymentMethod,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final formattedDate = "${date.day} ${_getMonth(date.month)} ${date.year}";
    final formattedAmount = "₹${amount.toStringAsFixed(2)}";

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Premium Ticket-Style Receipt Card
        ClipPath(
          clipper: PerforatedCardClipper(perforationRadius: 6),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              boxShadow: isDark ? [] : AppColors.cardShadow,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // School Header Mock
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.school,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Greenwood International School",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            "Official e-Receipt",
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? const Color(0xFF64748B) : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Divider(color: AppColors.border, height: 1),
                ),
                
                // Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle, color: AppColors.success, size: 16),
                      SizedBox(width: 6),
                      Text(
                        "PAYMENT VERIFIED",
                        style: TextStyle(
                          color: AppColors.success,
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Amount
                Text(
                  formattedAmount,
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 24),

                // Details Grid
                _buildRow(context, "Student Name", studentName, isDark),
                _buildRow(context, "Roll Number", rollNo, isDark),
                _buildRow(context, "Grade & Section", grade, isDark),
                _buildRow(context, "Fee Category", feeName, isDark),
                _buildRow(context, "Payment Method", paymentMethod, isDark),
                _buildRow(context, "Transaction Date", formattedDate, isDark),
                _buildRow(context, "UTR / Txn ID", transactionId, isDark, isCode: true),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Divider(color: AppColors.border, height: 1),
                ),

                // QR Code Simulation
                Container(
                  width: 130,
                  height: 130,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
                    border: Border.all(color: AppColors.border, width: 1.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: CustomPaint(
                    size: const Size(114, 114),
                    painter: _QrCodePainter(isDark: isDark),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Scan to verify transaction integrity",
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? const Color(0xFF64748B) : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRow(BuildContext context, String label, String value, bool isDark, {bool isCode = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: isDark ? const Color(0xFF94A3B8) : AppColors.textSecondary,
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                fontFamily: isCode ? 'Courier' : null,
                color: isDark ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getMonth(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    if (month >= 1 && month <= 12) return months[month - 1];
    return '';
  }
}

// Perforated edge card clipper
class PerforatedCardClipper extends CustomClipper<Path> {
  final double perforationRadius;

  PerforatedCardClipper({required this.perforationRadius});

  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height);

    double x = 0.0;
    double y = size.height;
    double r = perforationRadius;
    double diameter = 2 * r;
    
    // Perforations at the bottom
    while (x < size.width) {
      path.arcToPoint(
        Offset(x + diameter, y),
        radius: Radius.circular(r),
        clockwise: false,
      );
      x += diameter;
    }

    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// Draw a beautiful abstract geometric matrix representing QR Code
class _QrCodePainter extends CustomPainter {
  final bool isDark;
  _QrCodePainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isDark ? Colors.white : AppColors.secondary
      ..style = PaintingStyle.fill;

    // QR Code anchor boxes (Top-Left, Top-Right, Bottom-Left)
    _drawAnchor(canvas, const Offset(0, 0), 30, paint);
    _drawAnchor(canvas, Offset(size.width - 30, 0), 30, paint);
    _drawAnchor(canvas, Offset(0, size.height - 30), 30, paint);

    // Dynamic tiny dots inside representing encoded bits
    final borderPaint = Paint()
      ..color = isDark ? Colors.white30 : Colors.black12
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), borderPaint);

    final dotPaint = Paint()
      ..color = isDark ? Colors.white.withOpacity(0.8) : AppColors.secondary.withOpacity(0.8)
      ..style = PaintingStyle.fill;

    final positions = [
      const Offset(40, 10), const Offset(50, 10), const Offset(70, 10),
      const Offset(40, 20), const Offset(60, 20), const Offset(70, 20),
      const Offset(10, 40), const Offset(20, 40), const Offset(40, 40), const Offset(50, 40), const Offset(60, 40), const Offset(70, 40), const Offset(90, 40), const Offset(100, 40),
      const Offset(10, 50), const Offset(30, 50), const Offset(50, 50), const Offset(70, 50), const Offset(80, 50), const Offset(100, 50),
      const Offset(40, 60), const Offset(60, 60), const Offset(70, 60), const Offset(90, 60),
      const Offset(0, 70), const Offset(10, 70), const Offset(20, 70), const Offset(40, 70), const Offset(50, 70), const Offset(80, 70), const Offset(100, 70),
      const Offset(40, 80), const Offset(50, 80), const Offset(60, 80), const Offset(80, 80), const Offset(90, 80),
      const Offset(40, 90), const Offset(60, 90), const Offset(70, 90), const Offset(100, 90),
      const Offset(40, 100), const Offset(50, 100), const Offset(80, 100), const Offset(90, 100),
    ];

    for (var pos in positions) {
      canvas.drawRect(Rect.fromLTWH(pos.dx, pos.dy, 6, 6), dotPaint);
    }
  }

  void _drawAnchor(Canvas canvas, Offset offset, double size, Paint paint) {
    // Outer border
    canvas.drawRect(Rect.fromLTWH(offset.dx, offset.dy, size, size), paint);
    
    // Middle white gap
    final innerPaint = Paint()
      ..color = const Color(0x00FFFFFF)
      ..style = PaintingStyle.fill;
    
    // We actually overlay a transparent box or draw negative space
    // Let's use BlendMode.clear or simple white block depending on theme
    final gapPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    canvas.drawRect(
      Rect.fromLTWH(offset.dx + 4, offset.dy + 4, size - 8, size - 8),
      gapPaint,
    );

    // Inner core
    canvas.drawRect(
      Rect.fromLTWH(offset.dx + 8, offset.dy + 8, size - 16, size - 16),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
