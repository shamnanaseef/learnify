// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:learneasy/controller/course_controller.dart';
// import 'package:learneasy/view/screens/INSTRUCTOR/add_course.dart';

// class MyCoursesPage extends ConsumerWidget {
//   const MyCoursesPage({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final coursesAsync = ref.watch(instructorCoursesProvider);

//     return Scaffold(
//       appBar: AppBar(title: const Text("My Courses")),
//       body: coursesAsync.when(
//         loading: () => const Center(child: CircularProgressIndicator()),
//         error: (e, _) => Center(child: Text("Error: $e")),
//         data: (courses) {
//           if (courses.isEmpty) {
//             return const Center(child: Text('No courses found'));
//           }
//           return ListView.builder(
//             itemCount: courses.length,
//             itemBuilder: (context, index) {
//               final course = courses[index];
//               return ListTile(
//                 title: Text(course.title),
//                 subtitle: Text('₹${course.price} - ${course.category}'),
//                 trailing: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.edit, color: Colors.orange),
//                       onPressed: () {
//                         // Navigator.push(
//                         //   context,
//                         //   MaterialPageRoute(
//                         //     builder: (_) => AddCoursePage(existingCourse: course),
//                         //   ),
//                         // );
//                       },
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.delete, color: Colors.red),
//                       onPressed: () async {
//                         // await ref.read(courseControllerProvider).deleteCourse(course.id);
//                         // ref.invalidate(instructorCoursesProvider);
//                         // ScaffoldMessenger.of(context).showSnackBar(
//                         //   const SnackBar(content: Text('Course deleted')),
//                         // );
//                       },
//                     ),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => const AddCoursePage()),
//         ),
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
