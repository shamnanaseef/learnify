import 'package:flutter/material.dart';
import 'package:learneasy/utils/constants/colors.dart';

import 'package:learneasy/view/widgets/custom_appbar.dart';
import 'package:learneasy/view/widgets/custom_drawer.dart';

class InstructorHomepage extends StatelessWidget {
  const InstructorHomepage({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      drawer: const AppDrawer(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: CustomAppbar(scaffoldKey: scaffoldKey),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Cards
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                _SummaryCard(
                  title: "Courses",
                  value: "5",
                  icon: Icons.menu_book,
                ),
                _SummaryCard(
                  title: "Earnings",
                  value: "₹12,300",
                  icon: Icons.attach_money,
                ),
                _SummaryCard(
                  title: "Students",
                  value: "120",
                  icon: Icons.group,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Recent Courses Section
            const Text(
              "Recent Courses",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Dummy list
            ListView.builder(
              itemCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: Icon(
                      Icons.video_library,
                      color: AppColors.iconColor,
                    ),
                    title: Text("Course ${index + 1}"),
                    subtitle: const Text("20 Lessons • 3.5 hrs"),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: AppColors.iconColor,
                    ),
                    onTap: () {
                      // TODO: Course detail page
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),

      
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Icon(icon, size: 30, color: AppColors.iconColor),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                title,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
