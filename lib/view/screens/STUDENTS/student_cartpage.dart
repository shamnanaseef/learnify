import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learneasy/controller/cart_controller.dart';
import 'package:learneasy/model/course_model.dart';

class StudentCartpage extends ConsumerWidget {
  const StudentCartpage({super.key});

  Future<Course?> fetchCourseById(String courseId) async {
    final doc =
        await FirebaseFirestore.instance
            .collection('courses')
            .doc(courseId)
            .get();

    if (!doc.exists) return null;

    return Course.fromjson(doc);
  }

  @override
  
Widget build(BuildContext context,WidgetRef ref) {
  final cartAsync = ref.watch(localCartItemsProvider);

  return cartAsync.when(
    data: (courseIds) {
      if (courseIds.isEmpty) {
        return Center(child: Text('Cart is empty'));
      }
      return ListView.builder(
        itemCount: courseIds.length,
        itemBuilder: (context, index) {
          final courseId = courseIds[index];
      
         
                  return FutureBuilder<Course?>(
                    future: fetchCourseById(courseId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
      
                      if (!snapshot.hasData || snapshot.data == null) {
                        return const ListTile(title: Text("Course not found."));
                      }
      
                      final course = snapshot.data!;
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            
                            children: [
                              
                              ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    course.image!,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                title: Text(course.title),
                                subtitle: Text('${course.price}'),
                              //  trailing: IconButton(onPressed: (){}, icon:Icon(Icons.delete)),
                              
                                onTap: () {
                                  // Navigate to course detail page
                                 
                                },
                              ),
                              SizedBox(height: 16,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.05,
                                    width: MediaQuery.of(context).size.width*0.40,
                                    child: ElevatedButton(onPressed: (){}, child: Text("Buy Now"),
                                  ),
                                  ),
                                    SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.05,
                                    width: MediaQuery.of(context).size.width*0.40,
                                    child: ElevatedButton(onPressed: ()async{
                                      await ref.read(cartLocalServiceProvider).removeFromCart(course.id);
                                      // ref.refresh(localCartItemsProvider); //
                                    }, child: Text("Remove"),
                                                                      ),
                                                                      ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
        },
      );
    },
    loading: () => CircularProgressIndicator(),
    error: (e, _) => Text('Error: $e'),
  );
}

  }