import 'package:flutter/material.dart';
import '../resources/fight_club_colors.dart';

/// GO BUTTON
class ActionButton extends StatelessWidget {
  final VoidCallback onTap;
  final Color color;
  final String text;

  const ActionButton({
    super.key,
    required this.onTap,
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: color,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        height: 40,
        alignment: Alignment.center,
        child: Text(
          text.toUpperCase(),
          style: const TextStyle(
              color: FightClubColors.whiteText,
              fontWeight: FontWeight.w900,
              fontSize: 16),
        ),
      ),
    );
  }
}