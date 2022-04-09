import 'package:HolyTune/database/SharedPreference.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/AppStateNotifier.dart';
import '../auth/LoginScreen.dart';
import '../widgets/CommentsItem.dart';
import '../models/Userdata.dart';
import '../models/Comments.dart';
import '../models/Media.dart';
import '../i18n/strings.g.dart';
import '../utils/my_colors.dart';
import '../providers/CommentsModel.dart';
import '../widgets/CommentsMediaHeader.dart';
import 'package:flutter/foundation.dart';

class CommentsScreen extends StatefulWidget {
  static String routeName = "/comments";
  final Media item;
  final int commentCount;

  CommentsScreen({Key key, this.item, this.commentCount}) : super(key: key);

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  @override
  Widget build(BuildContext context) {
    print(widget.item.toString());
    final appState = Provider.of<AppStateNotifier>(context);
    Userdata userdata = appState.userdata;

    return ChangeNotifierProvider(
        create: (context) => CommentsModel(
            context, widget.item.id, userdata, widget.commentCount),
        child: CommentsSection(widget: widget, userdata: userdata));
  }
}

class CommentsSection extends StatelessWidget {
  const CommentsSection({
    Key key,
    @required this.widget,
    @required this.userdata,
  }) : super(key: key);

  final CommentsScreen widget;
  final Userdata userdata;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(
            context,
            Provider.of<CommentsModel>(context, listen: false)
                .totalPostComments);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () => Navigator.pop(
                context,
                Provider.of<CommentsModel>(context, listen: false)
                    .totalPostComments),
          ),
          title: Text(t.comments),
        ),
        body: Column(
          children: <Widget>[
            CommentsMediaHeader(object: widget.item),
            Container(height: 5),
            Expanded(
              child: CommentsLists(),
            ),
            Divider(height: 0, thickness: 1),
            SharedPref.loginState == true
                //userdata == null
                ? Container(
                    height: 50,
                    child: Center(
                        child: ElevatedButton(
                            child: Text(t.logintoaddcomment),
                            style: ElevatedButton.styleFrom(
                              primary: MyColors.accentDark,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              textStyle:
                                  TextStyle(fontSize: 17, color: Colors.white),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, LoginScreen.routeName);
                            })),
                  )
                : Consumer<CommentsModel>(
                    builder: (context, commentsModel, child) {
                    return Row(
                      children: <Widget>[
                        Container(width: 10),
                        Expanded(
                          child: TextField(
                            controller: commentsModel.inputController,
                            maxLines: 5,
                            minLines: 1,
                            keyboardType: TextInputType.multiline,
                            decoration: new InputDecoration.collapsed(
                                hintText: t.writeamessage),
                          ),
                        ),
                        commentsModel.isMakingComment
                            ? Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                    width: 30,
                                    child: CircularProgressIndicator()),
                              )
                            : Padding(
                                padding: EdgeInsets.all(10),
                                child: IconButton(
                                    icon: Icon(Icons.send,
                                        color: MyColors.accentDark, size: 20),
                                    onPressed: () {
                                      String text =
                                          commentsModel.inputController.text;
                                      print("my comment is ------- $text");
                                      if (text != "") {
                                        commentsModel.makeComment(text);
                                      }
                                    }),
                              ),
                      ],
                    );
                  })
          ],
        ),
      ),
    );
  }
}

class CommentsLists extends StatelessWidget {
  bool isError = false;
  int media = 0;
  int totalPostComments = 0;
  Userdata userdata;
  bool isLoading = false;
  bool isMakingComment = false;
  bool isMakingCommentsError = false;
  bool hasMoreComments = false;
  bool isLoadingMore = false;

  @override
  Widget build(BuildContext context) {
    var commentsModel = Provider.of<CommentsModel>(context);
    List<Comments> commentsList = commentsModel.items;
    if (commentsModel.isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (commentsList.length == 0) {
      return Center(
          child: Container(
        height: 200,
        child: GestureDetector(
          onTap: () {
            // fetchComments();
            commentsModel.loadComments();
          },
          child: ListView(children: <Widget>[
            Icon(
              Icons.refresh,
              size: 50.0,
              color: Colors.red,
            ),
            Text(
              t.nocomments,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            )
          ]),
        ),
      ));
    } else {
      return ListView.separated(
        controller: commentsModel.scrollController,
        itemCount: commentsModel.hasMoreComments
            ? commentsList.length + 1
            : commentsList.length,
        separatorBuilder: (BuildContext context, int index) =>
            Divider(height: 1, color: Colors.grey),
        itemBuilder: (context, index) {
          if (index == 0 && commentsModel.isLoadingMore) {
            return Container(
                width: 30, child: Center(child: CircularProgressIndicator()));
          } else if (index == 0 && commentsModel.hasMoreComments) {
            return Container(
              height: 30,
              child: Center(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: MyColors.accentDark,
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        textStyle: TextStyle(fontSize: 17, color: Colors.white),
                      ),
                      child: Text(t.loadmore),
                      onPressed: () {
                        Provider.of<CommentsModel>(context, listen: false)
                            .loadMoreComments();
                      })),
            );
          } else {
            int _index = index;
            if (commentsModel.hasMoreComments) _index = index - 1;
            return CommentsItem(
              isUser: commentsModel.isUser(commentsList[_index].email),
              context: context,
              index: _index,
              object: commentsList[_index],
            );
          }
        },
      );
    }
  }
}
