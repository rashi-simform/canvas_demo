import 'package:canvas_demo/modules/game/game_screen.dart';
import 'package:flutter/material.dart';

class HiddenButton extends StatelessWidget {
  const HiddenButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 20,
      bottom: 20,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const GameScreen()),
          );
        },
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Next'),
          ),
        ),
      ),
    );
  }
}
