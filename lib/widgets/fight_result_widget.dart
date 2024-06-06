import 'package:flutter/material.dart';
import 'package:flutter_fight_club/fight_result.dart';

import '../resources/fight_club_colors.dart';
import '../resources/fight_club_images.dart';

class FightResultWidget extends StatelessWidget {
  final String? fightResult;

  const FightResultWidget({super.key, required this.fightResult});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: Stack(
        children: [
          Stack(
            children: [
              const Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ColoredBox(color: FightClubColors.whiteBackground),
                  ),
                  Expanded(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                        colors: [
                          FightClubColors.whiteBackground,
                          FightClubColors.grayBackground
                        ],
                      )),
                    ),
                  ),
                  Expanded(
                    child: ColoredBox(color: FightClubColors.grayBackground),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 12),
                      const Text(
                        "You",
                        style: TextStyle(
                            color: FightClubColors.darkGreyText,
                            fontSize: 14,
                            height: 1),
                      ),
                      const SizedBox(height: 10),
                      Image.asset(
                        FightClubImages.youAvatar,
                        width: 92,
                        height: 92,
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 16),
                    decoration: BoxDecoration(
                      color: _getResultBackgroundColor(),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      fightResult.toString(),
                      style: const TextStyle(
                          color: FightClubColors.whiteText, fontSize: 16),
                    ),
                  ),
                  Column(
                    children: [
                      const SizedBox(height: 12),
                      const Text("Enemy",
                          style: TextStyle(
                              color: FightClubColors.darkGreyText,
                              fontSize: 14,
                              height: 1)),
                      const SizedBox(height: 10),
                      Image.asset(
                        FightClubImages.enemyAvatar,
                        width: 92,
                        height: 92,
                      )
                    ],
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Color _getResultBackgroundColor() {
    Color color = FightClubColors.draw;
    if (fightResult == "Won") color = FightClubColors.won;
    if (fightResult == "Draw") color = FightClubColors.draw;
    if (fightResult == "Lost") color = FightClubColors.lost;
    return color;
  }
}
