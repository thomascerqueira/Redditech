import 'package:flutter/material.dart';
import 'ShowPost.dart';
import 'allPost.dart' show Post;
import 'package:html/dom.dart' as dom;
import 'package:flutter_html/flutter_html.dart';
import 'OurColors.dart';
import 'package:url_launcher/url_launcher.dart';

class PostIn extends StatefulWidget {
  final Post post;
  final ImageProvider<Object> imageSub;
  PostIn({Key? key, required this.post, required this.imageSub})
      : super(key: key);
  @override
  _PostIn createState() => _PostIn();
}

_launchURL(String? url) async {
  if (await canLaunch(url.toString())) {
    await launch(url.toString());
  }
}

class _PostIn extends State<PostIn> {
  List<Post> allPost = [];
  Color? back = taupe[2];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (Container(
        padding: EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.fromLTRB(3, 10, 10, 10),
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(Icons.backspace_outlined)),
                    showHeadPost(
                        post: widget.post,
                        image: widget.imageSub,
                        colorFront: blues[0]),
                  ],
                )),
            SizedBox(height: 15),
            Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                child: showTitlePost(post: widget.post, colorFront: blues[0])),
            SizedBox(height: 15),
            Flexible(
                child: SingleChildScrollView(
              child: Container(
                  margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: widget.post.htmlText != ""
                      ? Html(
                          data: widget.post.htmlText,
                          onLinkTap: (String? url,
                              RenderContext context,
                              Map<String, String> attributes,
                              dom.Element? element) {
                            _launchURL(url);
                          },
                          style: {"p": Style(color: Colors.white70)})
                      : Text(widget.post.text)),
            )),
            Container(
              height: 5,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: languid[0]),
            ),
            if (allPost.length > 0) ...[
              Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Text("Commentaires:"))
            ],
            if (allPost.length > 0) ...[
              Expanded(
                  child: ListView.separated(
                      itemBuilder: (context, index) {
                        return Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.black87),
                                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                child: Container(
                                  margin: EdgeInsets.only(left: 10, right: 10),
                                  child: Text(
                                    allPost[index].text,
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                )));
                      },
                      separatorBuilder: (context, index) =>
                          Divider(color: Colors.transparent),
                      itemCount: allPost.length))
            ]
          ],
        )));
  }
}
