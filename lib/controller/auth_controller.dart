

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learneasy/model/auth_model.dart';
import 'package:learneasy/services/auth_services.dart';
import 'package:learneasy/view/screens/ADMIN/admin_homepage.dart';
import 'package:learneasy/view/screens/INSTRUCTOR/instrucor_homepage.dart';
import 'package:learneasy/view/screens/INSTRUCTOR/instructor_dashboard.dart';
import 'package:learneasy/view/screens/STUDENTS/student_dashboard.dart';
import 'package:learneasy/view/screens/STUDENTS/student_homepage.dart';

UserModel? user;
final FirebaseFirestore db = FirebaseFirestore.instance;


// providers

final authServiceProvider = Provider<AuthServices>((ref){
  return AuthServices();
});

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges();
});

final authControllerProvider = StateNotifierProvider<AuthController, AsyncValue<User?>>(
  (ref) => AuthController(ref),
);


final userProfileProvider = FutureProvider<UserModel?>((ref) async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return null;
  return await AuthServices().getUserById(uid); 
});






// controller class

class AuthController extends StateNotifier<AsyncValue<User?>> {
  final Ref ref;

  AuthController(this.ref) : super(const AsyncValue.data(null));

  
  // log in

  Future<void> login(String email, String password, BuildContext context) async {

    state = const AsyncValue.loading();
    try {
      // final user = await ref.read(authProvider).logIn(email, password);
      // state = AsyncValue.data(user);
    final user = await ref.read(authServiceProvider).logIn(email, password);
    if (user != null) {
      // Fetch userType from Firestore
      final doc = await db.collection('users').doc(user.uid).get();
      final userType = doc.data()?['userType'] ?? 'student';

      // Navigate based on userType
      if (context.mounted) {
        if (userType == 'Student') {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const StudentDashboard()));
        } else if (userType == 'Instructor') {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const InstructorDashboard()));
        } else if (userType == 'Admin') {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AdminHomepage()));
        }
      }
    }
    }
    catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  // logout

  void logout() async {
    await ref.read(authServiceProvider).logOut();
    state = const AsyncValue.data(null);
  }

  
}