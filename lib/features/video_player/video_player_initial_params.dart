class VideoPlayerInitialParams {
  const VideoPlayerInitialParams({
    this.videoUrl,
    this.channelHandle,
    this.caption,
    this.thumbnailUrl,
  });

  final String? videoUrl;

  final String? channelHandle;

  final String? caption;

  final String? thumbnailUrl;
}
