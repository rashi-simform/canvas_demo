import 'package:canvas_demo/views/hexagonal_box.dart';
import 'package:flutter/material.dart';

class FlowMenu extends StatefulWidget {
  const FlowMenu({super.key});

  @override
  State<FlowMenu> createState() => _FlowMenuState();
}

class _FlowMenuState extends State<FlowMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController menuAnimation;
  IconData lastTapped = Icons.notifications;
  final List<IconData> menuItems = <IconData>[
    Icons.home,
    Icons.notifications,
    Icons.edit,
    Icons.menu,
    // Icons.settings,
  ];

  void _updateMenu(IconData icon) {
    if (icon != Icons.edit) {
      setState(() => lastTapped = icon);
    }
  }

  @override
  void initState() {
    super.initState();
    menuAnimation = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
  }

  Widget flowMenuItem(IconData icon, double buttonDiameter) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        width: buttonDiameter,
        height: buttonDiameter,
        child: CustomPaint(
          size: Size(buttonDiameter, buttonDiameter),
          painter: HexagonPainter(),
          child: IconButton(
            icon: Icon(icon, size: 24),
            onPressed: () {
              _updateMenu(icon);
              if (menuAnimation.status == AnimationStatus.completed) {
                menuAnimation.reverse();
              } else {
                menuAnimation.forward();
              }
            },
            color: Colors.white,
            iconSize: 30.0,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Flow(
      delegate: FlowMenuDelegate(menuAnimation: menuAnimation),
      children:
          menuItems
              .map<Widget>((IconData icon) => flowMenuItem(icon, 100))
              .toList(),
    );
  }
}

class FlowMenuDelegate extends FlowDelegate {
  FlowMenuDelegate({required this.menuAnimation})
    : super(repaint: menuAnimation);

  final Animation<double> menuAnimation;

  @override
  bool shouldRepaint(FlowMenuDelegate oldDelegate) {
    return menuAnimation != oldDelegate.menuAnimation;
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    double dx = 0.0;
    double dy = 0;
    for (int i = 0; i < context.childCount; ++i) {
      if (i.isEven) {
        dx = context.getChildSize(i)!.width * ((i - 1) * 0.75);
        dy = dy - (40);
      } else {
        final factor = (i * 0.25).toInt();
        dx = context.getChildSize(i)!.width * factor;
        dy = dy - ((i - 2) * 44);
      }
      context.paintChild(
        i,
        transform: Matrix4.translationValues(
          dx * menuAnimation.value + 135,
          dy * menuAnimation.value + 550,
          0,
        ),
      );
    }
  }
}
