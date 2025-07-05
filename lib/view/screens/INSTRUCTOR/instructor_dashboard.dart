 import 'package:flutter/material.dart';
import 'package:learneasy/utils/constants/colors.dart';
import 'package:learneasy/view/screens/INSTRUCTOR/course_list.dart';

import 'package:learneasy/view/screens/INSTRUCTOR/instrucor_homepage.dart';
import 'package:learneasy/view/screens/INSTRUCTOR/instructor_analytic.dart';
import 'package:learneasy/view/screens/INSTRUCTOR/instructor_coursepage.dart';
import 'package:learneasy/view/screens/INSTRUCTOR/instructor_profile.dart';

class InstructorDashboard extends StatefulWidget {
  const InstructorDashboard({super.key});

  @override
  State<InstructorDashboard> createState() => _InstructorDashboard();
}

class _InstructorDashboard extends State<InstructorDashboard> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    InstructorHomepage(),
  InstructorCoursepage(),
   InstructorAnalyticPage(),
    InstructorProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0), // space from edges
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24), // 🎯 rounded corners
          child: BottomNavigationBar(
            backgroundColor: AppColors.buttonColor,
            currentIndex: _currentIndex,
            selectedItemColor: const Color(0xFFFFAB91),
            unselectedItemColor: Colors.white70,
            onTap: (index) => setState(() => _currentIndex = index),
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Courses'),
              BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Analytics'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
            ],
          ),
        ),
      ),
    );
}
}