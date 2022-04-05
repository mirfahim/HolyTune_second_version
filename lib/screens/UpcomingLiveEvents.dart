import 'dart:convert';
import 'dart:io';

import 'package:HolyTune/providers/AppStateNotifier.dart';
import 'package:HolyTune/utils/my_colors.dart';
import 'package:HolyTune/widgets/CustomBottomBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';
import 'package:new_version/new_version.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class UpcomingPage extends StatefulWidget {
  const UpcomingPage({Key key}) : super(key: key);

  @override
  _UpcomingPageState createState() => _UpcomingPageState();
}

class _UpcomingPageState extends State<UpcomingPage> {
  String newDate;
  AppStateNotifier appState;

  @override
  void initState() {
    //_checkVersion();
    super.initState();

    final dateFormatter = DateFormat('yyyy-MM-dd');
    final dateString = dateFormatter.format(DateTime.now());
    newDate = dateString;
  }

  var newVersion;
  var status;
  var serverVersion;

  void _checkVersion() async {
    HttpClient()
        .getUrl(Uri.parse(
            'https://holytune.s3.ap-southeast-1.amazonaws.com/version.txt'))
        .then((HttpClientRequest request) {
      return request.close();
    }).then((HttpClientResponse response) {
      response.transform(const Utf8Decoder()).listen((s) {
        serverVersion = s;
        print("__________NEW____SERVER_____VERSION____$serverVersion");
      });
    });

    final newVersion = NewVersion(
      iOSId: "com.holytune.app",
      androidId: "com.holytune.app",
    );
    final status = await newVersion.getVersionStatus();
    if (status.localVersion == serverVersion) {
      print("deviceVersion " + status.localVersion);
    } else {
      print("deviceVersion " + status.localVersion);
      print("storeVersion " + status.storeVersion);
      print("serverVersion " + serverVersion);
      newVersion.showUpdateDialog(
          context: context,
          dialogText:
              "Update your Holytune App from Google Playstore and Appbajar",
          dismissButtonText: "AppBajar",
          dismissAction: () async {
            const url = 'https://appbajar.com/en/app/com.holytune.app';

            if (await canLaunch(url)) {
              await launch(url, forceWebView: true);
            } else {
              throw 'Could not launch $url';
            }
          },
          updateButtonText: "Playstore",
          versionStatus: status);
    }
  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    print('height:${_height}');
    print('width:${_width}');

    appState = Provider.of<AppStateNotifier>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, bottom: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Upcoming Live Show",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: _width / 20)),
                Spacer(),
                Icon(
                  Icons.live_tv_outlined,
                  color: Colors.red,
                ),
                SizedBox(
                  width: _width / 36,
                ),
                Text(
                  'Live',
                  style: TextStyle(color: Colors.red),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
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
                                    borderRadius: BorderRadius.circular(10),
                                    //shape: BoxShape.circle,
                                    image: const DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage(
                                          'assets/images/singer02.jpg',
                                        ))),
                                /* child: Image.asset(
                                    'assets/images/singer02.jpg',
                                    fit: BoxFit.contain,
                                    height: 100,
                                    width: 100,
                                  ),*/
                              ),
                              SizedBox(width: _width / 36),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: Text(
                                      'সর্বশেষ নবী মুহাম্মাদ',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      'সর্বশেষ নবী মুহাম্মাদ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white10.withOpacity(0.5),
                                        fontWeight: FontWeight.normal,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'পৃথিবীতে কতো ঘটনা ঘটে যায় অনেক কিছু অমীমাংসিত থেকে যায়। গ্রামে দুই বন্ধু মকবুল আর জিলন পাশের গ্রামের সপ্ন',
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
                                child: const Icon(
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
          )
        ],
      ),
    );
  }
}
