import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player_app/features/video_player/widgets/round_dark_icon.dart';

import '../video_player_initial_params.dart';
import 'shorts_action_rail.dart';
import 'shorts_bottom_meta.dart';

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
    final thumb = params.thumbnailUrl;

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
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  child: Row(
                    children: [
                      RoundDarkIconButton(
                        icon: Icons.keyboard_arrow_down_rounded,
                        iconSize: 30.r,
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
          right: 12.h,
          top: 0,
          bottom: 120.h,
          child: IgnorePointer(
            ignoring: !visible,
            child: AnimatedOpacity(
              opacity: visible ? 1 : 0,
              duration: const Duration(milliseconds: 180),
              child: SafeArea(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: ShortsActionRail(thumbnailUrl: thumb),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 52.w,
          bottom: 36.h,
          child: IgnorePointer(
            ignoring: !visible,
            child: AnimatedOpacity(
              opacity: visible ? 1 : 0,
              duration: const Duration(milliseconds: 180),
              child: SafeArea(
                top: false,
                child: ShortsBottomMeta(
                  channelHandle: handle,
                  caption: cap,
                  thumbnailUrl: thumb,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
