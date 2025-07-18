import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learneasy/model/course_model.dart';

final courseCategoryFilterProvider = StateProvider<String?>((ref) => null); // null = all



final allCoursesProvider = StreamProvider<List<Course>>((ref) {

  final selectedCategory = ref.watch(courseCategoryFilterProvider);
  Query query = FirebaseFirestore.instance.collection('courses');

  if (selectedCategory != null && selectedCategory.isNotEmpty) {
    query = query.where('category', isEqualTo: selectedCategory);
  }

  return query.snapshots().map((snapshot) => snapshot.docs
      .map((doc) => Course.fromjson(doc))
      .toList());

});
