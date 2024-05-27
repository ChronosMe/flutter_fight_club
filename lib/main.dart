import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  BodyPart? defendingBodyPart;
  BodyPart? attackingBodyPart;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(213, 222, 240, 1),
      body: Column(
        children: [
          const SizedBox(height: 40),
          Row(
            children: [
              SizedBox(width: 16),
              Expanded(child: Center(child: Text("You".toUpperCase()))),
              SizedBox(width: 12),
              Expanded(child: Center(child: Text("Enemy".toUpperCase()))),
              SizedBox(width: 16),
            ],
          ),
          const SizedBox(height: 11),
          const Row(
            children: [
              SizedBox(width: 16),
              Expanded(child: Column(
                children: [
                  Center(child: Text("1")),
                  Center(child: Text("1")),
                  Center(child: Text("1")),
                  Center(child: Text("1")),
                  Center(child: Text("1")),
                ],
              )),
              SizedBox(width: 12),
              Expanded(child: Column(
                children: [
                  Center(child: Text("1")),
                  Center(child: Text("1")),
                  Center(child: Text("1")),
                  Center(child: Text("1")),
                  Center(child: Text("1")),
                ],
              )),
              SizedBox(width: 16),
            ],
          ),
          const Expanded(child: SizedBox()),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  children: [
                    Text("Defend".toUpperCase()),
                    const SizedBox(height: 13),
                    BodyPartButton(
                      bodyPart: BodyPart.head,
                      selected: defendingBodyPart == BodyPart.head,
                      bodyPartSetter: _selectDefendingBodyPart,
                    ),
                    const SizedBox(height: 14),
                    BodyPartButton(
                      bodyPart: BodyPart.torso,
                      selected: defendingBodyPart == BodyPart.torso,
                      bodyPartSetter: _selectDefendingBodyPart,
                    ),
                    const SizedBox(height: 14),
                    BodyPartButton(
                      bodyPart: BodyPart.legs,
                      selected: defendingBodyPart == BodyPart.legs,
                      bodyPartSetter: _selectDefendingBodyPart,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  children: [
                    Text("Attack".toUpperCase()),
                    const SizedBox(height: 13),
                    BodyPartButton(
                      bodyPart: BodyPart.head,
                      selected: attackingBodyPart == BodyPart.head,
                      bodyPartSetter: _selectAttackingBodyPart,
                    ),
                    const SizedBox(height: 14),
                    BodyPartButton(
                      bodyPart: BodyPart.torso,
                      selected: attackingBodyPart == BodyPart.torso,
                      bodyPartSetter: _selectAttackingBodyPart,
                    ),
                    const SizedBox(height: 14),
                    BodyPartButton(
                      bodyPart: BodyPart.legs,
                      selected: attackingBodyPart == BodyPart.legs,
                      bodyPartSetter: _selectAttackingBodyPart,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const SizedBox(width: 16),
              Expanded(
                child: GestureDetector(
                  onTap: () => {
                    if (defendingBodyPart != null && attackingBodyPart != null)
                      {
                        setState(() {
                          defendingBodyPart = null;
                          attackingBodyPart = null;
                        })
                      }
                    else
                      {print("Выдели, блеать!")}
                  },
                  child: SizedBox(
                    height: 40,
                    child: ColoredBox(
                      color: _getGoButtonColor(),
                      child: Center(
                        child: Text(
                          "Go".toUpperCase(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16)
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  void _selectDefendingBodyPart(final BodyPart value) {
    setState(() {
      defendingBodyPart = value;
    });
  }

  void _selectAttackingBodyPart(final BodyPart value) {
    setState(() {
      attackingBodyPart = value;
    });
  }

  Color _getGoButtonColor() {
    return (attackingBodyPart == null || defendingBodyPart == null)
        ? Color.fromRGBO(0, 0, 0, 0.38)
        : Color.fromRGBO(0, 0, 0, 0.87);
  }
}

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
}

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
              ? const Color.fromRGBO(18, 121, 206, 1)
              : Color.fromRGBO(0, 0, 0, 0.38),
          child: Center(
            child: Text(
              bodyPart.name.toUpperCase(),
              style: TextStyle(color: selected ? Colors.white : Color.fromRGBO(6, 13, 20, 1)),
            ),
          ),
        ),
      ),
    );
  }
}
