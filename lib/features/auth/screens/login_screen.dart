import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import 'student_onboarding_screen.dart';
import '../../admin/screens/admin_dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  final bool isAdmin;

  const LoginScreen({super.key, required this.isAdmin});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _inputController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _login() {
    final input = _inputController.text.trim();

    if (widget.isAdmin) {
      if (!input.contains('@') || !input.contains('.')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please enter a valid school email address"),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }
    } else {
      if (input.length < 10) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please enter a valid 10-digit mobile number"),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate network latency
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });

      if (widget.isAdmin) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const AdminDashboardScreen()),
          (route) => false,
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StudentOnboardingScreen(phoneNumber: input),
          ),
        );
      }
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
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.isAdmin ? "Admin Login" : "Parent Login",
                style: theme.textTheme.displayMedium,
              ),
              const SizedBox(height: 8),
              Text(
                widget.isAdmin
                    ? "Enter your school email ID to access the dashboard"
                    : "Enter your mobile number to get started",
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 15,
                  color: isDark ? const Color(0xFF94A3B8) : AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 36),
              
              Text(
                widget.isAdmin ? "SCHOOL EMAIL" : "MOBILE NUMBER",
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _inputController,
                keyboardType: widget.isAdmin ? TextInputType.emailAddress : TextInputType.phone,
                maxLength: widget.isAdmin ? null : 10,
                style: const TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.5),
                decoration: InputDecoration(
                  hintText: widget.isAdmin ? "e.g. admin@greenwood.edu" : "Enter 10-digit number",
                  prefixText: widget.isAdmin ? null : "+91 ",
                  prefixStyle: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                  counterText: "",
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  child: _isLoading
                      ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : Text(widget.isAdmin ? "Login to Dashboard" : "Continue to Details"),
                ),
              ),
              if (!widget.isAdmin) ...[
                const SizedBox(height: 24),
                Center(
                  child: Text(
                    "Fast Login: No OTP required for Sandbox",
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? const Color(0xFF64748B) : AppColors.textMuted,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
