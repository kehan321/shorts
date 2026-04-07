import 'package:flutter/material.dart';

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
      padding: const EdgeInsets.only(left: 12, right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ShortsCircleAvatar(
                imageUrl: thumbnailUrl,
                radius: 16,
                iconSize: 20,
                borderWidth: 1.5,
                borderColor: Colors.white54,
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
              const ShortsSubscribeChip(),
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
