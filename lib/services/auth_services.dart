import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:learneasy/model/auth_model.dart';
import 'package:learneasy/utils/error_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthServices {

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  Stream<User?> authStateChanges() => auth.authStateChanges();

  // create User

  Future<UserModel?>  signUp (String name , String email ,String userType , String password) async {

    try{

      var userCred = await auth.createUserWithEmailAndPassword(email: email, password: password);
      User? appUser = userCred.user;

      if(appUser  != null){
        UserModel newUser = UserModel(uid: appUser.uid, name: name, email: email, userType: userType);
        await db.collection("users").doc(appUser.uid).set(newUser.tojson());

        final prefs =await SharedPreferences.getInstance();
        await prefs.setString("userId", appUser.uid);
        return newUser;
      }
     return null;

    }
    catch(e){
       throw ErrorHandler.handleFirebaseAuthError(e.toString());


    }

  }


  // Log In

  Future<User?> logIn(String email, String password ) async {

     try{

      var userCred = await auth.signInWithEmailAndPassword(email: email, password: password);
      User? appUser = userCred.user;

      if(appUser != null){
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("userId", appUser.uid);
        return appUser;
      }
      return null;

     }
     catch(e){
      throw ErrorHandler.handleFirebaseAuthError(e.toString());
     }


    
  }

  // Log out

  Future<void> logOut() async {
    try{
      await auth.signOut();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove("userId");

    }
    catch(e){
      throw ErrorHandler.handleFirebaseAuthError(e.toString());
    }

  }

  //  Get Current User
  Future<String?> getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("userId");
  }

  // fetch userdata

  Future<UserModel?> fetchUserdata(String uid) async {

    try{
      var userDoc = await db.collection("users").doc(uid).get();
      if(userDoc.exists){
        return UserModel.fromjson(userDoc.data()!);

      }
      else{
        return null;
      }

    }
    catch(e){
      throw ErrorHandler.handleFirebaseAuthError(e.toString());
    }

  }


Future<UserModel?> getUserById(String uid) async {
  final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
  final data = doc.data();
  if (data == null) return null;
  return UserModel.fromjson(data);
}

}