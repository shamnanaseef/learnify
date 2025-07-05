import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/course_model.dart';

class CourseService {
  final _db = FirebaseFirestore.instance;


  // Add course
  Future<void> addCourse(Course course) async {
    await _db.collection('courses').add(course.tojson());
  }


  // Get course by instructor
  Future<List<Course>> getCoursesByInstructor(String instructorId) async {
  final snapshot = await _db .collection('courses')
      .where('instructorId', isEqualTo: instructorId)
      .get();

  return snapshot.docs.map((doc) => Course.fromjson(doc)).toList();
   }

  // update course
  Future<void> updateCourse(Course course) async {
    await _db.collection('courses').doc(course.id).update(course.tojson());
  }
  
  // delete course
  Future<void> deleteCourse(String id) async {
    await _db.collection('courses').doc(id).delete();
  }

}