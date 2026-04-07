import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShortsCircleAvatar extends StatelessWidget {
  const ShortsCircleAvatar({
    super.key,
    required this.imageUrl,
    required this.radius,
    this.iconSize = 24,
    this.borderWidth = 2,
    this.borderColor = Colors.white,
  });

  final String? imageUrl;
  final double radius;
  final double iconSize;
  final double borderWidth;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    final d = radius * 2;
    return Container(
      width: d.r,
      height: d.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: borderWidth),
      ),
      child: ClipOval(
        child: imageUrl != null && imageUrl!.isNotEmpty
            ? Image.network(
                imageUrl!,
                width: d,
                height: d,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => ColoredBox(
                  color: const Color(0xFF303030),
                  child: Icon(
                    Icons.person_rounded,
                    color: Colors.white54,
                    size: iconSize,
                  ),
                ),
              )
            : ColoredBox(
                color: const Color(0xFF303030),
                child: Icon(
                  Icons.person_rounded,
                  color: Colors.white54,
                  size: iconSize,
                ),
              ),
      ),
    );
  }
}
