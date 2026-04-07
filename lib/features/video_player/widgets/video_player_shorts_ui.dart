import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../video_player_initial_params.dart';

/// Pinned 3px scrub line + touch target, matching YouTube Shorts.
class ShortsThinProgress extends StatelessWidget {
  const ShortsThinProgress({super.key, required this.controller});

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return const SizedBox(height: 12);
    }
    return VideoScrubber(
      controller: controller,
      child: SizedBox(
        height: 18,
        width: double.infinity,
        child: ValueListenableBuilder<VideoPlayerValue>(
          valueListenable: controller,
          builder: (context, value, _) {
            final dMs = value.duration.inMilliseconds;
            final pMs = value.position.inMilliseconds;
            var maxBuf = 0;
            for (final r in value.buffered) {
              final e = r.end.inMilliseconds;
              if (e > maxBuf) maxBuf = e;
            }
            final played = dMs > 0 ? (pMs / dMs).clamp(0.0, 1.0) : 0.0;
            final buffered = dMs > 0 ? (maxBuf / dMs).clamp(0.0, 1.0) : 0.0;
            return LayoutBuilder(
              builder: (context, c) {
                final w = c.maxWidth;
                return Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Container(
                      height: 3,
                      width: w,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(1.5),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        height: 3,
                        width: w * buffered,
                        decoration: BoxDecoration(
                          color: Colors.white38,
                          borderRadius: BorderRadius.circular(1.5),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        height: 3,
                        width: w * played,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(1.5),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

/// Gradients, top dismiss, right rail, bottom channel + caption (YouTube Shorts).
class ShortsChromeLayer extends StatelessWidget {
  const ShortsChromeLayer({
    super.key,
    required this.visible,
    required this.params,
  });

  final bool visible;
  final VideoPlayerInitialParams params;

  @override
  Widget build(BuildContext context) {
    final handle = params.channelHandle ?? '@Shorts';
    final cap = params.caption ?? 'Original audio';

    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: IgnorePointer(
            child: AnimatedOpacity(
              opacity: visible ? 1 : 0,
              duration: const Duration(milliseconds: 180),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.55),
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.65),
                    ],
                    stops: const [0.0, 0.2, 0.5, 1.0],
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: IgnorePointer(
            ignoring: !visible,
            child: AnimatedOpacity(
              opacity: visible ? 1 : 0,
              duration: const Duration(milliseconds: 180),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  child: Row(
                    children: [
                      _RoundDarkIconButton(
                        icon: Icons.keyboard_arrow_down_rounded,
                        iconSize: 30,
                        onPressed: () => Navigator.maybePop(context),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          right: 2,
          top: 0,
          bottom: 120,
          child: IgnorePointer(
            ignoring: !visible,
            child: AnimatedOpacity(
              opacity: visible ? 1 : 0,
              duration: const Duration(milliseconds: 180),
              child: SafeArea(
                child: Align(
                  alignment: Alignment.center,
                  child: _ShortsActionRail(),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 52,
          bottom: 36,
          child: IgnorePointer(
            ignoring: !visible,
            child: AnimatedOpacity(
              opacity: visible ? 1 : 0,
              duration: const Duration(milliseconds: 180),
              child: SafeArea(
                top: false,
                child: _ShortsBottomMeta(
                  channelHandle: handle,
                  caption: cap,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RoundDarkIconButton extends StatelessWidget {
  const _RoundDarkIconButton({
    required this.icon,
    required this.onPressed,
    this.iconSize = 26,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.45),
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, color: Colors.white, size: iconSize),
        ),
      ),
    );
  }
}

class _ShortsActionRail extends StatefulWidget {
  @override
  State<_ShortsActionRail> createState() => _ShortsActionRailState();
}

class _ShortsActionRailState extends State<_ShortsActionRail> {
  bool _liked = false;
  bool _disliked = false;

  void _like() {
    setState(() {
      _liked = !_liked;
      if (_liked) _disliked = false;
    });
  }

  void _dislike() {
    setState(() {
      _disliked = !_disliked;
      if (_disliked) _liked = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _railButton(
          icon: _liked ? Icons.thumb_up_rounded : Icons.thumb_up_alt_outlined,
          iconColor: _liked ? const Color(0xFFFF0000) : Colors.white,
          label: '12K',
          onTap: _like,
        ),
        _railButton(
          icon: _disliked
              ? Icons.thumb_down_rounded
              : Icons.thumb_down_alt_outlined,
          iconColor: _disliked ? Colors.white : Colors.white,
          label: 'Dislike',
          onTap: _dislike,
        ),
        _railButton(
          icon: Icons.comment_rounded,
          label: '234',
          onTap: () {},
        ),
        _railButton(
          icon: Icons.share_rounded,
          label: 'Share',
          onTap: () {},
        ),
        const SizedBox(height: 8),
        _ShortsChannelAvatar(),
      ],
    );
  }

  Widget _railButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color iconColor = Colors.white,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: iconColor, size: 32),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.85),
                    blurRadius: 6,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShortsChannelAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: const CircleAvatar(
            radius: 22,
            backgroundColor: Color(0xFF303030),
            child: Icon(Icons.person_rounded, color: Colors.white54, size: 28),
          ),
        ),
        Positioned(
          right: -2,
          bottom: -2,
          child: Container(
            padding: const EdgeInsets.all(1),
            decoration: const BoxDecoration(
              color: Color(0xFFFF0000),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add_rounded, color: Colors.white, size: 16),
          ),
        ),
      ],
    );
  }
}

class _ShortsBottomMeta extends StatelessWidget {
  const _ShortsBottomMeta({
    required this.channelHandle,
    required this.caption,
  });

  final String channelHandle;
  final String caption;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white54, width: 1.5),
                ),
                child: const CircleAvatar(
                  radius: 16,
                  backgroundColor: Color(0xFF303030),
                  child:
                      Icon(Icons.person_rounded, color: Colors.white54, size: 20),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  channelHandle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
              ),
              const _SubscribeChip(),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            caption,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.95),
              fontSize: 14,
              height: 1.25,
              shadows: [
                Shadow(
                  color: Colors.black.withValues(alpha: 0.9),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SubscribeChip extends StatefulWidget {
  const _SubscribeChip();

  @override
  State<_SubscribeChip> createState() => _SubscribeChipState();
}

class _SubscribeChipState extends State<_SubscribeChip> {
  bool _subscribed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _subscribed = !_subscribed),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
        decoration: BoxDecoration(
          color: _subscribed
              ? Colors.white.withValues(alpha: 0.22)
              : const Color(0xFFFF0000),
          borderRadius: BorderRadius.circular(2),
        ),
        child: Text(
          _subscribed ? 'Subscribed' : 'Subscribe',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 13,
            letterSpacing: -0.2,
          ),
        ),
      ),
    );
  }
}
