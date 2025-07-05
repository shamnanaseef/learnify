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

  factory VideoModel.fromMap(Map<String, dynamic> map, String id) {
    return VideoModel(
      id: id,
      title: map['title'],
      videoUrl: map['videoUrl'],
      duration: map['duration'],
      order: map['order'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'videoUrl': videoUrl,
      'duration': duration,
      'order': order,
    };
  }
}
