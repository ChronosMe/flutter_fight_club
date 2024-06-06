import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_fight_club/widgets/secondary_action_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../resources/fight_club_colors.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FightClubColors.grayBackground,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 24),
              child: const Text(
                "Statistics",
                style: TextStyle(
                    color: FightClubColors.darkGreyText, fontSize: 24),
              ),
            ),
            const Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _FullStatString(statKey: "Won"),
                  _FullStatString(statKey: "Lost"),
                  _FullStatString(statKey: "Draw"),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: SecondaryActionButton(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  text: "Back"),
            )
          ],
        ),
      ),
    );
  }
}

class _FullStatString extends StatelessWidget {
  final String statKey;
  const _FullStatString({
    super.key, required this.statKey,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int?>(
      future: SharedPreferences.getInstance().then(
              (sharedPreferences) =>
              sharedPreferences.getInt("stats_${statKey.toLowerCase()}")),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return _StatString(text: statKey, result: 0);
        }
        return _StatString(text: statKey, result: snapshot.data!);
      },
    );
  }
}

class _StatString extends StatelessWidget {
  final String text;
  final int result;

  const _StatString({
    super.key, required this.text, required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 40,
        child: Text(
          "$text: ${result.toString()}",
          style: const TextStyle(
              color: FightClubColors.darkGreyText, fontSize: 16),
        ));
  }
}
