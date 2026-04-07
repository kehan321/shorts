abstract final class VideoPlayerConstants {
  static const skipStep = Duration(seconds: 10);
  static const hideChromeAfter = Duration(seconds: 3);
  static const chromeSlideDuration = Duration(milliseconds: 280);

  static const playbackSpeeds = <double>[
    0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0,
  ];

  static const defaultVideoUrl =
      'https://d31vogijxzpo63.cloudfront.net/source/0665bd5f-da20-4346-aa92-63b66b93bd7a.mp4';
}
