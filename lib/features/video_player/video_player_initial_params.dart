class VideoPlayerInitialParams {
  const VideoPlayerInitialParams({
    this.videoUrl,
    this.channelHandle,
    this.caption,
  });

  final String? videoUrl;

  /// Shown bottom-left like Shorts (e.g. `@creator`).
  final String? channelHandle;

  /// Short caption under the channel row.
  final String? caption;
}
