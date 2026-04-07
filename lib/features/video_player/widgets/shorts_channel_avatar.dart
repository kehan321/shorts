import 'package:flutter/material.dart';

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
        ShortsCircleAvatar(imageUrl: thumbnailUrl, radius: 22, iconSize: 28),
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
