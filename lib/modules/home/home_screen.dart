import 'package:canvas_demo/modules/game/draw_shape.dart';
import 'package:canvas_demo/modules/home/hidden_button.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage('assets/images/background3.jpg'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withValues(alpha: 0.3),
                BlendMode.darken,
              ),
            ),
          ),
          child: Stack(
            children: [
              DrawShape(),
              HiddenButton()
            ],
          ),
        ),
      ),
    );
  }
}

