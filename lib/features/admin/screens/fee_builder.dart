import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class FeeBuilderScreen extends StatefulWidget {
  const FeeBuilderScreen({super.key});

  @override
  State<FeeBuilderScreen> createState() => _FeeBuilderScreenState();
}

class _FeeBuilderScreenState extends State<FeeBuilderScreen> {
  final _nameController = TextEditingController(text: "Term 3 tuition fee");
  final _amountController = TextEditingController(text: "12500");
  final _graceDaysController = TextEditingController(text: "5");
  final _penaltyController = TextEditingController(text: "500");

  String _frequency = 'Termly';
  String _targetGrade = 'Grade 8-A';
  bool _applyLateFee = true;
  bool _allowWaivers = true;

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _graceDaysController.dispose();
    _penaltyController.dispose();
    super.dispose();
  }

  void _publishFee() {
    if (_nameController.text.isEmpty || _amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill out the fee name and amount"),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm Publication"),
          content: Text(
              "You are about to publish '${_nameController.text}' of amount ₹${_amountController.text} to all students in $_targetGrade. This action will notify parents immediately via SMS and email. Proceed?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Fee structure '${_nameController.text}' published successfully!"),
                    backgroundColor: AppColors.success,
                  ),
                );
                // Clear fields
                setState(() {
                  _nameController.clear();
                  _amountController.clear();
                });
              },
              child: const Text("Publish Now"),
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
        title: Text(
          "Dynamic Fee Builder",
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final useColumn = constraints.maxWidth < 600;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (!useColumn)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 6,
                          child: _buildFormFields(theme),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 5,
                          child: _buildPreviewSection(theme, isDark),
                        ),
                      ],
                    )
                  else ...[
                    _buildFormFields(theme),
                    const SizedBox(height: 24),
                    _buildPreviewSection(theme, isDark),
                  ],
                  const SizedBox(height: 24),
                  _buildRulesSection(theme, isDark),
                  const SizedBox(height: 32),
                  _buildPublishButton(),
                  const SizedBox(height: 32),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFormFields(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Fee Particulars",
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _nameController,
          onChanged: (_) => setState(() {}),
          decoration: const InputDecoration(
            labelText: "Fee Particular Title",
            hintText: "e.g. Annual Tuition Fee, Term 2 Lab charges",
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _amountController,
          onChanged: (_) => setState(() {}),
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: "Amount (INR)",
            hintText: "e.g. 15000",
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _frequency,
                decoration: const InputDecoration(labelText: "Frequency"),
                items: ['One-Time', 'Monthly', 'Termly', 'Annual']
                    .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    _frequency = val!;
                  });
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _targetGrade,
                decoration: const InputDecoration(labelText: "Target Audience"),
                items: ['Grade 8-A', 'Grade 5-B', 'Grade 10-A', 'All Classes']
                    .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    _targetGrade = val!;
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPreviewSection(ThemeData theme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Live Invoice Preview",
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _buildLivePreviewCard(isDark),
      ],
    );
  }

  Widget _buildRulesSection(ThemeData theme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Late Fee & Waiver Rules",
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isDark ? const Color(0xFF334155) : AppColors.border),
          ),
          child: Column(
            children: [
              SwitchListTile(
                title: const Text("Apply Late Fee Rule", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                subtitle: const Text("Attach penalty charges to outstanding bills post due date",
                    style: TextStyle(fontSize: 12)),
                value: _applyLateFee,
                activeColor: AppColors.primary,
                onChanged: (val) {
                  setState(() {
                    _applyLateFee = val;
                  });
                },
              ),
              if (_applyLateFee)
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _graceDaysController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: "Grace Period (Days)", hintText: "e.g. 5"),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: _penaltyController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: "Penalty Amount (₹)", hintText: "e.g. 500"),
                        ),
                      ),
                    ],
                  ),
                ),
              const Divider(height: 1, color: AppColors.border),
              SwitchListTile(
                title: const Text("Allow Waiver Rules", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                subtitle: const Text("Permit scholarships, subsidies, and manual discounts",
                    style: TextStyle(fontSize: 12)),
                value: _allowWaivers,
                activeColor: AppColors.primary,
                onChanged: (val) {
                  setState(() {
                    _allowWaivers = val;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPublishButton() {
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: _publishFee,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.publish),
            SizedBox(width: 8),
            Text("Publish Fee to Class"),
          ],
        ),
      ),
    );
  }

  Widget _buildLivePreviewCard(bool isDark) {
    final title = _nameController.text.isEmpty ? "New Fee Particular" : _nameController.text;
    final amount = _amountController.text.isEmpty ? "0.00" : _amountController.text;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  _frequency.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.primary, letterSpacing: 0.5),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _targetGrade,
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.textSecondary, letterSpacing: 0.5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined, size: 12, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  "Due in 15 days",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Divider(color: AppColors.border, height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  "Invoice Total",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "₹$amount",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary),
              ),
            ],
          ),
          if (_applyLateFee) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text(
                    "Late Penalty",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 10, color: AppColors.error),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "₹${_penaltyController.text}",
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.error),
                ),
              ],
            ),
          ]
        ],
      ),
    );
  }
}
