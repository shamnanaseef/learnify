import 'package:flutter/material.dart';

class CategoryBoxList extends StatelessWidget {

  final List<Map<String,String>> categories = [
   {'name':'Development', 'image' : 'assets/coursecatogoies/download (2).png'},
   {'name': 'Marketing' , 'image' : 'assets/coursecatogoies/download (3).png'},
   {'name': 'Designing' , 'image' : 'assets/coursecatogoies/download.png'},
   {'name': 'Software Testing' , 'image' : 'assets/coursecatogoies/download (1).jpeg'},
   {'name': 'Data Science' , 'image' : 'assets/coursecatogoies/download (1).png'},

  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: categories.length,
      separatorBuilder: (context, index) => SizedBox(width: 10),
      itemBuilder: (context, index) {
        final category = categories[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  
                  image: DecorationImage(
                    image: AssetImage(category['image']!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 6),
              Text(
                category['name']!,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
              
            
          ),
        );
      },
    );
  }
}