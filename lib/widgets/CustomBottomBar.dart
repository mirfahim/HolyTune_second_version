// import 'package:HolyTune/providers/AppStateNotifier.dart';
// import 'package:HolyTune/screens/HomePage.dart';
// import 'package:HolyTune/screens/SearchScreen.dart';
// import 'package:HolyTune/screens/TabBarPage.dart';
// import 'package:HolyTune/screens/UpcomingLiveEvents.dart';
// import 'package:HolyTune/screens/musicPageTab.dart';
// import 'package:HolyTune/utils/my_colors.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class CustomBottomNavBar extends StatefulWidget {
//   @override
//   _BottomNavBarV2State createState() => _BottomNavBarV2State();
// }

// class _BottomNavBarV2State extends State<CustomBottomNavBar> {
//   AppStateNotifier appManager;
//   int currentIndex = 0;
//   Color color1 = HexColor("b74093");
//   setBottomBarIndex(index) {
//     setState(() {
//       currentIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     appManager = Provider.of<AppStateNotifier>(context);
//     final Size size = MediaQuery.of(context).size;
//     return Container(
//       width: size.width,
//       height: 55,
//       color: appManager.isDarkModeOn == true
//           ? Color.fromARGB(221, 216, 10, 10)
//           : MyColors.softBlueColor,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           IconButton(
//             //  icon: Image.asset('assets/icon/hom.png',),
//             onPressed: () {
//               setBottomBarIndex(0);
//               Route route = MaterialPageRoute(builder: (c) => HomePage());
//               Navigator.pushReplacement(context, route);
//             },
//             //  splashColor: Colors.white,
//           ),
//           IconButton(
//               icon: Icon(
//                 Icons.queue_music_outlined,
//                 color: currentIndex == 1 ? Colors.blue : Colors.blue,
//               ),
//               onPressed: () {
//                 setBottomBarIndex(1);
//                 Route route = MaterialPageRoute(builder: (c) => MusicTabPage());
//                 Navigator.pushReplacement(context, route);
//               }),
//           IconButton(
//               icon: Icon(
//                 Icons.live_tv_sharp,
//                 color: currentIndex == 2 ? Colors.blue : Colors.blue,
//               ),
//               onPressed: () {
//                 setBottomBarIndex(2);
//                 Route route = MaterialPageRoute(builder: (c) => UpcomingPage());
//                 Navigator.pushReplacement(context, route);
//               }),
//           // Container(
//           //   width: size.width * 0.20,
//           // ),

//           IconButton(
//               icon: Icon(
//                 Icons.video_collection,
//                 color: currentIndex == 3 ? Colors.blue : Colors.grey.shade400,
//               ),
//               onPressed: () {
//                 Route route =
//                     MaterialPageRoute(builder: (c) => MyTabHomePage());
//                 Navigator.pushReplacement(context, route);
//               }),
//           IconButton(
//               icon: Icon(
//                 Icons.search,
//                 color: currentIndex == 4 ? Colors.blue : Colors.grey.shade400,
//               ),
//               onPressed: () {
//                 setBottomBarIndex(4);
//                 Route route = MaterialPageRoute(builder: (c) => SearchScreen());
//                 Navigator.pushReplacement(context, route);
//               }),
//         ],
//       ),
//     );
//   }
// }

// class BNBCustomPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint paint = new Paint()
//       ..color = HexColor("#E5EDF1")
//       ..style = PaintingStyle.fill;

//     Path path = Path();
//     path.moveTo(0, 20); // Start
//     path.quadraticBezierTo(size.width * 0.20, 0, size.width * 0.35, 0);
//     path.quadraticBezierTo(size.width * 0.40, 0, size.width * 0.40, 20);
//     path.arcToPoint(Offset(size.width * 0.60, 20),
//         radius: Radius.circular(20.0), clockwise: false);
//     path.quadraticBezierTo(size.width * 0.60, 0, size.width * 0.65, 0);
//     path.quadraticBezierTo(size.width * 0.80, 0, size.width, 20);
//     path.lineTo(size.width, size.height);
//     path.lineTo(0, size.height);
//     path.lineTo(0, 20);
//     canvas.drawShadow(path, Colors.black, 5, true);
//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return false;
//   }
// }

// class HexColor extends Color {
//   static int _getColorFromHex(String hexColor) {
//     hexColor = hexColor.toUpperCase().replaceAll("#", "");
//     if (hexColor.length == 6) {
//       hexColor = "FF" + hexColor;
//     }
//     return int.parse(hexColor, radix: 16);
//   }

//   HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
// }
