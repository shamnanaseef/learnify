class VideoModel {
  final String id;
  final String title;
  final String videoUrl;
  final String duration;
  final int order;

  VideoModel({
    required this.id,
    required this.title,
    required this.videoUrl,
    required this.duration,
    required this.order,
  });

  

  factory VideoModel.fromjson(String id,Map<String, dynamic> json) {
    
    return VideoModel(

      id: id,
      title: json['title'] ?? 'untitled vedio',
      videoUrl: json['videoUrl'] ?? '',
      duration: json['duration'] ?? '0:00',
      order: json['order'] ?? 0,
    );
  }

  Map<String, dynamic> tojson() {
    return {
      'title': title,
      'videoUrl': videoUrl,
      'duration': duration,
      'order': order,
    };
  }
}
