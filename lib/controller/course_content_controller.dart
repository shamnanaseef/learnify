import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learneasy/controller/cloudinary_controller.dart';
import 'package:learneasy/model/course_section_model.dart';
import '../services/course_content_service.dart';

final courseContentControllerProvider = Provider((ref) {
  final service = ref.read(courseContentServiceProvider);
  return CourseContentController(service);
});

final courseSectionsProvider = StreamProvider.family<List<SectionModel>, String>((ref, courseId) {
  final service = ref.read(courseContentServiceProvider);
  return service.getCourseSections(courseId);
});

class CourseContentController {
  final CourseContentService _service;

  CourseContentController(this._service);

  Future<void> addSection(String courseId, String title, int order) {
    return _service.addSection(courseId, title, order);
  }

  Future<void> addVideoToSection({
    required String courseId,
    required String sectionId,
    required String title,
    required int order,
    required String videoUrl,
    required String duration,
  }) {
    return _service.addVideoToSection(
      courseId: courseId,
      sectionId: sectionId,
      title: title,
      order: order,
      videoUrl: videoUrl,
      duration: duration,
    );
  }
}
