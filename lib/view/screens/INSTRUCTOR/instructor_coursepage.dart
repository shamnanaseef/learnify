import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learneasy/controller/course_controller.dart';
import 'package:learneasy/test/add_course_test.dart';
import 'package:learneasy/utils/constants/colors.dart';
import 'package:learneasy/view/screens/INSTRUCTOR/add_course.dart';
import 'package:learneasy/view/screens/INSTRUCTOR/add_course_content.dart';

class InstructorCoursepage extends ConsumerWidget {
  const InstructorCoursepage({super.key});

  @override
  Widget build(BuildContext context , WidgetRef ref) {
    // Example course list
    // final courses = [
    //   {'title': 'Flutter for Beginners', 'lessons': 20, 'duration': '5 hrs'},
    //   {'title': 'Firebase Essentials', 'lessons': 15, 'duration': '3 hrs'},
    //   {'title': 'Advanced Dart', 'lessons': 18, 'duration': '4.5 hrs'},
    // ];

    final coursesAsync = ref.watch(instructorCoursesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses',style: TextStyle(color: Colors.white),),
        backgroundColor: AppColors.buttonColor,
      ),
      body: coursesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
        data: (courses) {
          if (courses.isEmpty) {
            return const Center(child: Text('No courses found'));
          }
          return ListView.builder(
        itemCount: courses.length,
        padding: const EdgeInsets.all(12),
        itemBuilder: (context, index) {
          final course = courses[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading:  Icon(Icons.menu_book_rounded, size: 40, color: AppColors.iconColor),
              title: Text('${course.title!}', style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('₹${course.price} - ${course.category}'),
              trailing: PopupMenuButton<String>(
                  onSelected: (value) async {
                    if (value == 'edit') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddCoursePage(existingCourse: course),
                        ),
                      );
                    } else if (value == 'delete') {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete Course'),
                          content: const Text('Are you sure you want to delete this course?'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                            ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        await ref.read(courseControllerProvider).deleteCourse(course.id);
                        ref.invalidate(instructorCoursesProvider);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Course deleted')),
                        );
                      }
                    }
                    else if (value == 'Add Content') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>CourseContentPage(courseId:course.id),
                        ),
                      );
                  }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'edit', child: Text('Edit')),
                    const PopupMenuItem(value: 'delete', child: Text('Delete')),
                    const PopupMenuItem(value: 'Add Content',child: Text('Add course content'))
                  ],
                ),
              onTap: () {
                // Optional: View course details
              },
            ),
          );
        },
      );
        }),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Navigate to Add Course Page
           Navigator.push(context, MaterialPageRoute(builder: (context) => AddCoursePage()));
        },
        icon: const Icon(Icons.add,color: Colors.white,),
        label: const Text('Add Course',style:TextStyle(color: Colors.white)),
        backgroundColor: AppColors.buttonColor,
      ),
    );
  }
}
