
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learneasy/controller/auth_controller.dart';
import 'package:learneasy/utils/constants/colors.dart';
import 'package:learneasy/utils/constants/images.dart';
import 'package:learneasy/utils/validator/validator.dart';
import 'package:learneasy/view/screens/authentication/login_page.dart';


class SignupPage extends ConsumerStatefulWidget {
   SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();

  final userController = TextEditingController();

  final passController = TextEditingController();

  final cPassController = TextEditingController();

  String userType = 'Student';

  @override
  Widget build(BuildContext context) {
    
    final authController = ref.read(authServiceProvider);

    return Scaffold(

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
                      "Create an Account",
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
                   
                    controller: userController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person,color:AppColors.authColor),
                      labelText: "User Name",
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
                   
                    controller: emailController, 
                    validator: (value) => AppValidator.validateEmail(value),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email,color: AppColors.authColor,),
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
                   DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'User Type',
                    labelStyle: TextStyle(color: AppColors.authColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  value: userType,
                  items: ['Student', 'Instructor','Admin']
                      .map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      userType = value!;
                    });
                  },
                ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                   
                    controller: passController, 
                    validator: (value) => AppValidator.validatePassword(value),
                    obscureText: true,
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
                  TextFormField(
                   
                    controller: cPassController, 
                    
                    validator:(value) => AppValidator.confirmPassValidate(value, passController.text),
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock,color: AppColors.authColor,),
                      labelText: "Confirm Password",
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
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () async{
                          await authController.signUp(userController.text, emailController.text, userType, passController.text);

                          if (formKey.currentState!.validate() ) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>LoginPage()));
                            emailController.clear();
                          }
                        },
                        child: Text(
                          "Sign Up",
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "Already have an account?",
                      ),
                      TextButton(onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                      }, child: Text("Login")),
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