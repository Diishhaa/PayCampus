import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../models/student.dart';
import '../../parent/screens/parent_dashboard.dart';

class StudentOnboardingScreen extends StatefulWidget {
  final String phoneNumber;

  const StudentOnboardingScreen({super.key, required this.phoneNumber});

  @override
  State<StudentOnboardingScreen> createState() => _StudentOnboardingScreenState();
}

class _StudentOnboardingScreenState extends State<StudentOnboardingScreen> {
  final _nameController = TextEditingController();
  final _classController = TextEditingController();
  final _divController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _classController.dispose();
    _divController.dispose();
    super.dispose();
  }

  void _completeOnboarding() {
    if (_nameController.text.isEmpty || _classController.text.isEmpty || _divController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all student details"),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate profile creation with "history" data kept same as the mock students
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });

      final student = Student(
        id: "stud_custom",
        name: _nameController.text,
        rollNo: "GIS/2026/001", // Mock roll no
        grade: "Grade ${_classController.text}-${_divController.text.toUpperCase()}",
        schoolName: "Greenwood International School",
        avatarUrl: "https://api.dicebear.com/7.x/adventurer/svg?seed=${_nameController.text}",
        pendingAmount: 14500.0, // Keeping history data same as mock
        totalAmount: 45000.0,
      );

      // Navigate to Parent Dashboard directly
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => ParentDashboard(student: student)),
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Student Details",
                style: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                "Link your ward's profile to continue",
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 15,
                  color: isDark ? const Color(0xFF94A3B8) : AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 36),

              _buildLabel("STUDENT NAME", theme),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                style: const TextStyle(fontWeight: FontWeight.w600),
                decoration: const InputDecoration(
                  hintText: "Enter full name",
                ),
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel("CLASS", theme),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _classController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                          decoration: const InputDecoration(
                            hintText: "e.g. 8",
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel("DIVISION", theme),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _divController,
                          textCapitalization: TextCapitalization.characters,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                          decoration: const InputDecoration(
                            hintText: "e.g. A",
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _completeOnboarding,
                  child: _isLoading
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text("Create Profile & Continue"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, ThemeData theme) {
    return Text(
      text,
      style: theme.textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 12,
        letterSpacing: 0.5,
      ),
    );
  }
}
