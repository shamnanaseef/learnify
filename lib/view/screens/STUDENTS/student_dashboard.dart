import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learneasy/controller/cart_controller.dart';
import 'package:learneasy/utils/constants/colors.dart';
import 'package:learneasy/view/screens/STUDENTS/student_cartpage.dart';
import 'package:learneasy/view/screens/STUDENTS/student_coursepage.dart';
import 'package:learneasy/view/screens/STUDENTS/student_homepage.dart';
import 'package:learneasy/view/screens/STUDENTS/student_profile.dart';


class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  @override
 int _currentIndex = 0;

  final List<Widget> _screens = const [
    StudentHomepage(),
    StudentCoursepage(),
    StudentCartpage(),
    StudentSearchbar(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0), // space from edges
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24), // 🎯 rounded corners
          child: Consumer(
            builder: (context, ref, _) {
    final cartCount = ref.watch(cartCountProvider);
    return BottomNavigationBar(
              backgroundColor: AppColors.buttonColor,
              currentIndex: _currentIndex,
              selectedItemColor: const Color(0xFFFFAB91),
              unselectedItemColor: Colors.white70,
              onTap: (index) => setState(() => _currentIndex = index),
              type: BottomNavigationBarType.fixed,
              items: [
                const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                const BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'My Courses'),
                BottomNavigationBarItem(icon: cartCount.when(
            data: (count) =>Badge.count(
              count: count,
              child: Icon(Icons.shopping_cart),
            ),
            loading: () => Icon(Icons.shopping_cart),
            error: (e, _) => Icon(Icons.error),
          ), label: 'Cart'),
                const BottomNavigationBarItem(icon: Icon(Icons.person,), label: 'Profile'),
              ],
            );
            }
          ),
        ),
      ),
    );
}
}