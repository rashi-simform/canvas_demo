import 'package:canvas_demo/modules/game/arc_progress_indicator.dart';
import 'package:canvas_demo/modules/game/custom_appbar_button.dart';
import 'package:canvas_demo/modules/game/flow_menu.dart';
import 'package:canvas_demo/modules/sprite/sprite_painter.dart';
import 'package:canvas_demo/modules/zoom_demo/zoom_demo.dart';
import 'package:canvas_demo/values/enumerations.dart';
import 'package:flutter/material.dart';

import '../boost_animation/post_screen.dart';
import '../profile/profile_screen.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

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
              // Positioned(
              //   left: 20,
              //   top: 70,
              //   child: HexagonalBox(
              //     size: Size(150, 150),
              //     rotationAngle: 30 *pi/180,
              //   ),
              // ),
              Positioned(
                right: 0,
                top: 0,
                child: CustomAppbarButton(
                  child: SizedBox(
                    width: 140,
                    height: 60,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Navigator.push<void>(
                          context,
                          MaterialPageRoute<void>(
                            builder:
                                (BuildContext context) => const PostScreen(),
                          ),
                        );
                      },
                      child: Icon(
                        Icons.card_giftcard,
                        color: Colors.white.withAlpha(180),
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ),
              // TODO: top left button
              Positioned(
                left: 0,
                top: 0,
                child: CustomAppbarButton(
                  position: Position.topLeft,
                  child: SizedBox(
                    width: 140,
                                  height: 60,
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      Navigator.push<void>(
                                        context,
                                        MaterialPageRoute<void>(
                                          builder:
                                (BuildContext context) => const ProfileScreen(),
                          ),
                        );
                                    },
                                    child: Icon(
                        Icons.person,
                        color: Colors.white.withAlpha(180),
                        size: 30,
                                    ),
                                  ),
                                ),
                              ),
                            ),

              Positioned(
                right: 0,
                bottom: 0,
                child: CustomAppbarButton(
                  position: Position.bottomRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CanvasImageZoomScreen(),
                        ),
                      );
                    },
                    child: SizedBox(
                      width: 140,
                      height: 60,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'STEP GOAL',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '3000',
                            style: TextStyle(
                              color: Colors.white.withAlpha(180),
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                bottom: 0,
                child: CustomAppbarButton(
                  position: Position.bottomLeft,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SpritePaint(),
                        ),
                      );
                    },
                    child: SizedBox(
                      width: 140,
                      height: 60,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'TOTAL STEPS',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '1230',
                            style: TextStyle(
                              color: Colors.white.withAlpha(180),
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              ArcProgressIndicator(),
              const FlowMenu(),
            ],
          ),
        ),
      ),
    );
  }
}
