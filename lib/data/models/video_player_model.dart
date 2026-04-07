class VideoPlayerModel {
  final String? videoUrl;

  VideoPlayerModel({this.videoUrl});

  factory VideoPlayerModel.fromJson(Map<String, dynamic> json) {
    return VideoPlayerModel(
      videoUrl: json['video_url'] as String? ??
          json['videoUrl'] as String? ??
          json['url'] as String?,
    );
  }
}
