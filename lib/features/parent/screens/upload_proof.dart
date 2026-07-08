import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../models/student.dart';
import 'ocr_verification.dart';

class UploadProofScreen extends StatefulWidget {
  final Student student;

  const UploadProofScreen({super.key, required this.student});

  @override
  State<UploadProofScreen> createState() => _UploadProofScreenState();
}

class _UploadProofScreenState extends State<UploadProofScreen> {
  bool _hasSelectedFile = false;
  String _selectedFileName = '';
  String _selectedFileSize = '';

  void _selectMockFile(String source) {
    setState(() {
      _hasSelectedFile = true;
      _selectedFileName = source == 'camera' ? 'IMG_CAP_7482.jpg' : 'screenshot_phonepe_tuition.png';
      _selectedFileSize = source == 'camera' ? '1.4 MB' : '342 KB';
    });
  }

  void _proceedToVerification() {
    if (!_hasSelectedFile) return;
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OcrVerificationScreen(
          student: widget.student,
          fileName: _selectedFileName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Payment Receipt", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Upload transaction invoice, bank challan slip, or mobile screenshot. Our AI engine will extract information instantly for school auditing.",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDark ? const Color(0xFF94A3B8) : AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              
              // Upload Drag/Drop Box Simulation
              Expanded(
                child: InkWell(
                  onTap: () => _selectMockFile('gallery'),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _hasSelectedFile ? AppColors.primary : (isDark ? const Color(0xFF334155) : AppColors.border),
                        width: 2.0,
                        style: BorderStyle.solid,
                      ),
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (!_hasSelectedFile) ...[
                          Icon(
                            Icons.cloud_upload_outlined,
                            size: 72,
                            color: isDark ? const Color(0xFF64748B) : AppColors.textMuted,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "Tap to browse or drop file here",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Supports JPEG, PNG, or PDF up to 5MB",
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? const Color(0xFF64748B) : AppColors.textMuted,
                            ),
                          ),
                        ] else ...[
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.08),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.image_outlined,
                              size: 48,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            _selectedFileName,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _selectedFileSize,
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark ? const Color(0xFF64748B) : AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _hasSelectedFile = false;
                              });
                            },
                            child: const Text("Remove File", style: TextStyle(color: AppColors.error)),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Camera & Gallery selectors
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _selectMockFile('camera'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt_outlined, size: 18),
                          SizedBox(width: 8),
                          Text("Use Camera"),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _selectMockFile('gallery'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.photo_library_outlined, size: 18),
                          SizedBox(width: 8),
                          Text("From Gallery"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              
              // Proceed button
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _hasSelectedFile ? _proceedToVerification : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _hasSelectedFile ? AppColors.primary : Colors.grey[400],
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Analyze Receipt with AI"),
                      SizedBox(width: 8),
                      Icon(Icons.auto_awesome, size: 18),
                    ],
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
