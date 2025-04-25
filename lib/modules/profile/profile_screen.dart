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
  late AnimationController _carPathController;
  late Animation _carPathAnimation;
  late Path carPath;

  @override
  void initState() {
    super.initState();

    _carPathController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _carPathAnimation = Tween(begin: 0.0,end: 1.0).animate(_carPathController);
   _carPathController.forward();


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
          const CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage('assets/images/post1.jpeg'),
          ),
          const SizedBox(height: 12),
          const Column(
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
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StatItem(label: 'Followers', count: '2.1K'),
              SizedBox(width: 24),
              StatItem(label: 'Following', count: '180'),
              SizedBox(width: 24),
              StatItem(label: 'Likes', count: '10.3K'),
            ],
          ),
          const SizedBox(height: 80),
          Stack(
            children: [
              AnimatedBuilder(
                  animation: _carPathController,
                builder: (context , _) {
                  return Positioned(
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
                  );
                }
              ),
              CustomPaint(
                foregroundPainter: PathPainter(),
                size: Size(size.width, 250),
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
    _carPathController.dispose();
    super.dispose();
  }

}

