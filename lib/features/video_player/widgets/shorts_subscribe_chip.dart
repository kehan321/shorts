import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shorts/core/utils/extensions.dart';
import 'package:shorts/core/widgets/app_button.dart';

class ShortsSubscribeChip extends StatefulWidget {
  const ShortsSubscribeChip({super.key});

  @override
  State<ShortsSubscribeChip> createState() => _ShortsSubscribeChipState();
}

class _ShortsSubscribeChipState extends State<ShortsSubscribeChip> {
  bool _subscribed = false;

  @override
  Widget build(BuildContext context) {
    return AppButton.getButton(
      context: context,
      backgroundColor: _subscribed
          ? context.theme.colorScheme.onPrimary.withValues(alpha: 0.22)
          : context.theme.colorScheme.error,
      width: 100.w,
      height: 35.h,
      radius: 4.r,
      text: _subscribed ? 'Subscribed' : 'Subscribe',
      onPressed: () => setState(() => _subscribed = !_subscribed),
    );
  }
}
