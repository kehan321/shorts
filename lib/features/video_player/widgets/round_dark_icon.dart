import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player_app/core/utils/extensions.dart';

class RoundDarkIconButton extends StatelessWidget {
  const RoundDarkIconButton({
    super.key,
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
          width: 44.r,
          height: 44.r,
          child: Icon(
            icon,
            color: context.theme.colorScheme.onPrimary,
            size: iconSize.r,
          ),
        ),
      ),
    );
  }
}
