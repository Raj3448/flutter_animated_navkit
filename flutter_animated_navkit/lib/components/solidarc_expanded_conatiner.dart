import 'package:flutter/material.dart';
import '../model/bottom_nav_item.dart';

class SolidArcExpandedContainer extends StatelessWidget {
  final Animation<double> expandAnimation;
  final Animation<double> iconScaleAnimation;
  final AnimationController iconAnimationController;
  final List<MenuIconItem> icons;
  final double iconSpacing;
  final bool applyMenuIconSwitcher;

  const SolidArcExpandedContainer({
    super.key,
    required this.expandAnimation,
    required this.iconAnimationController,
    required this.iconScaleAnimation,
    required this.icons,
    required this.iconSpacing,
    required this.applyMenuIconSwitcher,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 90,
      left: 0,
      right: 0,
      child: AnimatedBuilder(
        animation: expandAnimation,
        builder: (context, child) {
          return SizedBox(
  height: 100,
  width: MediaQuery.of(context).size.width,
  child: Stack(
    alignment: Alignment.bottomCenter,
    children: [
      CustomPaint(
        size: Size.infinite,
        painter: _ArcBackgroundPainter(),
      ),
      Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(icons.length, (index) {
            final iconItem = icons[index];
            final delay = index * 0.1;
            final anim = CurvedAnimation(
              parent: iconAnimationController,
              curve: Interval(
                delay,
                delay + 0.5,
                curve: Curves.easeOutBack,
              ),
            );

            return ScaleTransition(
              scale: anim,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: iconSpacing / 2),
                child: GestureDetector(
                  onTap: iconItem.onTap,
                  child: iconItem.widget,
                ),
              ),
            );
          }),
        ),
      ),
    ],
  ),
);
        },
      ),
    );
  }
}

class _ArcBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 6);

    final path = Path();
    final width = size.width;
    final height = size.height;

    path.moveTo(0, height);
    path.quadraticBezierTo(width / 2, -40, width, height); // Arc curve
    path.lineTo(width, height);
    path.lineTo(0, height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
