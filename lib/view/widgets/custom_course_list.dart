import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learneasy/controller/course_controller.dart';
import 'package:learneasy/view/screens/STUDENTS/course_details.dart';

class CustomCourseList extends ConsumerWidget {


  @override
  Widget build(BuildContext context,WidgetRef ref) {

    final coursesAsync = ref.watch(allCoursesProvider);

    return coursesAsync.when(
        data: (courses) => SizedBox(
      height: 300, // total height of each course card
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CourseDetailPage(course: course,)));
              
            },
            child: Container(
              width: MediaQuery.of(context).size.height * 0.30,
              margin: EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: [BoxShadow(blurRadius: 4, color: Colors.black12)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Half - Image
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.network(
                      course.image!,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
            
                  // Bottom Half - Text Info
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          course.title,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Text(
                          course.instructorId,
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                        SizedBox(height: 6),
                        Text(
                           "₹${course.price.toString()}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ),
     loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text("Error: $error")),
    );
  
  }
}


// final List<Map<String, dynamic>> courses = [
  //   {
  //     'title': 'Flutter Basics',
  //     'price': '₹499',
  //     'instructor': 'John Doe',
  //     'image': 'assets/coursecatogoies/download.jpeg',
  //   },
  //   {
  //     'title': 'React for Beginners',
  //     'price': '₹599',
  //     'instructor': 'Jane Smith',
  //     'image': 'assets/coursecatogoies/download (3).png',
  //   },
  //   {
  //     'title': 'Flutterrrr Basics',
  //     'price': '₹499',
  //     'instructor': 'John Doe',
  //     'image': 'assets/coursecatogoies/6478099.png',
  //   },
  //   {
  //     'title': 'Dart programming',
  //     'price': '₹499',
  //     'instructor': 'John Doe',
  //     'image': 'assets/coursecatogoies/download.png',
  //   },
  //   // Add more courses
  // ];