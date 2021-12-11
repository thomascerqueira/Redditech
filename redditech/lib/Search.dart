import 'package:flutter/material.dart';
import 'SearchField.dart';
import 'allPost.dart';
import 'OurColors.dart';
import 'httpRequest.dart' show TokenInfo;
import 'RowButton.dart';

class Search extends StatefulWidget {
  final String token;

  Search({Key? key, required this.token}) : super(key: key);
  @override
  Search_ createState() => Search_();
}

class Search_ extends State<Search> {
  bool animted = false;
  GlobalKey<SearchField_> keySearch = new GlobalKey();
  List<Subreddit> subreddits = [];
  late Image pdf;
  GlobalKey<AllPost_> keyAllPost = GlobalKey();
  int indexButton = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 0)).then((value) => setState(() {
          animted = true;
        }));
    pdf = Image(image: AssetImage('lib/Img/pot2fleur.png'));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    subreddits = SearchField.result;
    precacheImage(pdf.image, context);
  }

  void changeButton(int index, String command) {
    indexButton = index;
    keyAllPost.currentState!.changeClassement(command);
  }

  Widget printPostSearch(Subreddit sub) {
    return (Container(
        color: languid[0],
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.only(top: 25),
                color: languid[0],
                child: RowButton(keyPost: keyAllPost)),
            Expanded(
                child: new AllPost(
                    key: keyAllPost,
                    startSub: sub,
                    acSubreddit: '/' + sub.displayNamePrefixed,
                    whereAmI: "inSub",
                    boxDecoration: BoxDecoration(
                      color: languid[0],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    token: TokenInfo(widget.token, "", 0, "", "")))
          ],
        )));
  }

  Route createRoute_(Subreddit sub) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondary) => printPostSearch(sub),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 5),
        padding: EdgeInsets.only(top: 20),
        child: Column(children: [
          Row(children: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.backspace_outlined)),
            AnimatedContainer(
                width: animted ? MediaQuery.of(context).size.width * 0.8 : 0,
                duration: Duration(milliseconds: 300),
                child: SearchField(
                  token: widget.token,
                  key: keySearch,
                  hintText: "Search",
                  color: taupe[2],
                  width: MediaQuery.of(context).size.width * 0.8,
                ))
          ]),
          if (subreddits.length > 0) ...[
            Expanded(
                child: ListView.separated(
                    itemBuilder: (context, index) {
                      return (ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(taupe[2]),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                                child: Container(
                              width: 50,
                              height: 50,
                              child: subreddits[index].asImage
                                  ? Image(image: subreddits[index].image!.image)
                                  : Image(
                                      image:
                                          AssetImage('lib/Img/pot2fleur.png')),
                            )),
                            Text(subreddits[index].displayNamePrefixed)
                          ],
                        ),
                        onPressed: () => {
                          Navigator.of(context)
                              .push(createRoute_(subreddits[index]))
                        },
                      ));
                    },
                    separatorBuilder: (context, index) =>
                        Divider(color: Colors.transparent),
                    itemCount: subreddits.length))
          ]
        ]));
  }
}
