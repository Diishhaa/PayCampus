import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class AdminAnalyticsScreen extends StatelessWidget {
  const AdminAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Revenue Analytics",
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // AI Insights Cards Carousel
              Text(
                "AI Financial Insights",
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildAiInsightsCarousel(context, isDark),
              
              const SizedBox(height: 24),

              // Collection vs Target progress
              _buildTargetProgressCard(isDark),
              const SizedBox(height: 24),

              // Class-wise outstanding ledger table
              Text(
                "Outstanding Receivables by Grade",
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildClassDefaultersTable(isDark),
              
              const SizedBox(height: 24),

              // Payment Method Share
              Text(
                "Payment Method Distribution",
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildPaymentMethodChart(isDark),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAiInsightsCarousel(BuildContext context, bool isDark) {
    final insights = [
      {
        'text': 'Projected collection this month is ₹8.6L. High probability of matching targets.',
        'metric': '₹8.6L',
        'sub': 'Expected Collection',
        'icon': Icons.trending_up,
      },
      {
        'text': 'Grade 8 transport fees are 23% behind target. Recommend firing bulk due alerts.',
        'metric': '23%',
        'sub': 'Transport Deficit',
        'icon': Icons.warning_amber_rounded,
      },
      {
        'text': 'UPI accounts for 76% of all incoming collections, reducing settlement time by 3 days.',
        'metric': '76%',
        'sub': 'UPI Preference',
        'icon': Icons.bolt,
      },
    ];

    return SizedBox(
      height: 130,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: insights.length,
        itemBuilder: (context, index) {
          final ins = insights[index];
          return Container(
            width: 280,
            margin: const EdgeInsets.only(right: 14),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isDark ? const Color(0xFF334155) : AppColors.border),
              boxShadow: isDark ? [] : AppColors.softShadow,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Icon(ins['icon'] as IconData, color: AppColors.primary, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            ins['sub'] as String,
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5, color: AppColors.primary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        ins['text'] as String,
                        style: const TextStyle(fontSize: 12, height: 1.4, fontWeight: FontWeight.w500),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  ins['metric'] as String,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTargetProgressCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? const Color(0xFF334155) : AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("JULY TARGET STATUS", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textSecondary, letterSpacing: 0.5)),
              Text("84% MET", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.success, letterSpacing: 0.5)),
            ],
          ),
          const SizedBox(height: 12),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("₹4.24L Collected", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text("Goal: ₹5.00L", style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: const LinearProgressIndicator(
              value: 0.84,
              minHeight: 8,
              backgroundColor: AppColors.border,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.success),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClassDefaultersTable(bool isDark) {
    final list = [
      {'class': 'Grade 8-A', 'due': '₹2,42,000', 'defaulters': '14 students', 'progress': 0.72},
      {'class': 'Grade 10-A', 'due': '₹1,90,000', 'defaulters': '9 students', 'progress': 0.81},
      {'class': 'Grade 11-B', 'due': '₹1,56,000', 'defaulters': '6 students', 'progress': 0.85},
      {'class': 'Grade 5-B', 'due': '₹48,000', 'defaulters': '3 students', 'progress': 0.94},
    ];

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? const Color(0xFF334155) : AppColors.border),
      ),
      child: Column(
        children: list.map((item) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['class'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 2),
                      Text(item['defaulters'] as String, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: LinearProgressIndicator(
                          value: item['progress'] as double,
                          minHeight: 4,
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                          backgroundColor: isDark ? const Color(0xFF334155) : AppColors.border,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 3,
                  child: Text(
                    item['due'] as String,
                    textAlign: TextAlign.end,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.warning),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPaymentMethodChart(bool isDark) {
    final methods = [
      {'name': 'UPI Transfers', 'share': '76%', 'value': 0.76, 'color': AppColors.primary},
      {'name': 'Net Banking', 'share': '14%', 'value': 0.14, 'color': AppColors.accent},
      {'name': 'Bank Challan/Cheque', 'share': '8%', 'value': 0.08, 'color': AppColors.warning},
      {'name': 'Cash', 'share': '2%', 'value': 0.02, 'color': AppColors.error},
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? const Color(0xFF334155) : AppColors.border),
      ),
      child: Column(
        children: [
          // Single segmented progress bar representing the pie chart share
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              height: 12,
              child: Row(
                children: methods.map((item) {
                  return Expanded(
                    flex: ((item['value'] as double) * 100).toInt(),
                    child: Container(color: item['color'] as Color),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Legend
          Column(
            children: methods.map((item) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    Container(width: 10, height: 10, decoration: BoxDecoration(color: item['color'] as Color, shape: BoxShape.circle)),
                    const SizedBox(width: 8),
                    Text(item['name'] as String, style: const TextStyle(fontSize: 12)),
                    const Spacer(),
                    Text(item['share'] as String, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
