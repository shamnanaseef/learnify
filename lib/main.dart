import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learneasy/firebase_options.dart';
import 'package:learneasy/view/screens/authentication/login_page.dart';
import 'package:learneasy/view/screens/authentication/signup_page.dart';
import 'package:learneasy/view/screens/cloudinary_upload.dart';
import 'package:learneasy/view/screens/homepage.dart';
import 'package:learneasy/view/screens/onboarding.dart';
import 'package:learneasy/view/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,);
  
   runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(color: Colors.white), // 👈 global back icon color
    ),
       
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: LoginPage(),
      
    );
  }
}

