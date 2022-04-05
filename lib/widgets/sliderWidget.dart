import 'package:HolyTune/providers/SliderImageProvider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CarouselWithIndicatorDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CarouselWithIndicatorState();
  }
}

class _CarouselWithIndicatorState extends State<CarouselWithIndicatorDemo> {
  int _current = 0;
  final List<String> imgList = [
    'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
    'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
    'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
    'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<SliderImageProvider>(
        builder: (context, sliderImageProvider, _) {
          return Stack(children: [
            sliderImageProvider.imageList.length == 0
                ? CarouselSlider(
              items: [
                // 2nd Image of Slider
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    // borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: AssetImage("assets/images/singer01.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                //3rd Image of Slider
                Container(
                  width: MediaQuery.of(context).size.width,
                  //margin: EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    // borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: AssetImage("assets/images/singer02.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                //4th Image of Slider
                Container(
                  width: MediaQuery.of(context).size.width,
                  // margin: EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    // borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                        image: AssetImage("assets/images/Archive/Poro.jpg"),
                        fit: BoxFit.cover),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    // borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: AssetImage("assets/images/Archive/Quran.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                //3rd Image of Slider
                Container(
                  width: MediaQuery.of(context).size.width,
                  //margin: EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    // borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: AssetImage("assets/images/Archive/Janaza.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                //4th Image of Slider
                Container(
                  width: MediaQuery.of(context).size.width,
                  // margin: EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    // borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                        image: AssetImage("assets/images/singer03.jpg"),
                        fit: BoxFit.cover),
                  ),
                ),
                //5th Image of Slider
              ],
              options: CarouselOptions(
                  height: 580.0,
                  enlargeCenterPage: true,
                  autoPlay: true,
                  aspectRatio: 16 / 9,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  viewportFraction: 1,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  }),
            )
                : CarouselSlider.builder(
              itemCount: sliderImageProvider.imageList.length,
              itemBuilder: (_, index, __) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  // margin: EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    // borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: NetworkImage(
                          sliderImageProvider.imageList[index].thumbnail),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
              options: CarouselOptions(
                  height: 570.0,
                  enlargeCenterPage: true,
                  autoPlay: true,
                  aspectRatio: 16 / 9,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  viewportFraction: 1,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  }),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 15,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: sliderImageProvider.imageList.length == 0
                    ? imgList.map((url) {
                  int index = imgList.indexOf(url);
                  return Container(
                    width: 5.0,
                    height: 5.0,
                    margin:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _current == index
                          ? Colors.white
                          : Color.fromRGBO(0, 0, 0, 0.4),
                    ),
                  );
                }).toList()
                    : sliderImageProvider.imageList.map((url) {
                  int index = sliderImageProvider.imageList.indexOf(url);
                  return Container(
                    width: 5.0,
                    height: 5.0,
                    margin:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _current == index
                          ? Colors.white
                          : Color.fromRGBO(0, 0, 0, 0.4),
                    ),
                  );
                }).toList(),
              ),
            ),
          ]);
        });
  }
}
