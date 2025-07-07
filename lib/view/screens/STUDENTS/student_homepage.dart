import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:learneasy/view/widgets/custom_appbar.dart';
import 'package:learneasy/view/widgets/custom_catogories.dart';
import 'package:learneasy/view/widgets/custom_course_list.dart';
import 'package:learneasy/view/widgets/custom_drawer.dart';

class StudentHomepage extends StatelessWidget {
  const StudentHomepage({super.key});

  @override
  Widget build(BuildContext context) {
     final scaffoldKey = GlobalKey<ScaffoldState>();
      final TextEditingController controller;
    return Scaffold(
      key: scaffoldKey,
      drawer: const AppDrawer(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: CustomAppbar(scaffoldKey: scaffoldKey),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 20,
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search Course',
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Categories",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
                  Text("See All",style: TextStyle(fontSize: 18),)
                ],
              ),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.15,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                ),
                child:CategoryBoxList()
              ),
              SizedBox(height: 10,),
              Text("Popular Courses",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
              CustomCourseList(),
              SizedBox(height: 10,),
              Text("Featured Courses",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
              CustomCourseList(),
        
        
            ],
            
        
            
          ),
        ),
      ),
    );
  }
}