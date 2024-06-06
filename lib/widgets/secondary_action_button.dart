import 'package:flutter/material.dart';

import '../resources/fight_club_colors.dart';

class SecondaryActionButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;

  const SecondaryActionButton({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        padding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        height: 44,
        decoration: BoxDecoration(
          border:
          Border.all(color: FightClubColors.darkGreyText, width: 2),
          color: Colors.transparent,
        ),
        alignment: Alignment.center,
        child: Text(
          text.toUpperCase(),
          style: const TextStyle(
              color: FightClubColors.darkGreyText,
              fontSize: 13,
              fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}
