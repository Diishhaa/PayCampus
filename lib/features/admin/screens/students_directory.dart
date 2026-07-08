import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/widgets/glass_bar.dart';
import '../../../models/student.dart';
import 'student_profile.dart';

class StudentsDirectoryScreen extends StatefulWidget {
  const StudentsDirectoryScreen({super.key});

  @override
  State<StudentsDirectoryScreen> createState() => _StudentsDirectoryScreenState();
}

class _StudentsDirectoryScreenState extends State<StudentsDirectoryScreen> {
  final _searchController = TextEditingController();
  String _selectedClassFilter = 'All Classes';

  // Mock list of all school students
  final List<Student> _allStudents = [
    const Student(
      id: "stud_1",
      name: "Rahul Sharma",
      rollNo: "GIS/2026/084",
      grade: "Grade 8-A",
      schoolName: "Greenwood International School",
      avatarUrl: "https://api.dicebear.com/7.x/adventurer/svg?seed=Rahul",
      pendingAmount: 14500.0,
      totalAmount: 45000.0,
    ),
    const Student(
      id: "stud_2",
      name: "Sneha Sharma",
      rollNo: "GIS/2026/112",
      grade: "Grade 5-B",
      schoolName: "Greenwood International School",
      avatarUrl: "https://api.dicebear.com/7.x/adventurer/svg?seed=Sneha",
      pendingAmount: 4200.0,
      totalAmount: 38000.0,
    ),
    const Student(
      id: "stud_3",
      name: "Karan Gupta",
      rollNo: "GIS/2026/012",
      grade: "Grade 10-A",
      schoolName: "Greenwood International School",
      avatarUrl: "https://api.dicebear.com/7.x/adventurer/svg?seed=Karan",
      pendingAmount: 22000.0,
      totalAmount: 52000.0,
    ),
    const Student(
      id: "stud_4",
      name: "Ananya Iyer",
      rollNo: "GIS/2026/204",
      grade: "Grade 8-A",
      schoolName: "Greenwood International School",
      avatarUrl: "https://api.dicebear.com/7.x/adventurer/svg?seed=Ananya",
      pendingAmount: 0.0,
      totalAmount: 45000.0,
    ),
  ];

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
              GlassSearchBar(
                hintText: "Search name or admission number...",
                controller: _searchController,
                onChanged: (_) {
                  setState(() {});
                },
              ),
              const SizedBox(height: 16),
              
              // Class Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: classFilters.map((className) {
                    final isSelected = _selectedClassFilter == className;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: FilterChip(
                        selected: isSelected,
                        label: Text(className),
                        onSelected: (selected) {
                          setState(() {
                            _selectedClassFilter = className;
                          });
                        },
                        selectedColor: AppColors.primary.withOpacity(0.12),
                        checkmarkColor: AppColors.primary,
                        labelStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? AppColors.primary : (isDark ? Colors.white70 : AppColors.textSecondary),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
              
              // Count Row
              Text(
                "Showing ${_filteredStudents.length} Students",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isDark ? const Color(0xFF64748B) : AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 12),

              // Student List representation
              Expanded(
                child: _filteredStudents.isEmpty
                    ? const Center(child: Text("No students match the criteria"))
                    : ListView.builder(
                        itemCount: _filteredStudents.length,
                        itemBuilder: (context, index) {
                          final student = _filteredStudents[index];
                          final progressText = "${(student.paymentProgress * 100).toStringAsFixed(0)}% paid";
                          final isPaid = student.pendingAmount == 0.0;
                          
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StudentProfileScreen(student: student),
                                  ),
                                );
                              },
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              leading: CircleAvatar(
                                backgroundColor: AppColors.primary.withOpacity(0.08),
                                radius: 24,
                                child: Text(
                                  student.name[0],
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                                ),
                              ),
                              title: Text(
                                student.name,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text("${student.grade} • Roll ${student.rollNo}", style: const TextStyle(fontSize: 12)),
                                  const SizedBox(height: 6),
                                  // Simple progress bar
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(4),
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
  }
}
