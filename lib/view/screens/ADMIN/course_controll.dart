import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learneasy/controller/admin_course_controller.dart';
import 'package:learneasy/utils/constants/colors.dart';

class CourseControl extends ConsumerWidget {
  const CourseControl({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coursesAsync = ref.watch(allCoursesProvider);
    final selectedCategory = ref.watch(courseCategoryFilterProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Course Management')),
      body: Column(
        children: [
          // 🔽 Dropdown Filter
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String?>(
              value: selectedCategory,
              hint: Text('Filter by Category'),
              isExpanded: true,
              items: const [
                DropdownMenuItem(value: null, child: Text('All')),
                DropdownMenuItem(value: 'Development', child: Text('Development')),
                DropdownMenuItem(value: 'Design', child: Text('Design')),
                DropdownMenuItem(value: 'Marketing', child: Text('Marketing')),
                DropdownMenuItem(value: 'Business', child: Text('Business')),
              ],
              onChanged: (value) {
                ref.read(courseCategoryFilterProvider.notifier).state = value;
              },
            ),
          ),
          // 📦 Course List
          Expanded(
            child: coursesAsync.when(
              data: (courses) {
                if (courses.isEmpty) return Center(child: Text('No courses found'));
                return ListView.builder(
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    final course = courses[index];
                    return Card(
                      margin: EdgeInsets.all(8),
                      child: ListTile(
                        leading: Image.network(course.image!, width: 50, height: 50, fit: BoxFit.cover),
                        title: Text(course.title),
                        subtitle: Text("Category: ${course.category}}"),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: AppColors.iconColor),
                          onPressed: () {
                            // TODO: delete logic
                          },
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }
}
