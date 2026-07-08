import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  String _selectedClass = 'All Classes';
  String _selectedFeeType = 'All Fees';
  String _selectedFormat = 'PDF';
  bool _isDownloading = false;
  double _downloadProgress = 0.0;

  void _triggerDownload() async {
    setState(() {
      _isDownloading = true;
      _downloadProgress = 0.0;
    });

    // Simulate progress increments
    for (int i = 1; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 150));
      if (!mounted) return;
      setState(() {
        _downloadProgress = i / 10.0;
      });
    }

    if (!mounted) return;
    setState(() {
      _isDownloading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Report exported successfully as $_selectedFormat!"),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Export Statements", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Generate custom financial statements, audit reports, and defaulters schedules. Select your filters below to export files.",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDark ? const Color(0xFF94A3B8) : AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              
              // Class Filter Dropdown
              DropdownButtonFormField<String>(
                value: _selectedClass,
                decoration: const InputDecoration(labelText: "Select Class/Grade"),
                items: ['All Classes', 'Grade 8-A', 'Grade 5-B', 'Grade 10-A']
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedClass = val!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Fee Type Dropdown
              DropdownButtonFormField<String>(
                value: _selectedFeeType,
                decoration: const InputDecoration(labelText: "Fee Category"),
                items: ['All Fees', 'Tuition Fee', 'Transport Fee', 'Exam Fee', 'Hostel Fee']
                    .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedFeeType = val!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Format selector Row
              Text(
                "EXPORT FORMAT",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  color: isDark ? const Color(0xFF64748B) : AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _buildFormatRadio('PDF', 'Portable Document Format'),
                  const SizedBox(width: 16),
                  _buildFormatRadio('CSV', 'Comma Separated Values (Excel)'),
                ],
              ),
              
              const Spacer(),

              // Download simulated progress bar
              if (_isDownloading) ...[
                Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: _downloadProgress,
                        minHeight: 6,
                        backgroundColor: AppColors.border,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Compiling ledger dataset... ${(_downloadProgress * 100).toStringAsFixed(0)}%",
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],

              // Export Button
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _isDownloading ? null : _triggerDownload,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.download),
                      SizedBox(width: 8),
                      Text("Generate Statement"),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormatRadio(String format, String desc) {
    final isSelected = _selectedFormat == format;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedFormat = format;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primary : (isDark ? const Color(0xFF334155) : AppColors.border),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(format, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Radio<String>(
                    value: format,
                    groupValue: _selectedFormat,
                    activeColor: AppColors.primary,
                    onChanged: (val) {
                      setState(() {
                        _selectedFormat = val!;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                desc,
                style: TextStyle(
                  fontSize: 10,
                  color: isDark ? const Color(0xFF94A3B8) : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
