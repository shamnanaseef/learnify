import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:learneasy/model/course_section_model.dart';
import 'package:learneasy/model/section_content.dart';
import 'package:learneasy/services/cloudinary_service.dart';

class CourseContentService {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CloudinaryService _cloudinaryService;

  CourseContentService(this._cloudinaryService);


  // upload vedios
  Future<String?> uploadVideoToCloudinary(File file) {
    return _cloudinaryService.uploadVideo(file);
  }



 // add sections
  Future<void> addSection(String courseId, String title, int order) async {
    await _firestore.collection('courses').doc(courseId).collection('sections').add({
      'title': title,
      'order': order,
    });
  }


  
  // add vedios to sections

  Future<void> addVideoToSection({
    required String courseId,
    required String sectionId,
    required String title,
    required int order,
    required String videoUrl,
    required String duration,
  }) async {
    await _firestore
        .collection('courses')
        .doc(courseId)
        .collection('sections')
        .doc(sectionId)
        .collection('videos')
        .add({
      'title': title,
      'order': order,
      'videoUrl': videoUrl,
      'duration': duration,
    });
  }


  // get course sections
  
  Stream<List<SectionModel>> getCourseSections(String courseId) {
    return _firestore
        .collection('courses')
        .doc(courseId)
        .collection('sections')
        .orderBy('order')
        .snapshots()
        .asyncMap((sectionSnapshot) async {
      List<SectionModel> sections = [];

      for (var doc in sectionSnapshot.docs) {
        final sectionId = doc.id;
        final sectionData = doc.data();
        final videoSnap = await _firestore
            .collection('courses')
            .doc(courseId)
            .collection('sections')
            .doc(sectionId)
            .collection('videos')
            .orderBy('order')
            .get();

        final videos = videoSnap.docs
            .map((v) => VideoModel.fromMap(v.data(), v.id))
            .toList();

        sections.add(
          SectionModel(
            id: sectionId,
            title: sectionData['title'],
            order: sectionData['order'],
            videos: videos,
          ),
        );
      }

      return sections;
    });
  }
}