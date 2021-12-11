import 'package:flutter/material.dart';
import 'allPost.dart' show Post;

Widget showHeadPost(
    {required Post post,
    required ImageProvider<Object> image,
    Color? back = Colors.white70,
    Color? colorFront = Colors.white70}) {
  return Align(
      alignment: Alignment.topLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  color: back,
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(fit: BoxFit.cover, image: image))),
          SizedBox(width: 10),
          Text(post.subreddit, style: TextStyle(color: colorFront))
        ],
      ));
}

Widget showTitlePost(
    {required Post post,
    FontWeight fontweight = FontWeight.bold,
    Color? colorFront = Colors.white70}) {
  return Text(post.title,
      style:
          TextStyle(fontSize: 20, fontWeight: fontweight, color: colorFront));
}

Widget showTextPost(
    {required Post post,
    int maxLines = -1,
    Color? colorFront = Colors.white70}) {
  return (maxLines < 0
      ? Text(post.text, style: TextStyle(color: colorFront))
      : Text(
          post.text,
          style: TextStyle(color: colorFront),
          overflow: TextOverflow.ellipsis,
          maxLines: maxLines,
        ));
}

Widget showPostTotal(
    {required Post post,
    required ImageProvider<Object> image,
    required int maxLines,
    required double firstSize,
    required double secondSize,
    FontWeight fontweight = FontWeight.bold,
    Color? fontColorHead = Colors.white70,
    Color? fontColorTitle = Colors.white70,
    Color? fontColorText = Colors.white70}) {
  return (Column(
    children: [
      showHeadPost(post: post, image: image, colorFront: fontColorHead),
      SizedBox(height: firstSize),
      showTitlePost(post: post, colorFront: fontColorTitle),
      SizedBox(height: secondSize),
      showTextPost(post: post, maxLines: maxLines, colorFront: fontColorText)
    ],
  ));
}
