import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learneasy/services/course_content_service.dart';
import '../services/cloudinary_service.dart';

final cloudinaryServiceProvider = Provider((ref) => CloudinaryService());

final videoUrlProvider = StateProvider<String?>((ref) => null);

final videoUploadControllerProvider = Provider((ref) {
  final service = ref.read(cloudinaryServiceProvider);
  return VideoUploadController(ref, service);
});

// image add
final imageUrlProvider = StateProvider<String?>((ref) => null);

final imageUploadControllerProvider = Provider((ref) {
  final service = ref.read(cloudinaryServiceProvider);
  return ImageUploadController(ref, service);
});


// course content 
final courseContentServiceProvider = Provider((ref) {
  final cloudinaryService = ref.read(cloudinaryServiceProvider);
  return CourseContentService(cloudinaryService);
});

class VideoUploadController {
  final Ref ref;
  final CloudinaryService service;

  VideoUploadController(this.ref, this.service);

  Future<void> uploadVideo(File file) async {
    final url = await service.uploadVideo(file);
    if (url != null) {
      ref.read(videoUrlProvider.notifier).state = url;
    }
  }

  
}

class ImageUploadController {
  final Ref ref;
  final CloudinaryService service;

  ImageUploadController(this.ref, this.service);

  Future<void> uploadImage(File imageFile) async {
    final url = await service.uploadImage(imageFile);
    if (url != null) {
      ref.read(imageUrlProvider.notifier).state = url;
    }
  }
}

