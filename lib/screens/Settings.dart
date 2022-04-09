import 'package:HolyTune/database/SharedPreference.dart';
import 'package:HolyTune/models/ScreenArguements.dart';
import 'package:HolyTune/screens/TabBarPage.dart';
import 'package:HolyTune/utils/Alerts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:HolyTune/utils/StringsConst.dart';
import '../providers/AppStateNotifier.dart';
import '../i18n/strings.g.dart';
import '../utils/langs.dart';
import '../utils/my_colors.dart';
import '../utils/TextStyles.dart';
import 'package:package_info/package_info.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';

import 'Downloader.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = "/settings";
  SettingsScreen();

  @override
  SettingsRouteState createState() => new SettingsRouteState();
}

class SettingsRouteState extends State<SettingsScreen> {
  AppStateNotifier appManager;

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
    appManager = Provider.of<AppStateNotifier>(context);
    String language =
        appLanguageData[AppLanguage.values[appManager.preferredLanguage]]
            ['name'];

    return Scaffold(
     appBar: SharedPref.settingAppbar == true ? null : PreferredSize(
       preferredSize: Size.fromHeight(60.0),
       child: Center(
         child: AppBar(
           elevation: 0,
           leading: GestureDetector(
             onTap: (){
               Route route =
               MaterialPageRoute(builder: (c) => MyTabHomePage());
               Navigator.pushReplacement(context, route);
             },
               child: Icon(Icons.home)),
           backgroundColor: appManager.isDarkModeOn != true ? MyColors.softBlueColor : Colors.black54,
           actions: <Widget>[
             IconButton(
                 icon: Icon(Icons.cloud_download),
                 onPressed: (() {
                   Navigator.pushNamed(context, Downloader.routeName,
                       arguments: ScreenArguements(
                         position: 0,
                         items: null,
                       ));
                 })),
             IconButton(
                 icon: Icon(Icons.settings),
                 onPressed: (() {
                   Route route =
                   MaterialPageRoute(builder: (c) => SettingsScreen());
                   Navigator.pushReplacement(context, route);
                 }))
           ],
         ),
       ),
     ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: ListTile(
                title: Text("Settings",
                    style: TextStyles.headline(context)
                        .copyWith(fontWeight: FontWeight.bold, fontSize: 20)),
              ),
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            ),
            Divider(height: 1),
            InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        scrollable: true,
                        title: Text(t.chooseapplanguage),
                        content: Container(
                          height: 150.0,
                          width: 400.0,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: appLanguageData.length,
                            itemBuilder: (BuildContext context, int index) {
                              var selected =
                                  appLanguageData[AppLanguage.values[index]]
                                          ['name'] ==
                                      language;
                              return ListTile(
                                trailing: selected
                                    ? Icon(Icons.check)
                                    : Container(
                                        height: 0,
                                        width: 0,
                                      ),
                                title: Text(
                                    appLanguageData[AppLanguage.values[index]]
                                        ['name']),
                                onTap: () {
                                  // appManager.setAppLanguage(index);
                                  // Navigator.of(context).pop();
                                },
                              );
                            },
                          ),
                        ),
                      );
                    });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                child: Row(
                  children: <Widget>[
                    Text(t.selectlanguage,
                        style: TextStyles.subhead(context)
                            .copyWith(fontWeight: FontWeight.bold)),
                    Spacer(),
                    Text(language, style: TextStyles.subhead(context)),
                    Container(width: 10)
                  ],
                ),
              ),
            ),
            Divider(height: 0),
            InkWell(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(t.nightmode,
                            style: TextStyles.subhead(context)
                                .copyWith(fontWeight: FontWeight.bold)),
                        Spacer(),
                        Switch(
                          value: appManager.isDarkModeOn,
                          onChanged: (value) {
                            appManager.setAppTheme(value);
                          },
                          activeColor: MyColors.accentDark,
                          inactiveThumbColor: Colors.grey,
                        ),
                      ],
                    ),
                    Container(height: 5)
                  ],
                ),
              ),
            ),
            Divider(height: 0),
            // InkWell(
            //   onTap: () {},
            //   child: Container(
            //     padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: <Widget>[
            //         Row(
            //           children: <Widget>[
            //             Text(t.enablertl,
            //                 style: TextStyles.subhead(context)
            //                     .copyWith(fontWeight: FontWeight.bold)),
            //             Spacer(),
            //             Switch(
            //               value: appManager.isRtlEnabled,
            //               onChanged: (value) {
            //                 print(value);
            //                 appManager.setRtlEnabled(value);
            //               },
            //               activeColor: MyColors.accentDark,
            //               inactiveThumbColor: Colors.grey,
            //             ),
            //           ],
            //         ),
            //         Container(height: 5)
            //       ],
            //     ),
            //   ),
            // ),
            Divider(height: 0),
            Visibility(
              visible: false,
              child: InkWell(
                onTap: () {},
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text("Show Notifications",
                              style: TextStyles.subhead(context)
                                  .copyWith(fontWeight: FontWeight.bold)),
                          Spacer(),
                          Switch(
                            value: appManager.isDarkModeOn,
                            onChanged: (value) {
                              appManager.setAppTheme(value);
                            },
                            activeColor: MyColors.accentDark,
                            inactiveThumbColor: Colors.grey,
                          ),
                        ],
                      ),
                      Container(height: 5)
                    ],
                  ),
                ),
              ),
            ),
            Divider(height: 0),
            Container(height: 25),
            Container(
              child: Text(
                  t.appname +
                      (packageInfo == null ? "" : " v" + packageInfo.version),
                  style: TextStyles.subhead(context)
                      .copyWith(fontWeight: FontWeight.bold)),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            ),
            InkWell(
              onTap: () {
                Alerts.rateAppDialouge(context, "Rate our App", "If you love our App, Take a moment to rate it in Play Store and AppBajar");
                //LaunchReview.launch();
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: Text(t.rate, style: TextStyles.body1(context).copyWith()),
              ),
            ),
            Divider(height: 0),
            InkWell(
              onTap: () {
                openBrowserTab(StringsConst.ABOUT);
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: Text(t.about, style: TextStyles.body1(context).copyWith()),
              ),
            ),
            Divider(height: 0),
            InkWell(
              onTap: () {
                openBrowserTab(StringsConst.TERMS);
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: Text(t.terms, style: TextStyles.body1(context).copyWith()),
              ),
            ),
            Divider(height: 0),
            InkWell(
              onTap: () {
                openBrowserTab(StringsConst.PRIVACY);
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child:
                    Text(t.privacy, style: TextStyles.body1(context).copyWith()),
              ),
            ),
            Divider(height: 0),
            Container(height: 15),
          ],
        ),
      ),
    );
  }
}
