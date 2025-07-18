import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:learneasy/utils/constants/colors.dart';
import 'package:learneasy/view/widgets/custom_appbar.dart';
import 'package:learneasy/view/widgets/custom_drawer.dart';
import 'package:learneasy/view/widgets/custom_slider.dart';

class AdminHomepage extends StatelessWidget {
  const AdminHomepage({super.key});

  
  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      drawer: const AppDrawer(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: CustomAppbar(scaffoldKey: scaffoldKey),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
             CustomSlider(),
              SizedBox(height: 12,),
              Text("Dash Board",style: TextStyle(fontSize: 28,fontWeight: FontWeight.w400),),
              SizedBox(height: 12,),
              Row(
                children: [
                 cardcontroll(title:"Total Users" , subTitle: "40956",icon: Icons.people),
                  SizedBox(width: 10,),
                   cardcontroll(title:"Total Courses" , subTitle: "120",icon: Icons.menu_book_outlined),
                 
                ],
              )
                
            ],
          ),
        ),
      ),
    );
  }

  
}

class cardcontroll extends StatelessWidget {
  const cardcontroll({
    super.key, required this.title, required this.subTitle, required this.icon,
  });

  final String title, subTitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
       height: 200,
       width: MediaQuery.of(context).size.width * 0.4,
       decoration: BoxDecoration(
          color: Colors.white,
         borderRadius: BorderRadius.circular(12)
       ),
       child: Padding(
         padding: const EdgeInsets.all(10.0),
         child: Column(
           spacing: 10,
           children: [
             SizedBox(height: 20,),
             Container(
               height: 50,
               width: 50,
               decoration: BoxDecoration(
            color:Colors.deepPurple[50],
           borderRadius: BorderRadius.circular(12)
         ),
               child: Icon(icon,size: 24,color: AppColors.iconColor)),
               Expanded(child: Text(title,style: TextStyle(fontSize: 22),)),
               Expanded(child: Text(subTitle,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 26),))
           ],
         ),
       ),
       ),
    );
  }
}
