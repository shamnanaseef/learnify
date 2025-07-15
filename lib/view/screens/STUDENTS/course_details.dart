import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learneasy/controller/cart_controller.dart';
import 'package:learneasy/controller/course_content_controller.dart';
import 'package:learneasy/model/course_model.dart';
import 'package:learneasy/utils/constants/colors.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
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
        builder:
            (_) => AlertDialog(
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
      appBar: AppBar(
        title: Text(course.title, style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.buttonColor,
      ),
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
                  Text(
                    course.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    course.discription,
                    style: const TextStyle(fontSize: 16),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    "Category: ${course.category}",
                    style: const TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    "₹ ${course.price.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // 🛒 Buy Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Handle payment navigation
                        Razorpay razorpay = Razorpay();
                        var options = {
                          'key': 'rzp_live_ILgsfZCZoFIKMb',
                          'amount': 100,
                          'name': 'Acme Corp.',
                          'description': 'Fine T-Shirt',
                          'retry': {'enabled': true, 'max_count': 1},
                          'send_sms_hash': true,
                          'prefill': {
                            'contact': '8888888888',
                            'email': 'test@razorpay.com',
                          },
                          'external': {
                            'wallets': ['paytm'],
                          },
                        };
                        razorpay.on(
                          Razorpay.EVENT_PAYMENT_ERROR,
                          handlePaymentErrorResponse,
                        );
                        razorpay.on(
                          Razorpay.EVENT_PAYMENT_SUCCESS,
                          handlePaymentSuccessResponse,
                        );
                        razorpay.on(
                          Razorpay.EVENT_EXTERNAL_WALLET,
                          handleExternalWalletSelected,
                        );
                        razorpay.open(options);
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Buy Now",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () async {
                      await ref
                          .read(cartLocalServiceProvider)
                          .addToCart(course.id);
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('Added to cart')));

                      // Optionally refresh the cart items list
                      ref.refresh(localCartItemsProvider);
                    },
                    child: Text('Add to Cart'),
                  ),

                  const SizedBox(height: 30),
                  const Text(
                    "Course Sections",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
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
                            children:
                                section.videos.map((video) {
                                  return ListTile(
                                    leading: Icon(
                                      Icons.play_circle_fill,
                                      color: AppColors.buttonColor,
                                    ),
                                    title: Text(video.title),
                                    subtitle: Text(video.duration),
                                    onTap:
                                        () => _playSectionVideo(video.videoUrl),
                                  );
                                }).toList(),
                          );
                        },
                      );
                    },
                    loading:
                        () => const Padding(
                          padding: EdgeInsets.all(16),
                          child: CircularProgressIndicator(),
                        ),
                    error:
                        (err, _) => Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text('Error: $err'),
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    /*
    * PaymentFailureResponse contains three values:
    * 1. Error Code
    * 2. Error Description
    * 3. Metadata
    * */
    showAlertDialog(
      context,
      "Payment Failed",
      "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}",
    );
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) {
    /*
    * Payment Success Response contains three values:
    * 1. Order ID
    * 2. Payment ID
    * 3. Signature
    * */
    showAlertDialog(
      context,
      "Payment Successful",
      "Payment ID: ${response.paymentId}",
    );
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    showAlertDialog(
      context,
      "External Wallet Selected",
      "${response.walletName}",
    );
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    // set up the buttons
    Widget continueButton = ElevatedButton(
      child: const Text("Continue"),
      onPressed: () {},
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(title: Text(title), content: Text(message));
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
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
