import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../models/student.dart';
import '../../../core/services/mock_database.dart';
import 'student_profile.dart';

class StudentsDirectoryScreen extends StatefulWidget {
  const StudentsDirectoryScreen({super.key});

  @override
  State<StudentsDirectoryScreen> createState() => _StudentsDirectoryScreenState();
}

class _StudentsDirectoryScreenState extends State<StudentsDirectoryScreen> {
  final _searchController = TextEditingController();
  String _selectedClassFilter = 'All Classes';

  List<Student> get _allStudents => MockDatabase().students;

  List<Student> get _filteredStudents {
    return _allStudents.where((student) {
      final matchesSearch = student.name.toLowerCase().contains(_searchController.text.toLowerCase()) ||
          student.rollNo.toLowerCase().contains(_searchController.text.toLowerCase());
      final matchesClass = _selectedClassFilter == 'All Classes' || student.grade == _selectedClassFilter;
      return matchesSearch && matchesClass;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final classFilters = ['All Classes', 'Grade 8-A', 'Grade 5-B', 'Grade 10-A'];

    return AnimatedBuilder(
      animation: MockDatabase(),
      builder: (context, _) {
        final students = _filteredStudents;
        
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Student Directory",
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Glassmorphic Search Bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark ? const Color(0xFF334155) : AppColors.border,
                      ),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (val) {
                        setState(() {});
                      },
                      decoration: const InputDecoration(
                        hintText: "Search student by name or roll number...",
                        prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        filled: false,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Horizontal Filter Tags
                  SizedBox(
                    height: 36,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: classFilters.length,
                      itemBuilder: (context, index) {
                        final filter = classFilters[index];
                        final isSelected = _selectedClassFilter == filter;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _selectedClassFilter = filter;
                              });
                            },
                            borderRadius: BorderRadius.circular(30),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected 
                                    ? AppColors.primary 
                                    : (isDark ? const Color(0xFF1E293B) : Colors.white),
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: isSelected 
                                      ? AppColors.primary 
                                      : (isDark ? const Color(0xFF334155) : AppColors.border),
                                ),
                              ),
                              child: Text(
                                filter,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? Colors.white : AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Students List
                  Expanded(
                    child: students.isEmpty
                        ? const Center(
                            child: Text(
                              "No students found matching filters",
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                          )
                        : ListView.builder(
                            itemCount: students.length,
                            itemBuilder: (context, index) {
                              final student = students[index];
                              final isPaid = student.pendingAmount == 0;
                              final progressText = "${(student.paymentProgress * 100).toStringAsFixed(0)}% paid";

                              return Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(
                                    color: isDark ? const Color(0xFF334155) : AppColors.border,
                                    width: 1,
                                  ),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(12),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => StudentProfileScreen(student: student),
                                      ),
                                    );
                                  },
                                  leading: CircleAvatar(
                                    radius: 20,
                                    backgroundColor: AppColors.primary.withOpacity(0.08),
                                    child: Text(
                                      student.name[0],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    student.name,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 4),
                                      Text("${student.grade} • Roll ${student.rollNo}"),
                                      const SizedBox(height: 8),
                                      // Progress Bar
                                      Row(
                                        children: [
                                          Expanded(
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(2),
                                              child: SizedBox(
                                                height: 4,
                                                child: LinearProgressIndicator(
                                                  value: student.paymentProgress,
                                                  minHeight: 4,
                                                  backgroundColor: isDark ? const Color(0xFF334155) : AppColors.border,
                                                  valueColor: AlwaysStoppedAnimation<Color>(
                                                    isPaid ? AppColors.success : AppColors.primary,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            progressText,
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              color: isPaid ? AppColors.success : AppColors.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        isPaid ? "₹0" : "₹${student.pendingAmount.toStringAsFixed(0)}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: isPaid ? AppColors.success : AppColors.warning,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        isPaid ? "Settled" : "Due",
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: isPaid ? AppColors.success : AppColors.warning,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
