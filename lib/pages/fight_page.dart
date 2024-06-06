import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fight_club/fight_result.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../resources/fight_club_colors.dart';
import '../resources/fight_club_icons.dart';
import '../resources/fight_club_images.dart';
import '../widgets/action_button.dart';

/// MY HOMEPAGE
class FightPage extends StatefulWidget {
  const FightPage({super.key});

  @override
  State<FightPage> createState() => FightPageState();
}

/// HOMEPAGE STATE
class FightPageState extends State<FightPage> {
  static const maxLives = 5;

  BodyPart? defendingBodyPart;
  BodyPart? attackingBodyPart;

  BodyPart whatEnemyAttacks = BodyPart.random();
  BodyPart whatEnemyDefends = BodyPart.random();

  int yourLives = maxLives;
  int enemysLives = maxLives;

  String gameInfoText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FightClubColors.background,
      body: SafeArea(
        child: Column(
          children: [
            FightersInfo(
              maxLivesCount: maxLives,
              yourLivesCount: yourLives,
              enemysLivesCount: enemysLives,
            ),
            const SizedBox(height: 30),
            //GameInfoWidget(text: gameInfoText),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ColoredBox(
                color: FightClubColors.grayBackground,
                child: SizedBox(
                  width: double.infinity,
                  child: GameInfoWidget(text: gameInfoText),
                ),
              ),
            )),
            const SizedBox(height: 30),
            ControlsWidget(
              defendingBodyPart: defendingBodyPart,
              attackingBodyPart: attackingBodyPart,
              selectDefendingBodyPart: _selectDefendingBodyPart,
              selectAttackingBodyPart: _selectAttackingBodyPart,
            ),
            const SizedBox(height: 14),
            ActionButton(
              text: yourLives == 0 || enemysLives == 0 ? "Back" : "Go",
              onTap: _onGoButtonClicked,
              color: _getGoButtonColor(),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  /// SELECT DEFENDING BODYPART
  void _selectDefendingBodyPart(final BodyPart value) {
    if (yourLives == 0 || enemysLives == 0) {
      return;
    }
    setState(() {
      defendingBodyPart = value;
    });
  }

  /// SELECT ATTACKING BODYPART
  void _selectAttackingBodyPart(final BodyPart value) {
    if (yourLives == 0 || enemysLives == 0) {
      return;
    }
    setState(() {
      attackingBodyPart = value;
    });
  }

  /// GET GO BUTTON COLOR
  Color _getGoButtonColor() {
    if (yourLives == 0 || enemysLives == 0) {
      return FightClubColors.blackButton;
    } else if (attackingBodyPart == null || defendingBodyPart == null) {
      return FightClubColors.greyButton;
    } else {
      return FightClubColors.blackButton;
    }
  }

  /// ON GO BUTTON CLICKED
  void _onGoButtonClicked() {
    if (yourLives == 0 || enemysLives == 0) {
      Navigator.of(context).pop();
    } else if (defendingBodyPart != null && attackingBodyPart != null) {
      setState(() {
        final bool enemyLoseLife = attackingBodyPart != whatEnemyDefends;
        final bool youLoseLife = defendingBodyPart != whatEnemyAttacks;

        if (enemyLoseLife) enemysLives -= 1;
        if (youLoseLife) yourLives -= 1;

        final FightResult? fightResult = FightResult.calculateResult(yourLives, enemysLives);

        if (fightResult != null) {
          _makeStat(fightResult);
        }

        gameInfoText = _calculateCenterText(youLoseLife, enemyLoseLife);

        whatEnemyAttacks = BodyPart.random();
        whatEnemyDefends = BodyPart.random();

        defendingBodyPart = null;
        attackingBodyPart = null;
      });
    }
  }

  /// SET GAME INFO TEXT
  String _calculateCenterText(
      final bool youLoseLife, final bool enemyLoseLife) {
    if (defendingBodyPart == null && attackingBodyPart == null) {
      return "";
    } else if (yourLives == 0 && enemysLives == 0) {
      return "Draw";
    } else if (yourLives == 0) {
      return "You lost";
    } else if (enemysLives == 0) {
      return "You won";
    } else {
      final String string1 = enemyLoseLife
          ? "You hit enemy’s ${attackingBodyPart?.name.toString()}."
          : "Your attack was blocked.";
      final String string2 = youLoseLife
          ? "Enemy hit your ${attackingBodyPart?.name.toString()}."
          : "Enemy’s attack was blocked.";

      return "$string1\n$string2";
    }
  }

  /// WORK WITH STAT
  void _makeStat(FightResult fightResult) {
    SharedPreferences.getInstance().then((sharedPreferences) {
      sharedPreferences.setString("last_fight_result", fightResult.result);

      String key = "stats_${fightResult.result.toString().toLowerCase()}";
      int? number = sharedPreferences.getInt(key);
      number ??= 1;
      number++;
      print([key, number]);
      sharedPreferences.setInt(key, number);
    });
  }
}

/// GAME INFO WIDGET
class GameInfoWidget extends StatelessWidget {
  final String text;

  const GameInfoWidget({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: FightClubColors.grayBackground,
      child: Center(
          child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 11),
      )),
    );
  }
}

/// FIGHTERS INFO
class FightersInfo extends StatelessWidget {
  final int maxLivesCount;
  final int yourLivesCount;
  final int enemysLivesCount;

  const FightersInfo({
    super.key,
    required this.maxLivesCount,
    required this.yourLivesCount,
    required this.enemysLivesCount,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
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
                  LivesWidget(
                      overallLivesCount: maxLivesCount,
                      currentLivesCount: yourLivesCount),
                  Column(
                    children: [
                      const SizedBox(height: 16),
                      const Text(
                        "You",
                        style: TextStyle(color: FightClubColors.darkGreyText),
                      ),
                      const SizedBox(height: 12),
                      Image.asset(
                        FightClubImages.youAvatar,
                        width: 92,
                        height: 92,
                      )
                    ],
                  ),
                  const SizedBox(
                    width: 44,
                    height: 44,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: FightClubColors.blueButton,
                      ),
                      child: Center(
                        child: Text(
                          "vs",
                          style: TextStyle(
                              color: FightClubColors.whiteText, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      const SizedBox(height: 16),
                      const Text("Enemy",
                          style:
                              TextStyle(color: FightClubColors.darkGreyText)),
                      const SizedBox(height: 12),
                      Image.asset(
                        FightClubImages.enemyAvatar,
                        width: 92,
                        height: 92,
                      )
                    ],
                  ),
                  LivesWidget(
                      overallLivesCount: maxLivesCount,
                      currentLivesCount: enemysLivesCount)
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}

/// LIVES WIDGET
class LivesWidget extends StatelessWidget {
  final int overallLivesCount;
  final int currentLivesCount;

  const LivesWidget({
    super.key,
    required this.overallLivesCount,
    required this.currentLivesCount,
  })  : assert(overallLivesCount >= 1),
        assert(currentLivesCount >= 0),
        assert(currentLivesCount <= overallLivesCount);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(overallLivesCount, (index) {
        if (index < currentLivesCount) {
          return Padding(
            padding:
                EdgeInsets.only(bottom: index < overallLivesCount - 1 ? 4 : 0),
            child: Image.asset(
              FightClubIcons.heartFull,
              width: 18,
              height: 18,
            ),
          );
        } else {
          return Padding(
            padding:
                EdgeInsets.only(bottom: index < overallLivesCount - 1 ? 4 : 0),
            child: Image.asset(
              FightClubIcons.heartEmpty,
              width: 18,
              height: 18,
            ),
          );
        }
      }),
    );
  }
}

/// CONTROLS WIDGET
class ControlsWidget extends StatelessWidget {
  final BodyPart? defendingBodyPart;
  final ValueSetter<BodyPart> selectDefendingBodyPart;
  final BodyPart? attackingBodyPart;
  final ValueSetter<BodyPart> selectAttackingBodyPart;

  const ControlsWidget(
      {super.key,
      required this.defendingBodyPart,
      required this.attackingBodyPart,
      required this.selectDefendingBodyPart,
      required this.selectAttackingBodyPart});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            children: [
              Text("Defend".toUpperCase(),
                  style: const TextStyle(color: FightClubColors.darkGreyText)),
              const SizedBox(height: 13),
              BodyPartButton(
                bodyPart: BodyPart.head,
                selected: defendingBodyPart == BodyPart.head,
                bodyPartSetter: selectDefendingBodyPart,
              ),
              const SizedBox(height: 14),
              BodyPartButton(
                bodyPart: BodyPart.torso,
                selected: defendingBodyPart == BodyPart.torso,
                bodyPartSetter: selectDefendingBodyPart,
              ),
              const SizedBox(height: 14),
              BodyPartButton(
                bodyPart: BodyPart.legs,
                selected: defendingBodyPart == BodyPart.legs,
                bodyPartSetter: selectDefendingBodyPart,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            children: [
              Text("Attack".toUpperCase(),
                  style: const TextStyle(color: FightClubColors.darkGreyText)),
              const SizedBox(height: 13),
              BodyPartButton(
                bodyPart: BodyPart.head,
                selected: attackingBodyPart == BodyPart.head,
                bodyPartSetter: selectAttackingBodyPart,
              ),
              const SizedBox(height: 14),
              BodyPartButton(
                bodyPart: BodyPart.torso,
                selected: attackingBodyPart == BodyPart.torso,
                bodyPartSetter: selectAttackingBodyPart,
              ),
              const SizedBox(height: 14),
              BodyPartButton(
                bodyPart: BodyPart.legs,
                selected: attackingBodyPart == BodyPart.legs,
                bodyPartSetter: selectAttackingBodyPart,
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}

/// BODY PART
class BodyPart {
  final String name;

  const BodyPart._(this.name);

  static const head = BodyPart._("Head");
  static const torso = BodyPart._("Torso");
  static const legs = BodyPart._("Legs");

  @override
  String toString() {
    return 'BodyPart{name: $name}';
  }

  static const List<BodyPart> _values = [head, torso, legs];

  static BodyPart random() {
    return _values[Random().nextInt(_values.length)];
  }
}

/// BODY PART BUTTON
class BodyPartButton extends StatelessWidget {
  final BodyPart bodyPart;
  final bool selected;
  final ValueSetter<BodyPart> bodyPartSetter;

  const BodyPartButton({
    super.key,
    required this.bodyPart,
    required this.selected,
    required this.bodyPartSetter,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => bodyPartSetter(bodyPart),
      child: SizedBox(
        height: 40,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: selected ? FightClubColors.blueButton : Colors.transparent,
            border: !selected
                ? Border.all(color: FightClubColors.darkGreyText, width: 2)
                : null,
          ),
          child: Center(
            child: Text(
              bodyPart.name.toUpperCase(),
              style: TextStyle(
                  color: selected
                      ? FightClubColors.whiteText
                      : FightClubColors.darkGreyText),
            ),
          ),
        ),
      ),
    );
  }
}
