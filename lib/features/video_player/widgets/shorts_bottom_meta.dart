import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player_app/core/utils/extensions.dart';

import 'shorts_avatar.dart';
import 'shorts_subscribe_chip.dart';

class ShortsBottomMeta extends StatelessWidget {
  const ShortsBottomMeta({
    super.key,
    required this.channelHandle,
    required this.caption,
    this.thumbnailUrl,
  });

  final String channelHandle;
  final String caption;
  final String? thumbnailUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 12.w, right: 8.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ShortsCircleAvatar(
                imageUrl: thumbnailUrl,
                radius: 16.r,
                iconSize: 20.r,
                borderWidth: 1.5.r,
                borderColor: Colors.white54,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  channelHandle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.theme.colorScheme.onPrimary,
                  ),
                ),
              ),
              ShortsSubscribeChip(),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            caption,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.theme.colorScheme.onPrimary.withValues(
                alpha: 0.95,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
