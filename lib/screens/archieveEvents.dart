import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../providers/live_events.dart';

class ArchivePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return ChangeNotifierProvider<LiveEventController>(
      create: (context) => LiveEventController(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
            automaticallyImplyLeading: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Text("Archive Live",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: _width / 20))),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: _height / 12.12,
            ),
            /* Padding(
              padding: const EdgeInsets.only(left: 20.0, bottom: 20, right: 20),
              child: Text("Archive Live",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: _width / 20)),
            ),*/
            Consumer<LiveEventController>(
              // ignore: missing_return
              builder: (context, value, child) {
                Widget player;
                if (value.ycontroller != null) {
                  player = SizedBox(
                    height: 250,
                    child: YoutubePlayer(
                      controller: value.ycontroller,
                      liveUIColor: Colors.amber,
                      aspectRatio: 16 / 9,
                    ),
                  );
                } else {
                  player = SizedBox.shrink();
                }
                return player;
              },
            ),
            Expanded(
              child: Consumer<LiveEventController>(
                  builder: (context, value, child) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: value.liveList.length,
                    // physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: _height / 52),
                        child: Container(
                          height: _height / 4,
                          margin: EdgeInsets.symmetric(horizontal: _width / 18),
                          decoration: BoxDecoration(
                              color: Colors.white10,
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      height: _height / 10.4,
                                      width: _width / 5.14,
                                      margin: const EdgeInsets.only(top: 5),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          //shape: BoxShape.circle,
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                  value.liveList[index]
                                                      ['thumbnail']
                                                  // 'assets/images/singer02.jpg',
                                                  ))),
                                      /* child: Image.asset(
                                          'assets/images/singer02.jpg',
                                          fit: BoxFit.contain,
                                          height: 100,
                                          width: 100,
                                        ),*/
                                    ),
                                    SizedBox(width: _width / 36),
                                    Flexible(
                                      child: Text(
                                        value.liveList[index]['title'],
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  value.liveList[index]['description'],
                                  maxLines: 2,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white10.withOpacity(0.5),
                                      fontWeight: FontWeight.normal),
                                ),
                                Spacer(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      height: 25,
                                      width: 25,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.blue,
                                      ),
                                      child: Icon(
                                        Icons.slow_motion_video_sharp,
                                        size: 18,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}
