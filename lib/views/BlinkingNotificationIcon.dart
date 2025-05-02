// import 'dart:async';
// import 'package:flutter/material.dart';
//
// class BlinkingNotificationIcon extends StatefulWidget {
//   @override
//   _BlinkingNotificationIconState createState() => _BlinkingNotificationIconState();
// }
//
// class _BlinkingNotificationIconState extends State<BlinkingNotificationIcon> {
//   bool _showDot = true; // Відображення точки
//
//   @override
//   void initState() {
//     super.initState();
//     // Таймер для блимання кожні n секунду
//     Timer.periodic(Duration(seconds: 3000), (timer) {
//       setState(() {
//         _showDot = !_showDot; // Зміна прозорості точки
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         IconButton(
//           icon: Icon(Icons.notifications, color: Colors.black, size: 28),
//           onPressed: () {
//             // Дія при натисканні відкрити список сповіщень
//           },
//         ),
//         // Анімована червона точка
//         Positioned(
//           right: 8,
//           top: 8,
//           child: AnimatedOpacity(
//             duration: Duration(milliseconds: 5000), // Гладке зникнення і поява
//             opacity: _showDot ? 1.0 : 0.0, // Зміна видимості
//             child: Container(
//               width: 12,
//               height: 12,
//               decoration: BoxDecoration(
//                 color: Colors.red,
//                 shape: BoxShape.circle,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
