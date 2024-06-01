import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_fight_club/fight_club_colors.dart';
import 'package:flutter_fight_club/fight_club_icons.dart';
import 'package:flutter_fight_club/fight_club_images.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          textTheme:
              GoogleFonts.pressStart2pTextTheme(Theme.of(context).textTheme)),
      home: const MyHomePage(),
    );
  }
}

/// MY HOMEPAGE
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

/// HOMEPAGE STATE
class MyHomePageState extends State<MyHomePage> {
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
            const Expanded(child: SizedBox()),
            GameInfoWidget(text: gameInfoText),
            const Expanded(child: SizedBox()),
            ControlsWidget(
              defendingBodyPart: defendingBodyPart,
              attackingBodyPart: attackingBodyPart,
              selectDefendingBodyPart: _selectDefendingBodyPart,
              selectAttackingBodyPart: _selectAttackingBodyPart,
            ),
            const SizedBox(height: 14),
            GoButton(
              text:
                  yourLives == 0 || enemysLives == 0 ? "Start new game" : "Go",
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
      setState(() {
        _setGameInfoText();
        yourLives = maxLives;
        enemysLives = maxLives;
      });
    } else if (defendingBodyPart != null && attackingBodyPart != null) {
      setState(() {
        final bool enemyLoseLife = attackingBodyPart != whatEnemyDefends;
        final bool youLoseLife = defendingBodyPart != whatEnemyAttacks;

        if (enemyLoseLife) enemysLives -= 1;
        if (youLoseLife) yourLives -= 1;

        _setGameInfoText();

        whatEnemyAttacks = BodyPart.random();
        whatEnemyDefends = BodyPart.random();

        defendingBodyPart = null;
        attackingBodyPart = null;
      });
    }
  }

  /// SET GAME INFO TEXT
  void _setGameInfoText() {
    print([
      attackingBodyPart?.name,
      defendingBodyPart?.name,
      whatEnemyDefends?.name,
      whatEnemyAttacks?.name,
      yourLives,
      enemysLives
    ]);
    final bool enemyLoseLife = attackingBodyPart != whatEnemyDefends;
    final bool youLoseLife = defendingBodyPart != whatEnemyAttacks;
    final bool youBlock = defendingBodyPart == whatEnemyAttacks;
    final bool enemyBlock = attackingBodyPart == whatEnemyDefends;

    String string1 = "";
    String string2 = "";
    String fullString = "";

    if (defendingBodyPart == null && attackingBodyPart == null) {
      fullString = "";
    } else if (yourLives == 0 || enemysLives == 0) {
      if (yourLives == 0 && enemysLives == 0) {
        fullString = "Draw";
      } else if (yourLives == 0) {
        fullString = "You lost";
      } else if (enemysLives == 0) {
        fullString = "You won";
      }
    } else {
      if (enemyBlock) string1 = "Your attack was blocked.";
      if (enemyLoseLife) {
        string1 = "You hit enemy’s ${attackingBodyPart?.name.toString()}.";
      }
      if (youBlock) string2 = "Enemy’s attack was blocked.";
      if (youLoseLife) {
        string2 = "Enemy hit your ${attackingBodyPart?.name.toString()}.";
      }

      fullString = "$string1\n$string2";
    }

    gameInfoText = fullString;
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SizedBox(
          width: double.infinity,
          height: 160,
          child: ColoredBox(
            color: FightClubColors.grayBackground,
            child: Center(
                child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11),
            )),
          ),
        ),
      ),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SizedBox(
                  height: 160,
                  child: ColoredBox(
                    color: FightClubColors.whiteBackground,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LivesWidget(
                              overallLivesCount: maxLivesCount,
                              currentLivesCount: yourLivesCount),
                          const SizedBox(width: 16),
                          Column(
                            children: [
                              const SizedBox(height: 16),
                              const Text(
                                "You",
                                style: TextStyle(
                                    color: FightClubColors.darkGreyText),
                              ),
                              const SizedBox(height: 12),
                              Image.asset(
                                FightClubImages.youAvatar,
                                width: 92,
                                height: 92,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: 160,
                  child: ColoredBox(
                    color: FightClubColors.grayBackground,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              const SizedBox(height: 16),
                              const Text("Enemy",
                                  style: TextStyle(
                                      color: FightClubColors.darkGreyText)),
                              const SizedBox(height: 12),
                              Image.asset(
                                FightClubImages.enemyAvatar,
                                width: 92,
                                height: 92,
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          LivesWidget(
                              overallLivesCount: maxLivesCount,
                              currentLivesCount: enemysLivesCount)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Center(
            child: SizedBox(
              width: 44,
              height: 44,
              child: ColoredBox(
                color: Color.fromRGBO(77, 200, 57, 1),
              ),
            ),
          ),
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
            padding: index + 1 == overallLivesCount ? const EdgeInsets.only(bottom: 0) : const EdgeInsets.only(bottom: 4),
            child: Image.asset(
              FightClubIcons.heartFull,
              width: 18,
              height: 18,
            ),
          );
        } else {
          return Padding(
            padding: index + 1 == overallLivesCount ? const EdgeInsets.only(bottom: 0) : const EdgeInsets.only(bottom: 4),
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

/// GO BUTTON
class GoButton extends StatelessWidget {
  final VoidCallback onTap;
  final Color color;
  final String text;

  const GoButton({
    super.key,
    required this.onTap,
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          height: 40,
          child: ColoredBox(
            color: color,
            child: Center(
              child: Text(
                text.toUpperCase(),
                style: const TextStyle(
                    color: FightClubColors.whiteText,
                    fontWeight: FontWeight.w900,
                    fontSize: 16),
              ),
            ),
          ),
        ),
      ),
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
        child: ColoredBox(
          color: selected
              ? FightClubColors.blueButton
              : FightClubColors.greyButton,
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
