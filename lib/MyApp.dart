import 'package:HolyTune/screens/TabBarPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/AppStateNotifier.dart';
import './screens/MoodsMediaScreen.dart';
import './screens/MoodsScreen.dart';
import './screens/ArtistProfileScreen.dart';
import './screens/AlbumsMediaScreen.dart';
import './screens/ArtistsScreen.dart';
import './utils/AppTheme.dart';
import './providers/AudioPlayerModel.dart';
import './utils/TextStyles.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import './screens/AddPlaylistScreen.dart';
import './screens/PlaylistMediaScreen.dart';
import './screens/SearchScreen.dart';
import './screens/GenresMediaScreen.dart';
import './screens/MoreScreen.dart';
import './screens/AlbumsScreen.dart';
import './audio_player/player_page.dart';
import './models/CommentsArguement.dart';
import './comments/CommentsScreen.dart';
import './comments/RepliesScreen.dart';
import './screens/Downloader.dart';
import './auth/LoginScreen.dart';
import './auth/RegisterScreen.dart';
import './auth/ForgotPasswordScreen.dart';
import './models/ScreenArguements.dart';
import './service/Firebase.dart';
import './models/Media.dart';
import './i18n/strings.g.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// import 'package:firebase_analytics/observer.dart';

class MyApp extends StatefulWidget {
  const MyApp({
    Key key,
    @required Widget defaultHome,
  })  : _defaultHome = defaultHome,
        super(key: key);

  final Widget _defaultHome;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  AppLifecycleState state;
  AppStateNotifier appState;
  FirebaseAnalytics analytics =
      FirebaseAnalytics.instanceFor(app: Firebase.app());
  final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey(debugLabel: "Main Navigator");

  navigateMedia(Media media) {
    // print("push notification media = " + media.title);
    List<Media> mediaList = [];
    mediaList.add(media);
    Provider.of<AudioPlayerModel>(context, listen: false)
        .preparePlaylist(mediaList, media);
    navigatorKey.currentState.pushNamed(PlayPage.routeName);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    FirebaseMessage(navigateMedia).init();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    //Provider.of<AudioPlayerModel>(context, listen: false).cleanUpResources();
    super.dispose();
  }

  void didChangeAppLifeCycleState(AppLifecycleState appLifecycleState) {
    state = appLifecycleState;
    // print(appLifecycleState);
    // print(":::::::");
  }

  @override
  Widget build(BuildContext context) {
    appState = Provider.of<AppStateNotifier>(context);
    final platform = Theme.of(context).platform;
    return RefreshConfiguration(
      footerTriggerDistance: 15,
      dragSpeedRatio: 0.91,
      headerBuilder: () => MaterialClassicHeader(),
      footerBuilder: () => ClassicFooter(),
      enableLoadingWhenNoData: false,
      shouldFooterFollowWhenNotFull: (state) {
        // If you want load more with noMoreData state ,may be you should return false
        return false;
      },
      // autoLoad: true,
      child: Directionality(
        textDirection:
            appState.isRtlEnabled ? TextDirection.rtl : TextDirection.ltr,
        child: MaterialApp(
          navigatorKey: navigatorKey,
          navigatorObservers: [
            FirebaseAnalyticsObserver(analytics: analytics),
          ],
          localizationsDelegates: [
            GlobalCupertinoLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: [
            Locale("fa", "IR"), // OR Locale('ar', 'AE') OR Other RTL locales
            Locale("en"),
          ],
          locale: appState.isRtlEnabled ? Locale("fa", "IR") : Locale("en"),
          title: 'App',

          home: appState.isLoadingTheme
              ? Center(
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(height: 10),
                        Text(t.appname,
                            style: TextStyles.medium(context).copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 30)),
                        Container(height: 12),
                        Text(t.loadingapp,
                            style: TextStyles.body1(context)
                                .copyWith(color: Colors.grey[500])),
                        Container(height: 50),
                        CircularProgressIndicator()
                      ],
                    ),
                  ),
                )
              : widget._defaultHome,
          debugShowCheckedModeBanner: false,
          theme:
              appState.isDarkModeOn ? AppTheme.lightTheme : AppTheme.darkTheme,
          // ThemeData(primarySwatch: Colors.blue),
          darkTheme: AppTheme.darkTheme,
          // ThemeData(primarySwatch: Colors.blue),
          themeMode: appState.isDarkModeOn ? ThemeMode.dark : ThemeMode.light,
          onGenerateRoute: (settings) {
            if (settings.name == MyTabHomePage.routeName) {
              return MaterialPageRoute(
                builder: (context) {
                  return MyTabHomePage();
                },
              );
            }

            if (settings.name == AddPlaylistScreen.routeName) {
              // Cast the arguments to the correct type: ScreenArguments.
              final ScreenArguements args = settings.arguments;
              return MaterialPageRoute(
                builder: (context) {
                  return AddPlaylistScreen(
                    media: args.items,
                  );
                },
              );
            }

            if (settings.name == PlaylistMediaScreen.routeName) {
              // Cast the arguments to the correct type: ScreenArguments.
              final ScreenArguements args = settings.arguments;
              return MaterialPageRoute(
                builder: (context) {
                  return PlaylistMediaScreen(
                    playlists: args.items,
                  );
                },
              );
            }

            if (settings.name == GenresMediaScreen.routeName) {
              // Cast the arguments to the correct type: ScreenArguments.
              final ScreenArguements args = settings.arguments;
              return MaterialPageRoute(
                builder: (context) {
                  return GenresMediaScreen(
                    genreList: args.itemsList,
                  );
                },
              );
            }

            if (settings.name == AlbumsMediaScreen.routeName) {
              // Cast the arguments to the correct type: ScreenArguments.
              final ScreenArguements args = settings.arguments;
              return MaterialPageRoute(
                builder: (context) {
                  return AlbumsMediaScreen(
                    albums: args.items,
                  );
                },
              );
            }

            if (settings.name == MoodsMediaScreen.routeName) {
              // Cast the arguments to the correct type: ScreenArguments.
              final ScreenArguements args = settings.arguments;
              return MaterialPageRoute(
                builder: (context) {
                  return MoodsMediaScreen(
                    moods: args.items,
                  );
                },
              );
            }

            if (settings.name == ArtistProfileScreen.routeName) {
              // Cast the arguments to the correct type: ScreenArguments.
              final ScreenArguements args = settings.arguments;
              return MaterialPageRoute(
                builder: (context) {
                  return ArtistProfileScreen(
                    artists: args.items,
                  );
                },
              );
            }

            if (settings.name == SearchScreen.routeName) {
              return MaterialPageRoute(
                builder: (context) {
                  return SearchScreen();
                },
              );
            }

            if (settings.name == MoodsScreen.routeName) {
              return MaterialPageRoute(
                builder: (context) {
                  return MoodsScreen();
                },
              );
            }

            if (settings.name == AlbumsScreen.routeName) {
              return MaterialPageRoute(
                builder: (context) {
                  return AlbumsScreen();
                },
              );
            }

            if (settings.name == ArtistsScreen.routeName) {
              return MaterialPageRoute(
                builder: (context) {
                  return ArtistsScreen();
                },
              );
            }

            if (settings.name == CommentsScreen.routeName) {
              // Cast the arguments to the correct type: ScreenArguments.
              final CommentsArguement args = settings.arguments;
              return MaterialPageRoute(
                builder: (context) {
                  return CommentsScreen(
                    item: args.item,
                    commentCount: args.commentCount,
                  );
                },
              );
            }

            if (settings.name == RepliesScreen.routeName) {
              // Cast the arguments to the correct type: ScreenArguments.
              final CommentsArguement args = settings.arguments;
              return MaterialPageRoute(
                builder: (context) {
                  return RepliesScreen(
                    item: args.item,
                    repliesCount: args.commentCount,
                  );
                },
              );
            }

            if (settings.name == LoginScreen.routeName) {
              return MaterialPageRoute(
                builder: (context) {
                  return LoginScreen();
                },
              );
            }

            if (settings.name == RegisterScreen.routeName) {
              return MaterialPageRoute(
                builder: (context) {
                  return RegisterScreen();
                },
              );
            }

            if (settings.name == ForgotPasswordScreen.routeName) {
              return MaterialPageRoute(
                builder: (context) {
                  return ForgotPasswordScreen();
                },
              );
            }

            if (settings.name == PlayPage.routeName) {
              return MaterialPageRoute(
                builder: (context) {
                  return PlayPage();
                },
              );
            }

            if (settings.name == Downloader.routeName) {
              // Cast the arguments to the correct type: ScreenArguments.
              final ScreenArguements args = settings.arguments;
              return MaterialPageRoute(
                builder: (context) {
                  return Downloader(downloads: args.items, platform: platform);
                },
              );
            }

            if (settings.name == MoreScreen.routeName) {
              return MaterialPageRoute(
                builder: (context) {
                  return MoreScreen();
                },
              );
            }

            return MaterialPageRoute(
              builder: (context) {
                return MyTabHomePage();
              },
            );
          },
        ),
      ),
    );
  }
}
