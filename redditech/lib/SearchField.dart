import 'package:flutter/material.dart';
import 'OurColors.dart';
import 'httpRequest.dart' show httpGet;
import 'package:dio/dio.dart';
import 'allPost.dart' show Subreddit;

class SearchField extends StatefulWidget {
  final double width;
  final Color? color;
  final String? hintText;
  Color? frontColor = Colors.white70;
  static List<Subreddit> result = [];
  final String token;

  SearchField(
      {Key? key,
      required this.width,
      this.color,
      this.hintText,
      this.frontColor,
      required this.token})
      : super(key: key);
  @override
  SearchField_ createState() => SearchField_();
}

class SearchField_ extends State<SearchField> {
  final TextEditingController _controller = TextEditingController();

  void getCompletion(String valueEntered) async {
    late Response<dynamic> response;

    response = await httpGet(widget.token, "/api/subreddit_autocomplete",
        <String, dynamic>{'query': valueEntered});
    Map<String, dynamic> value = new Map<String, dynamic>.from(response.data);
    List<Subreddit> newArray = [];
    for (var data in value['subreddits']) {
      Subreddit newData = new Subreddit('r/' + data['name']);
      if (data['communityIcon'] != '') {
        newData.image =
            Image.network(data['communityIcon'].replaceAll('&amp;', '&'));
        newData.asImage = true;
      } else {
        newData.asImage = false;
      }
      newArray.add(newData);
    }
    setState(() {
      SearchField.result = newArray;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (Stack(children: [
      Container(
          width: widget.width,
          child: TextField(
            controller: _controller,
            style: TextStyle(color: widget.frontColor),
            textAlign: TextAlign.start,
            decoration: InputDecoration(
                fillColor: widget.color,
                filled: true,
                hintText: widget.hintText,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(width: 0, style: BorderStyle.none),
                ),
                contentPadding: EdgeInsets.only(left: 10)),
            onTap: () => {},
            onChanged: (String value) => getCompletion(value),
          ))
    ]));
  }
}
