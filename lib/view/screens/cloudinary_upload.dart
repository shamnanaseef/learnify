import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learneasy/controller/cloudinary_controller.dart';


class CloudinaryUploadPage extends ConsumerStatefulWidget {
  const CloudinaryUploadPage({super.key});

  @override
  ConsumerState<CloudinaryUploadPage> createState() => _CloudinaryUploadPageState();
}

class _CloudinaryUploadPageState extends ConsumerState<CloudinaryUploadPage> {
  File? _videoFile;
  bool isUploading = false;

  Future<void> pickAndUploadVideo() async {
    final picked = await FilePicker.platform.pickFiles(type: FileType.video);
    if (picked == null || picked.files.single.path == null) return;

    setState(() {
      _videoFile = File(picked.files.single.path!);
      isUploading = true;
    });

    await ref.read(videoUploadControllerProvider).uploadVideo(_videoFile!);

    setState(() => isUploading = false);
  }

  @override
  Widget build(BuildContext context) {
    
    final videoUrl = ref.watch(videoUrlProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Upload Course Video')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: isUploading ? null : pickAndUploadVideo,
                icon: const Icon(Icons.upload_file),
                label: const Text("Pick & Upload Video"),
              ),
              const SizedBox(height: 20),
              if (isUploading) const CircularProgressIndicator(),
              if (videoUrl != null) ...[
                const Text('✅ Video Uploaded!'),
                SelectableText(videoUrl, textAlign: TextAlign.center),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
