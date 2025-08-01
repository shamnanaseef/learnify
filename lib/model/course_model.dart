import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:learneasy/model/course_section_model.dart';

class Course {
   final String id;
  final String instructorId;
  final String title;
  final String discription;
  final String category;
  final double price;
  final String contentUrl;
   final String? image;
    

  Course( { this.id = '',required this.instructorId, required this.title, required this.discription, required this.category, required this.price, required this.contentUrl,this.image, });

  factory Course.fromjson(DocumentSnapshot doc,){
    final data =doc.data() as Map<String, dynamic>;
    return Course(
      id: doc.id,
      instructorId:data['instructorId'] ,
      title: data['title'],
      discription: data['discription'],
      category: data['category'], 
      price: data['price'],
      contentUrl: data['contentUrl'],
      image: data['image'],
     
      
      );
  }


  Map<String , dynamic> tojson (){
    return {
      'instructorId' : instructorId,
      'title':title,
      'discription':discription,
      'category':category,
      'price':price,
      'contentUrl':contentUrl,
      'image':image,
      
    };
  }
  

}