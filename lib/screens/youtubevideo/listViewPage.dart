import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'getData.dart';

class ListViewPage extends StatefulWidget {
  const ListViewPage({Key key}) : super(key: key);
  @override
  State<ListViewPage> createState() => _ListViewPageState();
}

class _ListViewPageState extends State<ListViewPage> {
// late
  YoutubePlayerController _controller;
  String videoTitle = "Olama Tolaba";
  String videoArtist = 'Kalarab Sommilito Gojol';
  String videoUrl = "https://www.youtube.com/embed/f5c1UhQdmPU";

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(videoUrl).toString(),
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
      ),
    );
  }

  void setUrl(String url) {
    setState(() {
      videoUrl = url;
    });
  }

  @override
  Widget build(BuildContext context) {
    // context.read<getData>().getListData();
    return ChangeNotifierProvider<GetData>(
      create: (context) => GetData(),
      child: Scaffold(
          body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min, //test
          children: [
            YoutubePlayer(
              controller: _controller,
              liveUIColor: Colors.amber,
              aspectRatio: 16 / 9,
            ),
            Container(
                height: 70,
                width: 500,
                child: Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Column(
                    children: [
                      Flexible(
                        child: Text(
                          videoTitle,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          videoArtist,
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xFF6E6E6E),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Text("$artist")
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                  color: Color(0xFF1F1F1F),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                  ),
                )),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      "Popular Islamic Videos",
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Icon(Icons.widgets_outlined),
                ],
              ),
            ),
            Divider(),
            Consumer<GetData>(
              builder: (context, yGetData, child) {
                // print(yGetData.data.length);
                // return Text("dgfgfd");
                return yGetData.data.isEmpty
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemCount: yGetData.data.length,
                        itemBuilder: (BuildContext context, index) {
                          return ListTile(
                            leading: Image.network(
                              yGetData.data[index].thumbnail.toString(),
                            ),
                            title: Text(
                              yGetData.data[index].title,
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFFD1D1D1),
                              ),
                            ),
                            subtitle: Text(
                              yGetData.data[index].artist,
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF6E6E6E),
                              ),
                            ),
                            trailing: Icon(Icons.more_vert_outlined),
                            onTap: () {
                              _controller.load(YoutubePlayer.convertUrlToId(
                                      yGetData.data[index].url)
                                  .toString());
                              setState(
                                () {
                                  videoUrl =
                                      yGetData.data[index].url.toString();
                                  videoTitle =
                                      yGetData.data[index].title.toString();
                                  videoArtist = yGetData.data[index].artist;
                                },
                              );
                            },
                          );
                        },
                      );
              },
            ),
          ],
        ),
      )),
    );
  }

  // Widget getListView() {
  //   // context.read<getData>().getListData();
  //   return ;
  // }

  Future<void> _onRefresh() async {
    await Future.delayed(Duration(seconds: 0));
    await context.read<GetData>().getListData();
    setState(() {});
  }
}
