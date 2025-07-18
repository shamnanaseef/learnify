 import 'package:flutter/material.dart';
import 'package:learneasy/utils/constants/colors.dart';
import 'package:learneasy/view/screens/ADMIN/admin_homepage.dart';
import 'package:learneasy/view/screens/ADMIN/course_controll.dart';
import 'package:learneasy/view/screens/ADMIN/settings.dart';
import 'package:learneasy/view/screens/ADMIN/user_controll.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboard();
}

class _AdminDashboard extends State<AdminDashboard> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    AdminHomepage(),
  const UserControll(),
   const CourseControl(),
   const Settings()
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
              BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Users'),
              BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Courses'),
              BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Analytics'),
            ],
          ),
        ),
      ),
    );
}
}