import 'package:flutter/material.dart';

class ShortsSubscribeChip extends StatefulWidget {
  const ShortsSubscribeChip({super.key});

  @override
  State<ShortsSubscribeChip> createState() => _ShortsSubscribeChipState();
}

class _ShortsSubscribeChipState extends State<ShortsSubscribeChip> {
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
