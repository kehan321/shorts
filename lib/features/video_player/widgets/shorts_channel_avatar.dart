import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player_app/core/utils/extensions.dart';

import 'shorts_avatar.dart';

class ShortsChannelAvatar extends StatelessWidget {
  const ShortsChannelAvatar({super.key, this.thumbnailUrl});

  final String? thumbnailUrl;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        ShortsCircleAvatar(
          imageUrl: thumbnailUrl,
          radius: 22.r,
          iconSize: 28.r,
        ),
        Positioned(
          right: -2,
          bottom: -2,
          child: Container(
            padding: EdgeInsets.all(1.r),
            decoration: BoxDecoration(
              color: context.theme.colorScheme.error,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.add_rounded,
              color: context.theme.colorScheme.onPrimary,
              size: 16.r,
            ),
          ),
        ),
      ],
    );
  }
}
