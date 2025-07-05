import 'package:flutter/material.dart';


class OnboardWidget extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;



  const OnboardWidget({super.key, required this.title, required this.subtitle, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
          height: 250,
          
         image,
          fit: BoxFit.cover,
        ),
        SizedBox(height: 30,),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                if (title != null)
                  Text(
                    title,
                    style: TextStyle(
          color: Colors.blue[400],
          fontSize: 30,
          fontWeight: FontWeight.bold),
                  ),
                Text(
                  subtitle,
                  style: TextStyle(
                      color: Colors.blue[200],
                      fontSize: 20,
                      ),
                )
            ],
          ),
        )
      
        ],
      ),);
  }
}