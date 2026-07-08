import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../models/student.dart';
import 'upload_proof.dart';

class PaymentScreen extends StatefulWidget {
  final Student student;

  const PaymentScreen({super.key, required this.student});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedMethod = 'UPI';

  final List<Map<String, dynamic>> _methods = [
    {
      'id': 'UPI',
      'title': 'UPI (PhonePe, GPay, Paytm)',
      'subtitle': 'Instant verification via AI scanning',
      'icon': Icons.qr_code_scanner_rounded,
    },
    {
      'id': 'Bank Transfer',
      'title': 'IMPS / NEFT / RTGS',
      'subtitle': 'Transfer directly to school account',
      'icon': Icons.account_balance_rounded,
    },
    {
      'id': 'Cheque',
      'title': 'Cheque / DD Payment',
      'subtitle': 'Submit physical cheque to school office',
      'icon': Icons.money_rounded,
    },
    {
      'id': 'Cash',
      'title': 'Cash Payment',
      'subtitle': 'Pay at the school accounts desk',
      'icon': Icons.payments_rounded,
    },
  ];

  void _handlePayNow() {
    if (_selectedMethod == 'UPI') {
      _showUpiSheet();
    } else {
      // Simulate confirmation for offline modes
      _showOfflineDetails();
    }
  }

  void _showUpiSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Bottom sheet drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "Pay via UPI",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Complete the payment using any UPI application, then upload the screenshot for AI verification.",
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? const Color(0xFF94A3B8) : AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              
              // Billing Info Box
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F172A) : AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Payable Amount",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "₹${widget.student.pendingAmount.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Deep link trigger buttons simulating modern SDK integrations
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // Simulating phonepe deep link trigger
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Launching PhonePe...")),
                        );
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.bolt, color: Colors.purple, size: 18),
                          SizedBox(width: 8),
                          Text("PhonePe"),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Launching Google Pay...")),
                        );
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_task, color: Colors.blue, size: 18),
                          SizedBox(width: 8),
                          Text("GPay"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // close sheet
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UploadProofScreen(student: widget.student),
                    ),
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.upload_file_rounded),
                    SizedBox(width: 8),
                    Text("Upload Transaction Screenshot"),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showOfflineDetails() {
    showDialog(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          title: Text("Offline Method: $_selectedMethod"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Please complete the payment and deposit details at the administrative wing.",
                style: TextStyle(color: isDark ? Colors.white70 : AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              const Text(
                "Account Holder: Greenwood School Accounts\nBank: HDFC Bank\nIFSC: HDFC0002049\nAcc No: 50200049283921",
                style: TextStyle(fontFamily: 'Courier', fontSize: 13),
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
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UploadProofScreen(student: widget.student),
                  ),
                );
              },
              child: const Text("Upload Challan/Slip"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Payment Method", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 4.0, bottom: 20),
                child: Text(
                  "Choose a payment option to complete the transaction.",
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? const Color(0xFF94A3B8) : AppColors.textSecondary,
                  ),
                ),
              ),
              
              // Methods list
              Expanded(
                child: ListView.builder(
                  itemCount: _methods.length,
                  itemBuilder: (context, index) {
                    final method = _methods[index];
                    final isSelected = _selectedMethod == method['id'];
                    
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _selectedMethod = method['id'];
                          });
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E293B) : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected 
                                ? AppColors.primary 
                                : (isDark ? const Color(0xFF334155) : AppColors.border),
                              width: isSelected ? 2 : 1.5,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: isSelected 
                                    ? AppColors.primary.withOpacity(0.1) 
                                    : (isDark ? const Color(0xFF0F172A) : AppColors.background),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  method['icon'],
                                  color: isSelected ? AppColors.primary : AppColors.textSecondary,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      method['title'],
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: isDark ? Colors.white : AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      method['subtitle'],
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isDark ? const Color(0xFF94A3B8) : AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Radio<String>(
                                value: method['id'],
                                groupValue: _selectedMethod,
                                activeColor: AppColors.primary,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedMethod = value!;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              // Proceed button
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 8),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _handlePayNow,
                    child: Text("Proceed with $_selectedMethod"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
