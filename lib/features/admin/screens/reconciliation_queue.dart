import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../models/reconciliation.dart';
import '../../../core/services/mock_database.dart';
import '../../../core/widgets/empty_state.dart';

class ReconciliationQueueScreen extends StatefulWidget {
  const ReconciliationQueueScreen({super.key});

  @override
  State<ReconciliationQueueScreen> createState() => _ReconciliationQueueScreenState();
}

class _ReconciliationQueueScreenState extends State<ReconciliationQueueScreen> {
  List<ReconciliationItem> get _queue => MockDatabase().reconciliationQueue;
  ReconciliationItem? _selectedItem;

  void _processAction(String itemId, String action) {
    try {
      final originalItem = _queue.firstWhere((item) => item.id == itemId);
      String newStatus = originalItem.status;
      if (action == 'Approve') {
        newStatus = 'Verified';
      } else if (action == 'Reject') {
        newStatus = 'Rejected';
      } else if (action == 'Request Proof') {
        newStatus = 'Requested Proof';
      }

      MockDatabase().auditReconciliationItem(itemId, action);

      setState(() {
        _selectedItem = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Audit updated: Item marked as $newStatus"),
          backgroundColor: action == 'Approve' ? AppColors.success : AppColors.error,
        ),
      );
    } catch (_) {
      // item not found or already deleted
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: MockDatabase(),
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Reconciliation Queue",
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
                          description: "Excellent work! All submitted parent transaction receipts have been verified and reconciled.",
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
                            
                            // Mock receipt image card
                            Container(
                              height: 180,
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.receipt_long_rounded, size: 48, color: isDark ? const Color(0xFF475569) : AppColors.textMuted),
                                    const SizedBox(height: 8),
                                    Text(
                                      _selectedItem!.imageUrl,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: isDark ? const Color(0xFF94A3B8) : AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            
                            const Text(
                              "EXTRACTED DATA VS LEDGER EXPECTATIONS",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            
                            _buildExtractedRow(
                              "Payment Method", 
                              _selectedItem!.paymentMethod, 
                              isDark, 
                              matched: true
                            ),
                            _buildExtractedRow(
                              "Amount Transacted", 
                              "₹${_selectedItem!.amountExtracted.toStringAsFixed(0)}", 
                              isDark, 
                              matched: _selectedItem!.amountExtracted == _selectedItem!.amountExpected
                            ),
                            _buildExtractedRow(
                              "Amount Expected", 
                              "₹${_selectedItem!.amountExpected.toStringAsFixed(0)}", 
                              isDark, 
                              matched: _selectedItem!.amountExtracted == _selectedItem!.amountExpected
                            ),
                            _buildExtractedRow(
                              "Extracted UTR Code", 
                              _selectedItem!.utrExtracted, 
                              isDark, 
                              matched: _selectedItem!.utrExtracted.isNotEmpty
                            ),
                            _buildExtractedRow(
                              "Scan Match Rate", 
                              "${(_selectedItem!.confidenceScore * 100).toStringAsFixed(0)}%", 
                              isDark, 
                              matched: _selectedItem!.confidenceScore >= 0.85
                            ),
                            const SizedBox(height: 32),
                            
                            // Audit Actions Row
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: ElevatedButton(
                                    onPressed: () => _processAction(_selectedItem!.id, 'Approve'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.success,
                                    ),
                                    child: const Text("Approve & Post"),
                                  ),
                                ),
                                const SizedBox(width: 12),
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
      },
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
        "${(score * 100).toStringAsFixed(0)}% Match",
        style: TextStyle(
          color: fg,
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
    );
  }
}
