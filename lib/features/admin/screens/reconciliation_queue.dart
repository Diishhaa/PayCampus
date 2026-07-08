import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../models/reconciliation.dart';
import '../../../core/widgets/empty_state.dart';

class ReconciliationQueueScreen extends StatefulWidget {
  const ReconciliationQueueScreen({super.key});

  @override
  State<ReconciliationQueueScreen> createState() => _ReconciliationQueueScreenState();
}

class _ReconciliationQueueScreenState extends State<ReconciliationQueueScreen> {
  late List<ReconciliationItem> _queue;
  ReconciliationItem? _selectedItem;

  @override
  void initState() {
    super.initState();
    _queue = [
      ReconciliationItem(
        id: "recon_01",
        studentName: "Rahul Sharma",
        grade: "Grade 8-A",
        feeName: "Term 2 Tuition Fee",
        amountExtracted: 12000.0,
        amountExpected: 12000.0,
        utrExtracted: "UTR829402948293",
        dateExtracted: DateTime.now().subtract(const Duration(minutes: 42)),
        paymentMethod: "UPI / PhonePe",
        confidenceScore: 0.98,
        imageUrl: "screenshot_phonepe_tuition.png",
        status: "Matched",
      ),
      ReconciliationItem(
        id: "recon_02",
        studentName: "Devansh Varma",
        grade: "Grade 11-B",
        feeName: "Hostel Lodging Deposit",
        amountExtracted: 24500.0,
        amountExpected: 25000.0,
        utrExtracted: "TXN9481940182",
        dateExtracted: DateTime.now().subtract(const Duration(hours: 2)),
        paymentMethod: "IMPS Bank Transfer",
        confidenceScore: 0.74,
        imageUrl: "challan_slip_hostel.png",
        status: "Processing",
      ),
      ReconciliationItem(
        id: "recon_03",
        studentName: "Prisha Mehta",
        grade: "Grade 3-C",
        feeName: "Annual Activity Fee",
        amountExtracted: 4800.0,
        amountExpected: 4800.0,
        utrExtracted: "UPI9028420942",
        dateExtracted: DateTime.now().subtract(const Duration(hours: 4)),
        paymentMethod: "Paytm UPI",
        confidenceScore: 0.95,
        imageUrl: "paytm_ss.png",
        status: "Matched",
      ),
    ];
  }

  void _processAction(String itemId, String action) {
    setState(() {
      final index = _queue.indexWhere((item) => item.id == itemId);
      if (index != -1) {
        if (action == 'Approve') {
          _queue[index].status = 'Verified';
        } else if (action == 'Reject') {
          _queue[index].status = 'Rejected';
        } else if (action == 'Request Proof') {
          _queue[index].status = 'Requested Proof';
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Audit updated: Item marked as ${_queue[index].status}"),
            backgroundColor: action == 'Approve' ? AppColors.success : AppColors.error,
          ),
        );
        
        // Remove item from active review queue in list
        _queue.removeAt(index);
        _selectedItem = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "AI Reconciliation Queue",
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left List: Active queue items
            Expanded(
              flex: 5,
              child: _queue.isEmpty
                  ? const PremiumEmptyState(
                      title: "Audit Queue Cleared",
                      description: "Excellent work! All submitted parent transaction receipts have been verified by AI or manually approved.",
                      icon: Icons.done_all,
                    )
                  : ListView.builder(
                      itemCount: _queue.length,
                      itemBuilder: (context, index) {
                        final item = _queue[index];
                        final isSelected = _selectedItem?.id == item.id;
                        
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: isSelected ? AppColors.primary : (isDark ? const Color(0xFF334155) : AppColors.border),
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            onTap: () {
                              setState(() {
                                _selectedItem = item;
                              });
                            },
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  item.studentName,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                _buildConfidenceBadge(item.confidenceScore),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 6),
                                Text("${item.grade} • ${item.feeName}"),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.payment, size: 14, color: AppColors.textSecondary),
                                    const SizedBox(width: 4),
                                    Text("Expected: ₹${item.amountExpected.toStringAsFixed(0)}"),
                                    const SizedBox(width: 12),
                                    const Icon(Icons.psychology, size: 14, color: AppColors.textSecondary),
                                    const SizedBox(width: 4),
                                    Text("Extracted: ₹${item.amountExtracted.toStringAsFixed(0)}"),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            
            // Right Side Detail Panel: Side-by-side Proof image and Extracted fields (if item selected)
            if (_selectedItem != null)
              Expanded(
                flex: 6,
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    border: Border(
                      left: BorderSide(color: isDark ? const Color(0xFF334155) : AppColors.border, width: 1.5),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Audit Verification Panel",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                setState(() {
                                  _selectedItem = null;
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        // Side-by-side Proof Preview Mock
                        Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.receipt_long, size: 48, color: isDark ? Colors.white30 : Colors.black26),
                                const SizedBox(height: 12),
                                Text(
                                  "Screenshot: ${_selectedItem!.imageUrl}",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDark ? const Color(0xFF64748B) : AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  "[Tap to zoom original]",
                                  style: TextStyle(fontSize: 10, color: AppColors.primary, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Extracted parameters listing
                        Text(
                          "AI EXTRACTIONS",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                            color: isDark ? const Color(0xFF64748B) : AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        
                        _buildExtractedRow("Extracted UTR", _selectedItem!.utrExtracted, isDark, matched: true),
                        _buildExtractedRow("Extracted Amount", "₹${_selectedItem!.amountExtracted.toStringAsFixed(0)}", isDark, matched: _selectedItem!.amountExtracted == _selectedItem!.amountExpected),
                        _buildExtractedRow("Payment Channel", _selectedItem!.paymentMethod, isDark, matched: true),
                        _buildExtractedRow("Confidence Score", "${(_selectedItem!.confidenceScore * 100).toStringAsFixed(0)}%", isDark, matched: _selectedItem!.confidenceScore > 0.8),
                        
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Divider(color: AppColors.border, height: 1),
                        ),

                        // Actions Row
                        ElevatedButton(
                          onPressed: () => _processAction(_selectedItem!.id, 'Approve'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.success,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check),
                              SizedBox(width: 8),
                              Text("Approve & Ledgerize"),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => _processAction(_selectedItem!.id, 'Request Proof'),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: AppColors.warning),
                                  foregroundColor: AppColors.warning,
                                ),
                                child: const Text("Request Proof"),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => _processAction(_selectedItem!.id, 'Reject'),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: AppColors.error),
                                  foregroundColor: AppColors.error,
                                ),
                                child: const Text("Reject Proof"),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildExtractedRow(String label, String val, bool isDark, {required bool matched}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: matched ? AppColors.success.withOpacity(0.08) : AppColors.error.withOpacity(0.08),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                Text(
                  val,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: matched ? AppColors.success : AppColors.error,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  matched ? Icons.check_circle_outline : Icons.cancel_outlined,
                  size: 14,
                  color: matched ? AppColors.success : AppColors.error,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfidenceBadge(double score) {
    Color bg;
    Color fg;
    if (score >= 0.90) {
      bg = AppColors.success.withOpacity(0.12);
      fg = AppColors.success;
    } else if (score >= 0.80) {
      bg = AppColors.primary.withOpacity(0.12);
      fg = AppColors.primary;
    } else {
      bg = AppColors.warning.withOpacity(0.12);
      fg = AppColors.warning;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        "${(score * 100).toStringAsFixed(0)}% Conf",
        style: TextStyle(
          color: fg,
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
    );
  }
}
