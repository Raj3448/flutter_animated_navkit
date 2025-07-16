// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';

// RelativeRect calculatePosition(
//   int index,
//   int totalItems,
//   BuildContext context, [
//   Offset? position,
// ]) {
//   final barWidth = MediaQuery.of(context).size.width;

//   if (position != null) {
//     if (kDebugMode) {
//       if (kDebugMode) {
//         print("Calculated Position: (For testing)");
//         print("  barWidth: $barWidth");
//         print("  index: $index");
//         print("  left: ${position.dx}");
//         print("  right: ${position.dy}");
//         print("--------------------------------");
//       }
//     }
//     // return RelativeRect.fromLTRB(position.dx,  0, position.dy, 0);
//   }

//   final middleIndex = totalItems ~/ 2;
//   final itemWidth = (barWidth - 100) / (totalItems - 1);

//   double left;
//   if (index < middleIndex) {
//     left = itemWidth * index + 6;
//   } else {
//     left = itemWidth * index + 6 + 50 - itemWidth;
//   }

//   double right = barWidth - left - itemWidth;

//   if (kDebugMode) {
//     print("Calculated Position:");
//     print("  barWidth: $barWidth");
//     print("  itemWidth: $itemWidth");
//     print("  index: $index");
//     print("  left: $left");
//     print("  right: $right");
//   }

//   return RelativeRect.fromLTRB(left-20, 0, right, 0);
// }
