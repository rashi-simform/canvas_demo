import 'dart:ui';

import 'package:canvas_demo/modules/profile/stat_item.dart';
import 'package:canvas_demo/modules/profile/vehicle_path_painter.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late AnimationController _profileAnimController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;
  late AnimationController _carPathController;
  late Animation _carPathAnimation;
  late Path carPath;

  @override
  void initState() {
    super.initState();

    _profileAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _profileAnimController, curve: Curves.easeIn),
    );

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _profileAnimController,
      curve: Curves.easeOut,
    ));

    _carPathController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _carPathAnimation = Tween(begin: 0.0,end: 1.0).animate(_carPathController)
      ..addListener((){
        setState(() {
        });
      });
   _carPathController.forward();

    _profileAnimController.forward();
    // _carPathController.repeat(reverse: false);

    final size = Size(400, 250);
     carPath = Path()
      ..moveTo(size.width * 0.1, size.height * 0.9)
      ..quadraticBezierTo(
        size.width * 0.4,
        size.height * 0.8,
        size.width * 0.4,
        size.height * 0.6,
      );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xff0E1128),
      body: Column(
        children: [
          const SizedBox(height: 80),
          FadeTransition(
            opacity: _fadeAnim,
            child: SlideTransition(
              position: _slideAnim,
              child: const CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage('assets/images/post1.jpg'),
              ),
            ),
          ),
          const SizedBox(height: 12),
          FadeTransition(
            opacity: _fadeAnim,
            child: SlideTransition(
              position: _slideAnim,
              child: const Column(
                children: [
                  Text(
                    'John Doe',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '@johndoe',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          FadeTransition(
            opacity: _fadeAnim,
            child: SlideTransition(
              position: _slideAnim,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StatItem(label: 'Followers', count: '2.1K'),
                  SizedBox(width: 24),
                  StatItem(label: 'Following', count: '180'),
                  SizedBox(width: 24),
                  StatItem(label: 'Likes', count: '10.3K'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 80),
          Stack(
            children: [
              Positioned(
                top: calculate(_carPathAnimation.value).dy - 25,
                left: calculate(_carPathAnimation.value).dx - 30,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20)
                  ),
                  width: 34,
                  height: 34,
                  child: const Icon(
                    Icons.directions_bike,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
              AnimatedBuilder(
                animation: _carPathController,
                builder: (context, child) {
                  return CustomPaint(
                    foregroundPainter: PathPainter(),
                    size: Size(size.width, 250),
                    // painter: PathPainter(
                    //   // animationValue: _iconPathController.value,
                    // ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Offset calculate(double value) {
    PathMetrics pathMetrics = carPath.computeMetrics();
    PathMetric pathMetric = pathMetrics.elementAt(0);
    value = pathMetric.length * value;
    Tangent pos = pathMetric.getTangentForOffset(value)!;
    return pos.position;
  }


  @override
  void dispose() {
    _profileAnimController.dispose();
    _carPathController.dispose();
    super.dispose();
  }

}

