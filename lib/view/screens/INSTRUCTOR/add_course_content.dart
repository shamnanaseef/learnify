import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learneasy/controller/cloudinary_controller.dart';
import 'package:learneasy/controller/course_content_controller.dart';
import 'package:learneasy/utils/constants/colors.dart';

class CourseContentPage extends ConsumerStatefulWidget {
  final String courseId;
  const CourseContentPage({super.key, required this.courseId});

  @override
  ConsumerState<CourseContentPage> createState() => _CourseContentPageState();
}

class _CourseContentPageState extends ConsumerState<CourseContentPage> {
  final _sectionTitleController = TextEditingController();
  final _sectionOrderController = TextEditingController();

  final _videoTitleController = TextEditingController();
  final _videoOrderController = TextEditingController();
  final _videoDurationController = TextEditingController();

  String? selectedSectionId;

  Future<void> _addSection() async {
    final title = _sectionTitleController.text.trim();
    final order = int.tryParse(_sectionOrderController.text.trim()) ?? 0;

    if (title.isEmpty) return;

    await ref
        .read(courseContentControllerProvider)
        .addSection(widget.courseId, title, order);

    _sectionTitleController.clear();
    _sectionOrderController.clear();
  }

  Future<void> _addVideoToSection(String sectionId) async {
    final title = _videoTitleController.text.trim();
    final order = int.tryParse(_videoOrderController.text.trim()) ?? 0;
    final duration = _videoDurationController.text.trim();

    final result = await FilePicker.platform.pickFiles(type: FileType.video);
    if (result == null || result.files.single.path == null) return;

    File file = File(result.files.single.path!);

    // Step 1: Upload video to Cloudinary using your controller
    final uploadController = ref.read(videoUploadControllerProvider);
    await uploadController.uploadVideo(file);

    // Step 2: Get URL from videoUrlProvider
    final videoUrl = ref.read(videoUrlProvider);
    if (videoUrl == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Video upload failed")));
      return;
    }

    // Step 3: Save metadata to Firestore
    await ref
        .read(courseContentControllerProvider)
        .addVideoToSection(
          courseId: widget.courseId,
          sectionId: sectionId,
          title: title,
          order: order,
          videoUrl: videoUrl,
          duration: duration,
        );

    // Clear inputs and video URL
    _videoTitleController.clear();
    _videoOrderController.clear();
    _videoDurationController.clear();
    ref.read(videoUrlProvider.notifier).state = null;

    Navigator.pop(context);
  }

  void _showAddVideoDialog(String sectionId) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Add Video'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _videoTitleController,
                  decoration: const InputDecoration(labelText: 'Video Title'),
                ),
                TextField(
                  controller: _videoOrderController,
                  decoration: const InputDecoration(labelText: 'Order'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _videoDurationController,
                  decoration: const InputDecoration(
                    labelText: 'Duration (e.g., 3:45)',
                  ),
                ),
              ],
            ),

            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  _addVideoToSection(sectionId);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('✅ Content uploaded!')),
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text('Upload & Save'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sectionsAsync = ref.watch(courseSectionsProvider(widget.courseId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses',style: TextStyle(color: Colors.white),),
        backgroundColor: AppColors.buttonColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            const Text(
              "Add New Section",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _sectionTitleController,
              decoration: const InputDecoration(labelText: 'Section Title'),
            ),
            TextField(
              controller: _sectionOrderController,
              decoration: const InputDecoration(labelText: 'Order'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10,),
            SizedBox(
             // width: MediaQuery.of(context).size.width * 0.50,
              height: MediaQuery.of(context).size.height*0.05,
              child: ElevatedButton(
                onPressed: _addSection,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonColor
                ),
                child: const Text("Add Section",style: TextStyle(color: Colors.white),),
              ),
            ),
            const Divider(),
            const Text(
              "Sections & Videos",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            sectionsAsync.when(
              data:
                  (sections) => ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: sections.length,

                    itemBuilder: (context, index) {
                      final section = sections[index];
                      return ExpansionTile(
                        title: Text(section.title),
                        subtitle: Text("Order: ${section.order}"),
                        children: [
                          ...section.videos.map(
                            (video) => ListTile(
                              leading: const Icon(Icons.play_circle),
                              title: Text(video.title),
                              subtitle: Text("Duration: ${video.duration}"),
                            ),
                          ),
                          TextButton.icon(
                            icon:  Icon(Icons.add,color: AppColors.buttonColor,),
                            label:  Text("Add Video",style: TextStyle(color: AppColors.buttonColor),),
                            onPressed: () => _showAddVideoDialog(section.id),
                          ),
                        ],
                      );
                    },
                  ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text("Error: $e"),
            ),
          ],
        ),
      ),
    );
  }
}
