import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/course_model.dart';
import '../services/course_service.dart';

final courseServiceProvider = Provider((ref) => CourseService());

final courseControllerProvider = Provider((ref) {
  final service = ref.read(courseServiceProvider);
  return CourseController(service);
});


// get course by instructor

final instructorCoursesProvider = FutureProvider<List<Course>>((ref) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return [];
  return ref.read(courseServiceProvider).getCoursesByInstructor(user.uid);
});

// all course fetch

final allCoursesProvider = StreamProvider<List<Course>>((ref) {
  return FirebaseFirestore.instance
      .collection('courses')
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) => Course.fromjson(doc)).toList();
  });
});



class CourseController {
  final CourseService service;
  CourseController(this.service);

  Future<void> createCourse(Course course) => service.addCourse(course);
  Future<List<Course>> getCourses(String instructorId) => service.getCoursesByInstructor(instructorId);
  Future<void> updateCourse(Course course) => service.updateCourse(course);
  Future<void> deleteCourse(String id) => service.deleteCourse(id);
}
