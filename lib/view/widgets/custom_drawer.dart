import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:learneasy/controller/auth_controller.dart';
import 'package:learneasy/utils/constants/colors.dart';
import 'package:learneasy/view/screens/authentication/login_page.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);
   

    return Drawer(
      shadowColor:Colors.amber ,
      surfaceTintColor: Colors.blue,
      child: profileAsync.when(
        
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (user) {
        // print('👤 Received user: ${user?.tojson()}');     
         if (user == null ) {
    return const Center(child: Text('No profile data found'));
         }

          return Column(
            children: [
              UserAccountsDrawerHeader(
                margin: EdgeInsets.only(bottom: 16),
                accountName: Text(user.name),
                accountEmail: Text(user.email),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person,color: AppColors.iconColor ),
                ),
                decoration: BoxDecoration(
                  color: AppColors.buttonColor
                ),
              ),
              ListTile(
                leading: Icon(Icons.person_outline_sharp,color: AppColors.iconColor),
                title: const Text('Edit Profile'),
                onTap: () async {
                  
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
              ListTile(
                leading: Icon(Icons.settings_outlined,color: AppColors.iconColor),
                title: const Text('Settings'),
                onTap: () async {
                 
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
               ListTile(
                leading: Icon(Icons.payment_rounded,color: AppColors.iconColor),
                title: const Text('Payment'),
                onTap: () async {
                 
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
              ListTile(
                leading: Icon(Icons.logout,color: AppColors.iconColor),
                title: const Text('Logout'),
                onTap: () async {
               // ref.read(authControllerProvider.notifier).logout();
                  await FirebaseAuth.instance.signOut();
                 Navigator.pushReplacement( context,MaterialPageRoute(builder: (_) => LoginPage()),
);
                },
              ),

            ],
          );
        },
      ),
    );
  }
}