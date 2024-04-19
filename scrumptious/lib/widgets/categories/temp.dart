// import 'package:flutter/material.dart';
// import 'package:scrumptious/data/dummy_data.dart';
// import 'package:scrumptious/models/category.dart';

// class CategoryGridItem extends StatefulWidget {
//   const CategoryGridItem({
//     Key? key,
//     required this.mdlCategory,
//     required this.onSelectCategory,
//   }) : super(key: key);

//   final Category mdlCategory;
//   final void Function() onSelectCategory;

//   @override
//   _CategoryGridItemState createState() => _CategoryGridItemState();
// }

// class _CategoryGridItemState extends State<CategoryGridItem> {
//   OverlayEntry? _overlayEntry;

//   List<String> _getMeals(BuildContext context) {
//     List<String> arrMealTitles = [];
//     for (final mdlMeal in dummyMeals) {
//       if (mdlMeal.arrCategories.contains(widget.mdlCategory.strId)) {
//         arrMealTitles.add(mdlMeal.strTitle);
//       }
//     }
//     return arrMealTitles;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onLongPressStart: _showPopup,
//       onLongPressEnd: _hidePopup,
//       onTap: widget.onSelectCategory,
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(16),
//           gradient: LinearGradient(
//             colors: [
//               widget.mdlCategory.colour.withOpacity(0.55),
//               widget.mdlCategory.colour.withOpacity(0.9),
//             ],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: Text(
//           widget.mdlCategory.strTitle,
//           style: Theme.of(context).textTheme.titleLarge!.copyWith(
//                 color: Theme.of(context).colorScheme.onBackground,
//               ),
//         ),
//       ),
//     );
//   }

// void _showPopup(LongPressStartDetails details) {
//   final RenderBox overlay = Overlay.of(context)!.context.findRenderObject() as RenderBox;
//   final Offset topLeftPosition = overlay.localToGlobal(Offset.zero);

//   _overlayEntry = OverlayEntry(
//     builder: (context) {
//       return LayoutBuilder(
//         builder: (context, constraints) {
//           double maxWidth = MediaQuery.of(context).size.width * 0.8; // Set maximum width to 80% of screen width
//           double maxHeight = MediaQuery.of(context).size.height * 0.6; // Set maximum height to 60% of screen height

//           double popupWidth = constraints.maxWidth + 16; // Add padding
//           double popupHeight = constraints.maxHeight + 16; // Add padding

//           // Limit the popup size to the maximum width and height
//           popupWidth = popupWidth > maxWidth ? maxWidth : popupWidth;
//           popupHeight = popupHeight > maxHeight ? maxHeight : popupHeight;

//           // Calculate the position of the popup relative to the screen's bounds
//           double left = details.globalPosition.dx - topLeftPosition.dx;
//           double top = details.globalPosition.dy - topLeftPosition.dy;

//           // Adjust the position if it exceeds the screen boundaries
//           if (left + popupWidth > MediaQuery.of(context).size.width) {
//             left = MediaQuery.of(context).size.width - popupWidth;
//           }
//           if (top + popupHeight > MediaQuery.of(context).size.height) {
//             top = MediaQuery.of(context).size.height - popupHeight;
//           }

//           return Positioned(
//             left: left,
//             top: top,
//             child: Material(
//               color: Colors.transparent,
//               child: Container(
//                 width: popupWidth,
//                 height: popupHeight,
//                 padding: EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Meals in ${widget.mdlCategory.strTitle}',
//                       style: TextStyle(color: Colors.black),
//                     ),
//                     for (final strTitle in _getMeals(context)) Text(strTitle),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       );
//     },
//   );

//   Overlay.of(context)?.insert(_overlayEntry!);
// }




//   void _hidePopup(LongPressEndDetails details) {
//     _overlayEntry?.remove();
//   }

//   @override
//   void dispose() {
//     _overlayEntry?.remove();
//     super.dispose();
//   }
// }
