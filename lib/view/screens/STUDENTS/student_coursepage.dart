

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learneasy/model/course_model.dart';
import 'package:learneasy/utils/constants/purchase_course.dart';
import 'package:learneasy/view/screens/STUDENTS/purchased_course_details.dart';

class StudentCoursepage extends StatelessWidget {
  const StudentCoursepage({super.key});

  Future<Course?> fetchCourseById(String courseId) async {
    final doc =
        await FirebaseFirestore.instance
            .collection('courses')
            .doc(courseId)
            .get();

    if (!doc.exists) return null;

    return Course.fromjson(doc);
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(body: Center(child: Text("Please login")));
    }

    final purchasedIds = getUserPurchasedCourseIds(user.uid);

    return Scaffold(
      appBar: AppBar(title: const Text("My Courses"), centerTitle: true),
      body:
          purchasedIds.isEmpty
              ? const Center(child: Text("No courses purchased."))
              : ListView.builder(
                itemCount: purchasedIds.length,
                itemBuilder: (context, index) {
                  final courseId = purchasedIds[index];

                  return FutureBuilder<Course?>(
                    future: fetchCourseById(courseId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      if (!snapshot.hasData || snapshot.data == null) {
                        return const ListTile(title: Text("Course not found."));
                      }

                      final course = snapshot.data!;
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        elevation: 4,
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              course.image!,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(course.title),
                          subtitle: Text(course.discription),

                          onTap: () {
                            // Navigate to course detail page
                            Navigator.push(context, MaterialPageRoute(builder: (context) => PurchasedCourseDetails(course: course)));
                          },
                        ),
                      );
                    },
                  );
                },
              ),
    );
  }
}
