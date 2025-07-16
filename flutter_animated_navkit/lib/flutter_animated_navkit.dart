// ignore_for_file: public_member_api_docs, sort_constructors_first

/// A highly customizable animated bottom navigation bar for Flutter apps.
/// 
/// - Supports a central animated hexagon notch button.
/// - Allows expansion into a vertical or arc-based menu.
/// - Integrates smooth animations and configurable theming.
/// 
/// Inspired by modern navigation principles, best suited for apps needing
/// a playful and interactive bottom navigation UI.
library;
import './animated_bottom_navkit.dart';


class AnimatedBottomNavkit extends StatefulWidget {
  /// List of items to display in the navigation bar.
  ///
  /// Each [BottomNavItem] must contain either an `icon` or a `widget`.
  final List<BottomNavItem> items;

  /// The index of the currently selected navigation item.
  final int currentIndex;

  /// Called when a navigation item is tapped, returns the selected index.
  final Function(int) onTap;

  /// Background color of the bottom navigation bar.
  final Color barBackgroundColor;

  /// Shadow color applied beneath the navigation bar.
  final Color barShadowColor;

  /// Elevation (blur radius) of the shadow under the navigation bar.
  final double barElevation;

  /// Border radius of the bottom navigation bar.
  final double barBorderRadius;

  /// Color of the central hexagonal button (middle notch).
  final Color middleHexagonalNotchColor;

  /// Width and height of the central hexagonal notch.
  final double middleHexagonSize;

  /// Shadow elevation of the hexagon.
  final double middleHexagonElevation;

  /// Size of the icon inside the middle hexagonal button.
  final double middleHexagonIconSize;

  /// Color used for the active navigation icon and label.
  final Color activeColor;

  /// Color used for inactive navigation icons and labels.
  final Color inactiveColor;

  /// Optional background color behind the active icon.
  ///
  /// If `null`, a default semi-transparent active color is used.
  final Color? activeIconBackgroundColor;

  /// Background color behind inactive icons.
  ///
  /// Defaults to `Colors.transparent`.
  final Color? inactiveIconBackgroundColor;

  /// Duration for hexagon rotation animation during menu toggle.
  final Duration hexagonRotationDuration;

  /// Duration for expanding and collapsing the expanded menu.
  final Duration menuExpandDuration;

  /// Spacing between icons in the expanded menu.
  final double expandedMenuIconSpacing;

  /// Whether to show the middle notch (hexagon) button.
  ///
  /// Must be `true` for even number of items. When `false`, a minimum of 3 items is required.
  final bool showMiddleNotch;

  /// List of icons that will appear in the expanded menu.
  ///
  /// Only applicable if [showMiddleNotch] is `true`.
  final List<MenuIconItem> expandedMenuIcons;

  // final ExpandMenuStyle expandMenuStyle;

  AnimatedBottomNavkit({
    Key? key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.expandedMenuIconSpacing = 10,
    this.barBackgroundColor = Colors.white,
    this.barShadowColor = Colors.black12,
    this.barElevation = 10.0,
    this.barBorderRadius = 20.0,
    this.middleHexagonalNotchColor = const Color.fromARGB(255, 65, 211, 255),
    this.middleHexagonSize = 50.0,
    this.middleHexagonElevation = 10.0,
    this.middleHexagonIconSize = 24.0,
    this.activeColor = Colors.blue,
    this.inactiveColor = Colors.grey,
    this.activeIconBackgroundColor,
    this.inactiveIconBackgroundColor = Colors.transparent,
    this.hexagonRotationDuration = const Duration(milliseconds: 500),
    this.menuExpandDuration = const Duration(milliseconds: 300),
    this.expandedMenuIcons = const [],
    this.showMiddleNotch = true,
    // this.expandMenuStyle = ExpandMenuStyle.vertical,
  })  : assert(
          showMiddleNotch
              ? items.length > 1 && items.length.isEven
              : items.length >= 3,
          showMiddleNotch
              ? 'When middle notch is enabled, items.length must be at least 2 and even for symmetry.'
              : 'Bottom navigation must contain at least 3 items.',
        ),
        assert(
          currentIndex >= 0 && currentIndex < items.length,
          'currentIndex is out of bounds of the items list',
        ) {
    for (var item in items) {
      if (item.icon == null && item.widget == null) {
        throw ArgumentError(
          'Each BottomNavItem must contain either an icon or a widget.',
        );
      }
    }
  }

  @override
  State<AnimatedBottomNavkit> createState() => _AnimatedBottomNavkitState();
}

class _AnimatedBottomNavkitState extends State<AnimatedBottomNavkit>
    with TickerProviderStateMixin {
  bool isExpanded = false;
  late AnimationController _expandController;
  late AnimationController _rotationController;
  late AnimationController _iconAnimationController;

  late Animation<double> _expandAnimation;
  late Animation<double> _iconScaleAnimation;
  bool applyMenuIconSwitcher = false;

  //For the animated background of the icon
  List<GlobalKey> _iconKeys = [];
  Offset? selectedIconOffset;

  /// This is used to animate the background of the icon

  @override
  void initState() {
    super.initState();

    _expandController = AnimationController(
      vsync: this,
      duration: widget.menuExpandDuration,
    );
    _expandAnimation = CurvedAnimation(
      parent: _expandController,
      curve: Curves.easeInOut,
    );

    _rotationController = AnimationController(
      vsync: this,
      duration: widget.hexagonRotationDuration,
    );

    _iconAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _iconScaleAnimation = CurvedAnimation(
      parent: _iconAnimationController,
      curve: Curves.easeInToLinear,
    )..addStatusListener((status) {
        setState(() {
          applyMenuIconSwitcher = status == AnimationStatus.completed;
        });
      });

    _iconKeys = List.generate(widget.items.length, (_) => GlobalKey());

    // 🔽 This ensures it runs after layout
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _findPositionForMovableBgContainer(widget.currentIndex);
    });
  }

  void toggleMenu() {
    setState(() {
      isExpanded = !isExpanded;
      if (isExpanded) {
        _expandController.forward();
        _rotationController.forward();
        _iconAnimationController.forward();
      } else {
        _iconAnimationController.reverse();
        _expandController.reverse();
        _rotationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _expandController.dispose();
    _rotationController.dispose();
    _iconAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // Animated expanding upper area
        if (widget.showMiddleNotch && isExpanded) _getExpandedContainer(),

        // Main bottom bar
        Positioned(
          bottom: 24,
          left: 16,
          right: 16,
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              color: widget.barBackgroundColor,
              borderRadius: BorderRadius.circular(widget.barBorderRadius),
              boxShadow: [
                BoxShadow(
                  color: widget.barShadowColor,
                  blurRadius: widget.barElevation,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                if (selectedIconOffset != null)
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 300),
                    left: selectedIconOffset!.dx - 30,
                    bottom: 0,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: widget.activeIconBackgroundColor ??
                            widget.activeColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(
                        widget.items.length + (widget.showMiddleNotch ? 1 : 0),
                        (index) {
                      if (widget.showMiddleNotch &&
                          index == widget.items.length ~/ 2) {
                        return const SizedBox(
                            width: 50); // Space for middle notch
                      }
                      int actualIndex = widget.showMiddleNotch &&
                              index > widget.items.length ~/ 2
                          ? index - 1
                          : index;
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: GestureDetector(
                              onTap: () {
                                _findPositionForMovableBgContainer(actualIndex);

                                widget.onTap(actualIndex);
                                if (isExpanded) {
                                  toggleMenu();
                                }
                              },
                              child: widget.items[actualIndex].widget ??
                                  Icon(
                                    key: _iconKeys[actualIndex],
                                    widget.items[actualIndex].icon,
                                    color: widget.currentIndex == actualIndex
                                        ? widget.activeColor
                                        : widget.inactiveColor,
                                  ),
                            ),
                          ),
                          if (widget.items[actualIndex].label != null &&
                              widget.items[actualIndex].label!.isNotEmpty) ...[
                            SizedBox(height: 1),
                            Text(
                              widget.items[actualIndex].label!,
                              style: TextStyle(
                                fontSize: 12,
                                color: widget.currentIndex == actualIndex
                                    ? widget.activeColor
                                    : widget.inactiveColor,
                              ),
                            )
                          ]
                        ],
                      );
                    })),

                // Hexagon center button
                if (widget.showMiddleNotch)
                  Positioned(
                    top: -widget.middleHexagonSize / 2,
                    child: GestureDetector(
                      onTap: toggleMenu,
                      child: Transform.rotate(
                        angle: 1.5708,
                        child: RotationTransition(
                          turns: Tween(begin: 0.0, end: 0.5)
                              .animate(_rotationController),
                          child: HexagonWidget.flat(
                            width: widget.middleHexagonSize,
                            color: widget.middleHexagonalNotchColor,
                            cornerRadius: 10,
                            inBounds: false,
                            child: Center(
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 200),
                                transitionBuilder: (child, animation) {
                                  return RotationTransition(
                                    turns: Tween(begin: 0.0, end: 0.25)
                                        .animate(_rotationController),
                                    child: child,
                                  );
                                },
                                child: Icon(
                                  isExpanded ? Icons.close : Icons.add,
                                  key: ValueKey<bool>(isExpanded),
                                  color: Colors.white,
                                  size: widget.middleHexagonIconSize,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _findPositionForMovableBgContainer(int actualIndex) {
    RenderBox? box =
        _iconKeys[actualIndex].currentContext?.findRenderObject() as RenderBox?;
    if (box != null) {
      final offset = box.localToGlobal(Offset.zero);
      setState(() {
        selectedIconOffset = offset;
      });
    }
  }

  Widget _getExpandedContainer() {
    final expandMenuStyle = ExpandMenuStyle.vertical;
    switch (expandMenuStyle) {
      case ExpandMenuStyle.vertical:
        return VerticallyExpandedContainer(
          widget: widget,
          expandAnimation: _expandAnimation,
          iconAnimationController: _iconAnimationController,
          iconScaleAnimation: _iconScaleAnimation,
          applyMenuIconSwitcher: applyMenuIconSwitcher,
        );

      // case ExpandMenuStyle.solidArc:
      //   return VerticallyExpandedContainer(
      //       widget: widget,
      //       expandAnimation: _expandAnimation,
      //       iconAnimationController: _iconAnimationController,
      //       iconScaleAnimation: _iconScaleAnimation,
      //       applyMenuIconSwitcher: applyMenuIconSwitcher,
      //     );
      case ExpandMenuStyle.solidArc:
        return SolidArcExpandedContainer(
          expandAnimation: _expandAnimation,
          iconAnimationController: _iconAnimationController,
          iconScaleAnimation: _iconScaleAnimation,
          applyMenuIconSwitcher: applyMenuIconSwitcher,
          icons: widget.expandedMenuIcons,
          iconSpacing: widget.expandedMenuIconSpacing,
        );
    }
  }
}
