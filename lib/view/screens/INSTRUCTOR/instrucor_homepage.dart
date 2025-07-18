import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learneasy/controller/course_controller.dart';
import 'package:learneasy/utils/constants/colors.dart';

import 'package:learneasy/view/widgets/custom_appbar.dart';
import 'package:learneasy/view/widgets/custom_drawer.dart';
import 'package:learneasy/view/widgets/custom_slider.dart';

class InstructorHomepage extends ConsumerWidget {
  const InstructorHomepage({super.key});

  @override
  Widget build(BuildContext context ,WidgetRef ref) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    
    final coursesAsync = ref.watch(instructorCoursesProvider);

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
            
  CustomSlider(),
              SizedBox(height: 12,),
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
           coursesAsync.when(
              data: (courses) {
                if (courses.isEmpty) {
                  return const Text("No courses yet.");
                }
                return ListView.builder(
                  itemCount: courses.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final course = courses[index];
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        // leading: course.image != null
                        //     ? ClipRRect(
                        //         borderRadius: BorderRadius.circular(8),
                        //         child: Image.network(
                        //           course.image!,
                        //           width: 50,
                        //           height: 50,
                        //           fit: BoxFit.cover,
                        //         ),
                        //       )
                          //  : Icon(Icons.video_library, color: AppColors.iconColor),
                        title: Text(course.title,style: TextStyle(fontWeight: FontWeight.bold),),
                        subtitle: Text("₹${course.price.toString()} - ${course.category}"),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: AppColors.iconColor,
                        ),
                        onTap: () {
                          // TODO: Navigate to course detail page
                        },
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Text('Error: $err'),
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
