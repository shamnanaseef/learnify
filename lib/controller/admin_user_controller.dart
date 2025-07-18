import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learneasy/model/auth_model.dart';

final userTypeFilterProvider = StateProvider<String?>((ref) => null); // null = all

final allUsersProvider = StreamProvider((ref) {
  final filter = ref.watch(userTypeFilterProvider);
  Query usersQuery = FirebaseFirestore.instance.collection('users');

  if (filter != null && filter.isNotEmpty) {
    usersQuery = usersQuery.where('userType', isEqualTo: filter);
  }

  return usersQuery.snapshots().map((snapshot) {
    return snapshot.docs
      .map((doc) => UserModel.fromjson(doc.data()! as Map<String, dynamic>))
      .toList();
  });
});
