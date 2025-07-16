
import 'package:flutter/material.dart';
import 'package:flutter_animated_navkit/flutter_animated_navkit.dart';
import 'package:flutter_animated_navkit/model/bottom_nav_item.dart';

class VerticallyExpandedContainer extends StatelessWidget {
  const VerticallyExpandedContainer({
    super.key,
    required this.widget,
    required Animation<double> expandAnimation,
    required AnimationController iconAnimationController,
    required Animation<double> iconScaleAnimation,
    required this.applyMenuIconSwitcher,
  }) : _expandAnimation = expandAnimation, _iconAnimationController = iconAnimationController, _iconScaleAnimation = iconScaleAnimation;

  final AnimatedBottomNavkit widget;
  final Animation<double> _expandAnimation;
  final AnimationController _iconAnimationController;
  final Animation<double> _iconScaleAnimation;
  final bool applyMenuIconSwitcher;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: widget.middleHexagonSize + 60,
      child: SizeTransition(
        sizeFactor: _expandAnimation,
        axis: Axis.vertical,
        axisAlignment: -1.0,
        child: AnimatedBuilder(
          animation: _iconAnimationController,
          builder: (context, child) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInToLinear,
              width: _iconAnimationController.value > 0.6
                  ? widget.expandedMenuIcons.length * 50
                  : widget.middleHexagonSize * 1.5,
              height: 55,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: const Color.fromARGB(181, 46, 41, 98),
                borderRadius: BorderRadius.circular(
                    _iconAnimationController.value > 0.6 ? 20 : 20),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 10),
                ],
              ),
              child: _iconAnimationController.value < 0.5
                  ? CircleAvatar(
                      radius: widget.middleHexagonSize / 3,
                      backgroundColor: widget.middleHexagonalNotchColor,
                    )
                  : ScaleTransition(
                      scale: _iconScaleAnimation,
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Row(
                            mainAxisSize: MainAxisSize.min,
                            spacing: widget.expandedMenuIconSpacing,
                            children: List.generate(
                              widget.expandedMenuIcons.length,
                              (index) => AnimatedExpandedMenuSwitcher(
                                applyMenuIconSwitcher:
                                    applyMenuIconSwitcher,
                                middleHexagonSize:
                                    widget.middleHexagonSize,
                                middleHexagonalNotchColor:
                                    widget.middleHexagonalNotchColor,
                                expandedMenuIconItem:
                                    widget.expandedMenuIcons[index],
                              ),
                            )),
                      ),
                    ),
            );
          },
        ),
      ),
    );
  }
}

class AnimatedExpandedMenuSwitcher extends StatelessWidget {
  final bool applyMenuIconSwitcher;
  final double middleHexagonSize;
  final Color middleHexagonalNotchColor;
  final MenuIconItem expandedMenuIconItem;
  const AnimatedExpandedMenuSwitcher({
    required this.applyMenuIconSwitcher,
    super.key,
    required this.middleHexagonSize,
    required this.middleHexagonalNotchColor,
    required this.expandedMenuIconItem,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 500),
      transitionBuilder: (child, animation) {
        return ScaleTransition(
          scale: animation,
          child: child,
        );
      },
      child: !applyMenuIconSwitcher
          ? CircleAvatar(
              key: ValueKey<bool>(applyMenuIconSwitcher),
              radius: middleHexagonSize / 3,
              backgroundColor: middleHexagonalNotchColor,
            )
          : GestureDetector(
            onTap: expandedMenuIconItem.onTap,
            child: expandedMenuIconItem.widget),
    );
  }
}
