import 'package:firebase_auth/firebase_auth.dart';

class ErrorHandler {
  static String handleFirebaseAuthError(dynamic error) {
    String errorMessage = "An unexpected error occurred";

    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'email-already-in-use':
          errorMessage = "this email is already registered.";
          break;
        case 'Wrong-password':
          errorMessage = "Incorrect password. Try again";
          break;
        case 'user-not-found':
          errorMessage = "Password is too weak.Use a stronger password";
          break;
        default:
          errorMessage = error.message ?? "Authentication failed";
      }
    }
    return errorMessage;
  }
}