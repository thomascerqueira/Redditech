import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:redditech/Loading.dart';
import 'httpRequest.dart';
import 'command.dart';
import 'PostIn.dart';
import 'ShowPost.dart';
import 'OurColors.dart';
import 'package:html/parser.dart';
import 'package:animations/animations.dart';
import 'package:flutter/rendering.dart';

class Post {
  String title;
  String subreddit;
  String text;
  String after;
  String id;
  String subRedditName;
  String url;
  String htmlText;

  Post(this.title, this.subreddit, this.text, this.after, this.id,
      this.subRedditName, this.url, this.htmlText);
}

class Subreddit {
  String displayNamePrefixed;
  String after = "";
  Image? image;
  bool asImage = false;

  Subreddit(this.displayNamePrefixed);
}

class AllPost extends StatefulWidget {
  final BoxDecoration boxDecoration;
  final TokenInfo token;
  String acSubreddit;
  String whereAmI;
  Subreddit startSub;

  AllPost(
      {Key? key,
      required this.boxDecoration,
      required this.token,
      required this.acSubreddit,
      required this.whereAmI,
      required this.startSub})
      : super(key: key);
  @override
  AllPost_ createState() => AllPost_();
}

Future<List<Post>> GetPostFromSub(String sub, String token, String after,
    String classement, String limit) async {
  late Response<dynamic> response;
  String Sub = sub + classement;

  response = await httpGet(
      token, Sub, <String, dynamic>{'limit': limit, 'after': after});
  Map<String, dynamic> value = new Map<String, dynamic>.from(response.data);
  List<Post> newData = List.generate(
      value['data']['dist'] == 0 ? [] : value['data']['dist'], (index) {
    Map<String, dynamic> temp = value['data']['children'][index];
    String html = "";
    if (temp['data']['selftext_html'] != null) {
      html =
          temp['data']['selftext_html'].replaceAll("&lt;!-- SC_OFF --&gt;", "");
      html = html.replaceAll("&lt;!-- SC_ON --&gt;", "");
      html = parse(html).body!.text;
    }
    return Post(
        temp['data']['title'],
        temp['data']['subreddit'],
        temp['data']['selftext'],
        temp['kind'] + '_' + temp['data']['id'],
        temp['data']['id'],
        '/' + temp['data']['subreddit_name_prefixed'],
        temp['data']['permalink'],
        html);
  });
  return newData;
}

Future<List<Post>> InitAllSubReddit(String token, String startSub,
    String Classement, List<Subreddit> tabSub) async {
  late Response<dynamic> response;

  response = await httpGet(token, startSub, <String, dynamic>{'limit': '50'});
  Map<String, dynamic> value = new Map<String, dynamic>.from(response.data);
  List<Post> newData = [];

  for (var data in value['data']['children']) {
    late Response<dynamic> forImage;
    Subreddit nextSubs;
    List<Post> nextData = [];

    nextSubs = Subreddit('/' + data['data']['display_name_prefixed']);
    forImage =
        await httpGet(token, nextSubs.displayNamePrefixed + '/about', {});
    Map<String, dynamic> imageValue =
        new Map<String, dynamic>.from(forImage.data);
    try {
      nextSubs.image = Image.network(
          imageValue['data']['community_icon'].replaceAll('&amp;', '&'));
      nextSubs.asImage = true;
    } catch (e) {
      nextSubs.asImage = false;
    }

    nextData = await GetPostFromSub(
        nextSubs.displayNamePrefixed,
        token,
        "",
        (Classement == Command.popular || Classement == Command.hot)
            ? Command.hot
            : Command.myNew,
        "3");
    if (nextData.isNotEmpty) {
      newData.addAll(nextData);
      nextSubs.after = newData.last.after;
    }
    ;
    tabSub.add(nextSubs);
  }
  return newData;
}

Future<List<Post>> ActualisePostFromAllSub(
    List<Subreddit> tabSub, String token, String Classment) async {
  List<Post> newData = [];

  for (int i = 0; i < tabSub.length; i++) {
    List<Post> nextData = [];
    nextData = await GetPostFromSub(
        tabSub[i].displayNamePrefixed,
        token,
        tabSub[i].after,
        (Classment == Command.popular || Classment == Command.hot)
            ? Command.hot
            : Command.myNew,
        "3");
    if (nextData.isNotEmpty) {
      newData.addAll(nextData);
      tabSub[i].after = newData.last.after;
    }
  }
  return newData;
}

class AllPost_ extends State<AllPost> {
  List<Post> items = [];
  List<Subreddit> subReddits = [];
  bool loading = false, allLoaded = false;
  final ScrollController _scrollController = ScrollController();
  late String after;
  String? ClassActual = Command.popular;

  Image? getImageSub(String titleSub) {
    if (widget.startSub.displayNamePrefixed != "") {
      if (widget.startSub.asImage)
        return widget.startSub.image;
      else
        return Image(image: AssetImage('lib/Img/pot2fleur.png'));
    }
    for (var sub in subReddits)
      if (titleSub == sub.displayNamePrefixed) if (sub.asImage)
        return sub.image;
    return Image(image: AssetImage('lib/Img/pot2fleur.png'));
  }

  mockFetch() async {
    if (allLoaded) return;
    setState(() {
      loading = true;
    });

    if (items.length > 0)
      after = items.last.after;
    else
      after = "";

    List<Post> newData = [];

    if (widget.whereAmI == "mine") {
      if (subReddits.isEmpty)
        newData = await InitAllSubReddit(widget.token.accessToken,
            widget.acSubreddit, ClassActual.toString(), subReddits);
      else
        newData = await ActualisePostFromAllSub(
            subReddits, widget.token.accessToken, ClassActual.toString());
    } else {
      newData = await GetPostFromSub(
          widget.acSubreddit,
          widget.token.accessToken,
          after,
          (ClassActual == Command.popular || ClassActual == Command.hot)
              ? Command.hot
              : Command.myNew,
          "30");
    }
    if (newData.isNotEmpty) items.addAll(newData);
    setState(() {
      loading = false;
      allLoaded = newData.isEmpty;
    });
  }

  void changeWhereIAm(String newWhere) {
    widget.whereAmI = newWhere;
  }

  void changeClassement(String newClass) {
    if (newClass != ClassActual.toString()) {
      ClassActual = newClass;
      actualisePost();
    }
  }

  void actualisePost() {
    changeSub(widget.acSubreddit);
  }

  void changeSub(String newSub) {
    items.clear();
    subReddits.clear();
    widget.acSubreddit = newSub;
    loading = false;
    mockFetch();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  void initState() {
    super.initState();
    mockFetch();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !loading) {
        mockFetch();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return (items.length <= 0
        ? SafeArea(
            child: loading
                ? PdfLoader(type: "LBGCircle")
                : Text("On entends les criquets, pas de thread ici..."))
        : Stack(children: [
            ListView.separated(
              controller: _scrollController,
              itemBuilder: (context, index) {
                return Container(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: OpenContainer(
                      transitionType: ContainerTransitionType.fadeThrough,
                      middleColor: taupe[2],
                      closedShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      openColor: taupe[2],
                      closedColor: taupe[2],
                      closedBuilder: (context, action) {
                        return (Container(
                            padding: EdgeInsets.all(15),
                            child: showPostTotal(
                                post: items[index],
                                image: getImageSub(items[index].subRedditName)!
                                    .image,
                                maxLines: 5,
                                firstSize: 20,
                                secondSize: 15,
                                fontColorHead: blues[0],
                                fontColorTitle: blues[0])));
                      },
                      openBuilder: (context, action) {
                        return (PostIn(
                            post: items[index],
                            imageSub: getImageSub(items[index].subRedditName)!
                                .image));
                      },
                    ));
              },
              separatorBuilder: (context, index) =>
                  Divider(color: Colors.transparent),
              itemCount: items.length,
            ),
            if (loading) ...[
              Align(
                alignment: Alignment.bottomCenter,
                child:
                    Container(height: 80, child: PdfLoader(type: "LBLCircle")),
              )
            ]
          ]));
  }
}
