import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learneasy/controller/auth_controller.dart';
import 'package:learneasy/utils/constants/colors.dart';
import 'package:learneasy/utils/constants/images.dart';
import 'package:learneasy/utils/validator/validator.dart';
import 'package:learneasy/view/screens/authentication/signup_page.dart';
import 'package:learneasy/view/screens/homepage.dart';

class LoginPage extends ConsumerStatefulWidget {
   LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();

  final passController = TextEditingController();

  void _login() async {
    final email = emailController.text.trim();
    final password = passController.text.trim();
     await ref.read(authControllerProvider.notifier).login(email, password, context);

  }


  @override
  Widget build(BuildContext context) {
    
      final authState = ref.watch(authControllerProvider);

    return Scaffold( 
      backgroundColor:  const Color(0xFFE4F1F8),
       body:SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(
                    height:120,
                  ),
                  
                  Center(
                  child: Image.asset(EImages.createAccount,height: 60,width: 60,),
        
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Text(
                      "Welcome To Learnify",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppColors.authColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  
                 
                  TextFormField(
                   
                    controller: emailController, 
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person,color: AppColors.authColor,),
                      labelText: "Email",
                      labelStyle: TextStyle(color: AppColors.authColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                   
                    controller: passController, 
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock,color: AppColors.authColor,),
                      labelText: "Password",
                      labelStyle: TextStyle(color: AppColors.authColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                 
         Center(
                    child: SizedBox(
                      height: 50,
                      width: 300,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        
                          
                             onPressed: authState is AsyncLoading ? null 
                             : _login,
              child: const Text("Login"),
            ),
           
                        
                      
                    ),
                  ),
                   if (authState is AsyncError)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(authState.error.toString(), style: const TextStyle(color: Colors.red))),
                        
                        
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "Dont Have An Account?",
                      ),
                      TextButton(onPressed: () {
                        Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>SignupPage()));
                      }, child: Text("Sign Up")),
                    ],
                  ),
        
        
              ],
            )
        
          )
        ),
      )
);
  }
}