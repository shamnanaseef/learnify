import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learneasy/controller/course_content_controller.dart';
import 'package:learneasy/model/course_model.dart';
import 'package:learneasy/utils/constants/colors.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';



class CourseDetailPage extends ConsumerStatefulWidget {
  final Course course;
  const CourseDetailPage({super.key, required this.course});

  @override
  ConsumerState<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends ConsumerState<CourseDetailPage> {
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.network(widget.course.contentUrl)
      ..initialize().then((_) {
        setState(() {
          _chewieController = ChewieController(
            videoPlayerController: _videoController,
            autoPlay: false,
            looping: false,
            aspectRatio: _videoController.value.aspectRatio,
          );
        });
      });
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  void _playSectionVideo(String url) {
    final controller = VideoPlayerController.network(url);
    controller.initialize().then((_) {
      final chewie = ChewieController(
        videoPlayerController: controller,
        autoPlay: true,
        looping: false,
      );

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: Chewie(controller: chewie),
          ),
        ),
      ).then((_) {
        chewie.dispose();
        controller.dispose();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final course = widget.course;
    final sectionsAsync = ref.watch(courseSectionsProvider(course.id));
     print("Video JSON: ${json}");

    return Scaffold(
      appBar: AppBar(title: Text(course.title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🎬 Preview Video
            if (_chewieController != null)
              AspectRatio(
                aspectRatio: _videoController.value.aspectRatio,
                child: Chewie(controller: _chewieController!),
              )
            else
              Container(
                height: 200,
                color: Colors.black12,
                child: const Center(child: CircularProgressIndicator()),
              ),

            const SizedBox(height: 20),

            // 📄 Course Details
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(course.title,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),

                  const SizedBox(height: 8),

                  Text(course.discription, style: const TextStyle(fontSize: 16)),

                  const SizedBox(height: 16),

                  Text("Category: ${course.category}",
                      style: const TextStyle(color: Colors.grey)),

                  const SizedBox(height: 12),

                  Text("₹ ${course.price.toStringAsFixed(2)}",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),

                  const SizedBox(height: 30),

                  // 🛒 Buy Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Handle payment navigation
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text("Buy Now", style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ),

                  const SizedBox(height: 30),
                  const Text("Course Sections",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),

                  // 📂 Sections from Firestore
                  sectionsAsync.when(
                    data: (sections) {
                      print("section ${sections.length}");
                     
                      if (sections.isEmpty) {
                        return const Text("No sections available.");
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: sections.length,
                        itemBuilder: (context, index) {
                          final section = sections[index];
                          return ExpansionTile(
                            title: Text(section.title),
                            children: section.videos.map((video) {
                              return ListTile(
                                leading: const Icon(Icons.play_circle_fill, color: Colors.deepPurple),
                                title: Text(video.title),
                                subtitle: Text(video.duration),
                                onTap: () => _playSectionVideo(video.videoUrl),
                              );
                            }).toList(),
                          );
                        },
                      );
                    },
                   loading: () =>
                        const Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator()),
                    error: (err, _) =>
                        Padding(padding: const EdgeInsets.all(16), child: Text('Error: $err')),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



























// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:learneasy/controller/course_content_controller.dart';
// import 'package:learneasy/utils/constants/colors.dart';
// import 'package:video_player/video_player.dart';
// import 'package:chewie/chewie.dart';
// import 'package:learneasy/model/course_model.dart';

// class CourseDetailPage extends StatefulWidget {
//   final Course course;

//   const CourseDetailPage({super.key, required this.course});

//   @override
//   State<CourseDetailPage> createState() => _CourseDetailPageState();
// }

// class _CourseDetailPageState extends State<CourseDetailPage> {
//   late VideoPlayerController _videoController;
//   ChewieController? _chewieController;

//   @override
//   void initState() {
//     super.initState();

//     // Initialize the video player
//     _videoController = VideoPlayerController.network(widget.course.contentUrl)
//       ..initialize().then((_) {
//         setState(() {
//           _chewieController = ChewieController(
//             videoPlayerController: _videoController,
//             autoPlay: false,
//             looping: false,
//             aspectRatio: _videoController.value.aspectRatio,
//           );
//         });
//       });
//   }

//   void _playSectionVideo(String url) {
//     final controller = VideoPlayerController.network(url);
//     controller.initialize().then((_) {
//       final chewie = ChewieController(
//         videoPlayerController: controller,
//         autoPlay: true,
//         looping: false,
//          aspectRatio: controller.value.aspectRatio,
//       );

//       showDialog(
//         context: context,
//         builder:
//             (_) => AlertDialog(
//               contentPadding: EdgeInsets.zero,
//               content: AspectRatio(
//                 aspectRatio: controller.value.aspectRatio,
//                 child: Chewie(controller: chewie),
//               ),
//             ),
//       ).then((_) {
//         chewie.dispose();
//         controller.dispose();
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _videoController.dispose();
//     _chewieController?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final course = widget.course;
//     final Ref ref;
//     final sectionsAsync = ref.watch(courseSectionsProvider(widget.course.id));
//     print('Sections: ${widget.course.sections.length}');

//     return Scaffold(
//       appBar: AppBar(title: Text(course.title)),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // 🎬 Preview Video
//             if (_chewieController != null)
//               AspectRatio(
//                 aspectRatio: _videoController.value.aspectRatio,
//                 child: Chewie(controller: _chewieController!),
//               )
//             else
//               Container(
//                 height: 200,
//                 color: Colors.black12,
//                 child: const Center(child: CircularProgressIndicator()),
//               ),

//             const SizedBox(height: 20),

//             // 📄 Course Details
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     course.title,
//                     style: const TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),

//                   const SizedBox(height: 8),

//                   Text(
//                     course.discription,
//                     style: const TextStyle(fontSize: 16),
//                   ),

//                   const SizedBox(height: 16),

//                   Text(
//                     "Category: ${course.category}",
//                     style: const TextStyle(color: Colors.grey),
//                   ),

//                   const SizedBox(height: 12),

//                   Text(
//                     "₹ ${course.price.toStringAsFixed(2)}",
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.green,
//                     ),
//                   ),

//                   const SizedBox(height: 30),

//                   // 🛒 Buy Button
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         // TODO: Navigate to payment or purchase logic
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppColors.buttonColor,
//                         padding: const EdgeInsets.symmetric(vertical: 16),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       child: const Text(
//                         "Buy Now",
//                         style: TextStyle(fontSize: 16, color: Colors.white),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 24),
//                   const Text(
//                     "Course Sections",
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),

//                   const SizedBox(height: 8),
//                   if (course.sections.isEmpty)
//   const Text("No sections available.")
// else
//                   Column(
//                     children:
//                         course.sections.map((section) {
//                           return ExpansionTile(
//                             title: Text(section!.title),
//                             children:
//                                 section.videos.map((video) {
//                                   return ListTile(
//                                     leading: const Icon(
//                                       Icons.play_circle_fill,
//                                       color: Colors.deepPurple,
//                                     ),
//                                     title: Text(video.title),
//                                     onTap:
//                                         () => _playSectionVideo(
//                                           video.videoUrl,
//                                         ), // use correct key
//                                   );
//                                 }).toList(),
//                           );
//                         }).toList(),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
