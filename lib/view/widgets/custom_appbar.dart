import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learneasy/controller/auth_controller.dart';
import 'package:learneasy/utils/constants/colors.dart';

class CustomAppbar extends StatelessWidget {
   final GlobalKey<ScaffoldState> scaffoldKey;
  const CustomAppbar({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
     
    return   AppBar(
    backgroundColor: AppColors.buttonColor,
    elevation: 0,
    // shape: const RoundedRectangleBorder(
    //   borderRadius: BorderRadius.vertical(
    //     bottom: Radius.circular(24),
    //   ),
    // ),
    
    automaticallyImplyLeading: false,
    flexibleSpace: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Menu Button
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.white, size: 28),
              onPressed: () {
                // TODO: Open drawer or menu
                 scaffoldKey.currentState?.openDrawer();
               
              },
            ),
            const SizedBox(width: 12),

            // Title Column
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Welcome Back 👋",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Consumer(
                    builder: (context, ref, _) {
                      final userAsync = ref.watch(userProfileProvider);
                       return userAsync.when(
                       data: (user) => Text(user?.name ?? "Instructor",
                         style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                       ),),
                       loading: () => const Text('Loading...'),
                        error: (_, __) => const Text('Error'),
      );
                    },
                  
                  ),
                ],
              ),
            ),

            // Notification Icon
            IconButton(
              icon: const Icon(Icons.notifications_none, color: Colors.white, size: 26),
              onPressed: () {
                // TODO: Navigate to notifications page
              },
            ),
          ],
        ),
      ),
    ),
  );
  }
}