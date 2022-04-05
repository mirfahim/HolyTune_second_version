// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';

// class SliderPage extends StatefulWidget {
//   @override
//   _SliderPageState createState() => _SliderPageState();
// }

// class _SliderPageState extends State<SliderPage> {
//   int currentPos = 0;
//   List<String> listPaths = [
//     "assets/images/singer01.jpg",
//     "assets/images/singer01.jpg",
//     "assets/images/singer01.jpg",
//   ];
//   int current = 0;
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: CarouselSlider(
//         items: [
//           // 2nd Image of Slider
//           Container(
//             width: MediaQuery.of(context).size.width,
//             decoration: BoxDecoration(
//               // borderRadius: BorderRadius.circular(8.0),
//               image: DecorationImage(
//                 image: AssetImage("assets/images/singer01.jpg"),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),

//           //3rd Image of Slider
//           Container(
//             width: MediaQuery.of(context).size.width,
//             //margin: EdgeInsets.all(6.0),
//             decoration: BoxDecoration(
//               // borderRadius: BorderRadius.circular(8.0),
//               image: DecorationImage(
//                 image: AssetImage("assets/images/singer02.jpg"),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),

//           //4th Image of Slider
//           Container(
//             width: MediaQuery.of(context).size.width,
//             // margin: EdgeInsets.all(6.0),
//             decoration: BoxDecoration(
//               // borderRadius: BorderRadius.circular(8.0),
//               image: DecorationImage(
//                   image: AssetImage("assets/images/singer03.jpg"),
//                   fit: BoxFit.cover),
//             ),
//           ),

//           //5th Image of Slider
//         ],

//         //Slider Container properties

//         options: CarouselOptions(
//             height: 700.0,
//             enlargeCenterPage: true,
//             autoPlay: true,
//             aspectRatio: 16 / 9,
//             autoPlayCurve: Curves.fastOutSlowIn,
//             enableInfiniteScroll: true,
//             autoPlayAnimationDuration: Duration(milliseconds: 800),
//             viewportFraction: 1,
//             onPageChanged: (index, m) {
//               setState(() {
//                 current = 1;
//               });
//             }),
//       ),
//     );
//   }
// }

// class MyImageView extends StatelessWidget {
//   String imgPath;

//   MyImageView(this.imgPath);

//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Container(
//         margin: EdgeInsets.symmetric(horizontal: 5),
//         child: FittedBox(
//           fit: BoxFit.fill,
//           child: Image.asset(imgPath),
//         ));
//   }
// }
