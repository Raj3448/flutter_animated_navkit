import 'package:flutter/material.dart';

class BottomNavItem {
  final IconData? icon;
  final String? label;
  final Widget? widget;

  BottomNavItem({
    this.icon,
    this.label,
    this.widget,
  }) : assert(
          icon != null || widget != null,
          'Either an icon or a widget must be provided for BottomNavItem',
        );
}

class MenuIconItem {
  final VoidCallback onTap;
  final Widget widget;

  MenuIconItem({
    required this.onTap,
    required this.widget,
  });
}

enum ExpandMenuStyle {
  vertical,    // Existing vertically expanding style
  solidArc,    // Upcoming solid arc-style animation
}