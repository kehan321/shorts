import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player_app/core/utils/extensions.dart';

import 'shorts_channel_avatar.dart';

class ShortsActionRail extends StatefulWidget {
  const ShortsActionRail({super.key, this.thumbnailUrl});

  final String? thumbnailUrl;

  @override
  State<ShortsActionRail> createState() => _ShortsActionRailState();
}

class _ShortsActionRailState extends State<ShortsActionRail> {
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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _railButton(
          icon: _liked ? Icons.thumb_up_rounded : Icons.thumb_up_alt_outlined,
          iconColor: _liked
              ? context.theme.colorScheme.primary
              : context.theme.colorScheme.onPrimary,
          label: '12K',
          onTap: _like,
        ),
        _railButton(
          icon: _disliked
              ? Icons.thumb_down_rounded
              : Icons.thumb_down_alt_outlined,
          iconColor: context.theme.colorScheme.onPrimary,
          label: 'Dislike',
          onTap: _dislike,
        ),
        _railButton(
          icon: Icons.comment_rounded,
          iconColor: context.theme.colorScheme.onPrimary,
          label: '234',
          onTap: () {},
        ),
        _railButton(
          icon: Icons.share_rounded,
          iconColor: context.theme.colorScheme.onPrimary,
          label: 'Share',
          onTap: () {},
        ),
        const SizedBox(height: 8),
        ShortsChannelAvatar(thumbnailUrl: widget.thumbnailUrl),
      ],
    );
  }

  Widget _railButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: iconColor, size: 32.r),
            SizedBox(height: 4.h),
            Text(
              label,
              style: context.textTheme.bodySmall?.copyWith(
                color: context.theme.colorScheme.onPrimary,

                shadows: [
                  Shadow(
                    color: context.theme.colorScheme.onSurface.withValues(
                      alpha: 0.85,
                    ),
                    blurRadius: 6.r,
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
