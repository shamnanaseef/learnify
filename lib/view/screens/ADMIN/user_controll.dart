import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learneasy/controller/admin_user_controller.dart';
import 'package:learneasy/utils/constants/colors.dart';

class UserControll extends ConsumerWidget {
  const UserControll({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(allUsersProvider);
    final selectedRole = ref.watch(userTypeFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management',style: TextStyle(color: Colors.white),),
        backgroundColor: AppColors.buttonColor,
      ),
      body: Column(
        children: [
          // Dropdown filter
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
               decoration: BoxDecoration(
    color: AppColors.buttonColor, // 👈 background of the dropdown button itself
    border: Border.all(color: Colors.grey),
    borderRadius: BorderRadius.circular(8),
  ),
              child: DropdownButton<String?>(
                iconSize: 40,
                dropdownColor: AppColors.buttonColor,
                iconEnabledColor: AppColors.iconColor,
                isExpanded: true,
                style: TextStyle(color: Colors.white,fontSize: 24),
                icon: Icon(Icons.arrow_drop_down, color: Colors.blue),
                
                value: selectedRole,
                hint: Text('Filter by Role'),
                items: [
                  DropdownMenuItem(value: null, child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('All',),
                  )),
                  DropdownMenuItem(value: 'Student', child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Student'),
                  )),
                  DropdownMenuItem(value: 'Instructor', child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Instructor'),
                  )),
                 
                ],
                onChanged: (value) {
                  ref.read(userTypeFilterProvider.notifier).state = value;
                },
              ),
            ),
          ),
          Expanded(
            child: usersAsync.when(
              data: (users) {
                if (users.isEmpty) return Center(child: Text('No users found'));
                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return ListTile(
                      title: Text(user.name),
                      subtitle: Text(user.email),
                      trailing: Text(user.userType),
                      leading: Icon(Icons.person,color: AppColors.iconColor,),
                    );
                  },
                );
              },
              loading: () => Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }
}


