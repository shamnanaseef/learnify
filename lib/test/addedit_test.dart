// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:learneasy/controller/cloudinary_controller.dart';
// import 'package:learneasy/controller/course_controller.dart';
// import 'package:learneasy/model/course_model.dart';
// import 'package:learneasy/utils/constants/colors.dart';

// class AddCoursePage extends ConsumerStatefulWidget {
  
//   const AddCoursePage({super.key});

//   @override
//   ConsumerState<AddCoursePage> createState() => _AddCoursePageState();
// }

// class _AddCoursePageState extends ConsumerState<AddCoursePage> {
//   final _formKey = GlobalKey<FormState>();
//   final _title = TextEditingController();
//   final _description = TextEditingController();
//   final _price = TextEditingController();
//   String _category = 'Development';
//   //String _status = 'draft';
//   File? _videoFile;
//   bool _isUploading = false;

//   Future<void> _pickAndUploadVideo() async {
//     final picked = await FilePicker.platform.pickFiles(type: FileType.video);
//     if (picked != null && picked.files.single.path != null) {
//       setState(() {
//         _videoFile = File(picked.files.single.path!);
//         _isUploading = true;
//       });
//       await ref.read(videoUploadControllerProvider).uploadVideo(_videoFile!);
//       setState(() => _isUploading = false);
//     }
//   }

//   Future<void> _submitForm() async {
//     final videoUrl = ref.read(videoUrlProvider);
//     final user = FirebaseAuth.instance.currentUser;
//     if (!_formKey.currentState!.validate() || videoUrl == null || user == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Fill all fields & upload video')),
//       );
//       return;
//     }
//     final course = Course(
//       title: _title.text,
//       discription: _description.text,
//       price: double.tryParse(_price.text) ?? 0.0,
//       category: _category,
     
//       contentUrl: videoUrl,
//       instructorId: user.uid,
//     );
//     await ref.read(courseControllerProvider).createCourse(course);
//     if (context.mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('✅ Course Created!')),
//       );
//       Navigator.pop(context);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final videoUrl = ref.watch(videoUrlProvider);
//     return Scaffold(
//      appBar: AppBar(
//       title: const Text("Upload New Course"),
//       backgroundColor: AppColors.buttonColor,
//       iconTheme: const IconThemeData(color: Colors.white), // styled back icon
//       titleTextStyle: const TextStyle(
//         color: Colors.white,
//         fontSize: 20,
//         fontWeight: FontWeight.bold,
//       ),
//     ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Card(
//           elevation: 4,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//           child: Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                  crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text("Enter Course Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 16),

//                   TextFormField(
//                     controller: _title,
//                     decoration: const InputDecoration(labelText: 'Title',
//                        border: OutlineInputBorder(),),
//                     validator: (v) => v == null || v.isEmpty ? 'Required' : null,
//                   ),

//                   const SizedBox(height: 16),

//                   TextFormField(
//                     controller: _description,
//                     maxLines: 3,
//                     decoration: const InputDecoration(labelText: 'Description',
//                       border: OutlineInputBorder(),),
//                   ),

//                   const SizedBox(height: 16),                 
                  
//                    TextFormField(
//                     controller: _price,
//                     decoration: const InputDecoration(
//                      labelText: 'Price', 
//                      prefixText: '₹ ', 
//                      border: OutlineInputBorder(),),
//                     keyboardType: TextInputType.number,
//                   ),
                     
//                   const SizedBox(height: 16),
                  
//                   DropdownButtonFormField(
//                     value: _category,
//                     items: ['Development', 'Design', 'Marketing']
//                         .map((c) => DropdownMenuItem(value: c, child: Text(c)))
//                         .toList(),
//                     onChanged: (val) => setState(() => _category = val!),
//                     decoration: const InputDecoration(
//                       labelText: 'Category', 
//                       border: OutlineInputBorder(),),
//                   ),

//                   // DropdownButtonFormField(
//                   //   value: _status,
//                   //   items: ['draft', 'published']
//                   //       .map((s) => DropdownMenuItem(value: s, child: Text(s)))
//                   //       .toList(),
//                   //   onChanged: (val) => setState(() => _status = val!),
//                   //   decoration: const InputDecoration(labelText: 'Status'),
//                   // ),

//                   const SizedBox(height: 16),

//                   ElevatedButton.icon(
//                     style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.buttonColor,
//                     padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                   ),
//                     onPressed: _isUploading ? null : _pickAndUploadVideo,
//                     icon:  Icon(Icons.video_library,color: Colors.white,),
//                     label: Text(_videoFile == null ? 'Upload Video' : 'Change Video',style: TextStyle(color: Colors.white),),
//                   ),

//                   if (_isUploading) const CircularProgressIndicator(),
//                   if (videoUrl != null) Text('✅ Video uploaded!'),
//                   const SizedBox(height: 24),
//                   SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.green,
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                     ),
//                     onPressed: _submitForm,
//                     child: const Text("Upload Course", style: TextStyle(fontSize: 16,color: Colors.white)),
//                   ),
//                 ),

//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
