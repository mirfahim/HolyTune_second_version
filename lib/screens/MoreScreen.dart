import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:launch_review/launch_review.dart';
import '../utils/TextStyles.dart';
import '../utils/my_colors.dart';
import '../utils/StringsConst.dart';
import '../i18n/strings.g.dart';

class MoreScreen extends StatefulWidget {
  MoreScreen();
  static String routeName = "aboutapp";

  @override
  AboutAppRouteState createState() => new AboutAppRouteState();
}

class AboutAppRouteState extends State<MoreScreen> {
  PackageInfo packageInfo;

  getPackageInfo() async {
    packageInfo = await PackageInfo.fromPlatform();
    setState(() {});
  }

  openBrowserTab(String url) async {
    await FlutterWebBrowser.openWebPage(
        url: url, androidToolbarColor: MyColors.primary);
  }

  @override
  void initState() {
    getPackageInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text(t.appinfo),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(height: 10),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2),
              ),
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              //color: Colors.white,
              elevation: 2,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(width: 0),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(t.appname,
                                style: TextStyles.title(context).copyWith()),
                          ],
                        ),
                        Spacer(),
                      ],
                    ),
                    Container(height: 10),
                    Row(
                      children: <Widget>[
                        Container(
                            child: Icon(Icons.info, color: MyColors.grey_40),
                            width: 50),
                        Container(width: 15),
                        Text(t.version,
                            style: TextStyles.subhead(context)
                                .copyWith(fontWeight: FontWeight.w500)),
                        Container(width: 10),
                        Text(packageInfo == null ? "" : packageInfo.version,
                            style: TextStyles.subhead(context).copyWith())
                      ],
                    ),
                    Container(height: 20),
                    InkWell(
                      onTap: () {
                        LaunchReview.launch();
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 2),
                        child: Row(
                          children: <Widget>[
                            Container(
                                child: Icon(Icons.rate_review,
                                    color: MyColors.grey_40),
                                width: 50),
                            Container(width: 15),
                            Text(t.rate,
                                style: TextStyles.subhead(context)
                                    .copyWith(fontWeight: FontWeight.w500)),
                            Spacer(),
                            Icon(Icons.navigate_next,
                                size: 25.0, color: MyColors.grey_40),
                          ],
                        ),
                      ),
                    ),
                    Container(height: 20),
                    InkWell(
                      onTap: () {
                        openBrowserTab(StringsConst.ABOUT);
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 2),
                        child: Row(
                          children: <Widget>[
                            Container(
                                child:
                                    Icon(Icons.info, color: MyColors.grey_40),
                                width: 50),
                            Container(width: 15),
                            Text(t.about,
                                style: TextStyles.subhead(context)
                                    .copyWith(fontWeight: FontWeight.w500)),
                            Spacer(),
                            Icon(Icons.navigate_next,
                                size: 25.0, color: MyColors.grey_40),
                          ],
                        ),
                      ),
                    ),
                    Container(height: 20),
                    InkWell(
                      onTap: () {
                        openBrowserTab(StringsConst.TERMS);
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 2),
                        child: Row(
                          children: <Widget>[
                            Container(
                                child: Icon(Icons.chrome_reader_mode,
                                    color: MyColors.grey_40),
                                width: 50),
                            Container(width: 15),
                            Text(t.terms,
                                style: TextStyles.subhead(context)
                                    .copyWith(fontWeight: FontWeight.w500)),
                            Spacer(),
                            Icon(Icons.navigate_next,
                                size: 25.0, color: MyColors.grey_40),
                          ],
                        ),
                      ),
                    ),
                    Container(height: 20),
                    InkWell(
                      onTap: () {
                        openBrowserTab(StringsConst.PRIVACY);
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 2),
                        child: Row(
                          children: <Widget>[
                            Container(
                                child: Icon(Icons.label_important,
                                    color: MyColors.grey_40),
                                width: 50),
                            Container(width: 15),
                            Text(t.privacy,
                                style: TextStyles.subhead(context)
                                    .copyWith(fontWeight: FontWeight.w500)),
                            Spacer(),
                            Icon(Icons.navigate_next,
                                size: 25.0, color: MyColors.grey_40),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
