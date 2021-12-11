import 'package:flutter/material.dart';
import 'allPost.dart';
import 'Search.dart';
import 'httpRequest.dart';
import 'command.dart';
import 'OurColors.dart';
import 'package:animations/animations.dart';
import 'package:flutter/rendering.dart';
import 'RowButton.dart';

class Home extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final TokenInfo token;
  Home({Key? key, required this.scaffoldKey, required this.token})
      : super(key: key);
  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {
  double myWidth = 0;
  GlobalKey<AllPost_> keyAllPost = GlobalKey();
  int indexButton = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // hideUI();
    myWidth = MediaQuery.of(context).size.width;
    return (Container(
        color: languid[0],
        child: Column(children: <Widget>[
          Container(
            color: languid[0],
            margin: EdgeInsets.only(top: 5),
            padding: new EdgeInsets.only(top: 20, right: 10, left: 10),
            height: 60,
            width: myWidth,
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20), color: taupe[2]),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      /*IconButton(
                onPressed: () => widget.scaffoldKey.currentState!.openDrawer(),
                icon: Icon(Icons.message),
              ),
              Spacer(),*/
                      Container(
                          padding: new EdgeInsets.only(left: 10),
                          child: OpenContainer(
                              closedElevation: 0,
                              closedColor: taupe[2],
                              openColor: languid[1],
                              closedBuilder: (context, action) {
                                return (Icon(Icons.search, color: languid[1]));
                              },
                              openBuilder: (context, action) {
                                return new Search(
                                    token: widget.token.accessToken);
                              })),
                      Spacer(),
                      IconButton(
                        onPressed: () =>
                            keyAllPost.currentState!.actualisePost(),
                        icon: Icon(Icons.refresh_outlined),
                        color: languid[1],
                      )
                    ])),
          ),
          Container(color: languid[0], child: RowButton(keyPost: keyAllPost)),
          Expanded(
              child: AllPost(
                  startSub: Subreddit(""),
                  acSubreddit: Command.subRedditMine + Command.sub,
                  whereAmI: "mine",
                  key: keyAllPost,
                  boxDecoration: BoxDecoration(
                    color: languid[0],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  token: widget.token))
        ])));
  }
}
