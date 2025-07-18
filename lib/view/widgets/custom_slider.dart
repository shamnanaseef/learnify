import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CustomSlider extends StatelessWidget {
 CustomSlider({super.key});

  final List<String> imageList = [
    'assets/sliders/1.jpeg',
    'assets/sliders/2.jpeg',
    'assets/sliders/3.jpeg'

  ];


  @override
  Widget build(BuildContext context) {
      return CarouselSlider(
        options: CarouselOptions(
          height: 250,
          aspectRatio: 16/9,
          viewportFraction: 1,
          initialPage: 0,
          enableInfiniteScroll: true,
          reverse: false,
          autoPlay: true,
          autoPlayInterval: Duration(seconds: 3),
          autoPlayAnimationDuration: Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          enlargeCenterPage: true,
          enlargeFactor: 0.3,
          //onPageChanged: callbackFunction,
          scrollDirection: Axis.horizontal,
        ),
        items:
            imageList.map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                 i,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              );
                },
              );
            }).toList(),
      );
  }
}