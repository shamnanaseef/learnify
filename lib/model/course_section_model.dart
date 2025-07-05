import 'package:learneasy/model/section_content.dart';



class SectionModel {
  final String id;
  final String title;
  final int order;
  final List<VideoModel> videos;

  SectionModel({
    required this.id,
    required this.title,
    required this.order,
    required this.videos,
  });
}
