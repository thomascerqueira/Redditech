import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'httpRequest.dart';
import 'OurColors.dart';

class Settings {
  bool nightMode = false;
  bool over18 = false;
  bool inBeta = false;
  bool prefVideoAutoplay = false;
  bool prefShowSnoovatar = false;
  bool prefShowTrending = false;


  Settings(this.nightMode, this.over18, this.inBeta, this.prefVideoAutoplay, this.prefShowSnoovatar, this.prefShowTrending);
}

class ProfilInfo {
  String tilte = "";
  String name = "";
  String icon = "";
  String description = "";
  String banner = "";
  Settings settings;

  ProfilInfo(this.tilte, this.name, this.icon, this.description, this.banner, this.settings);
}

class Profil extends StatefulWidget {
  final TokenInfo token;

  Profil({Key? key, required this.token}) : super(key: key);
  @override
  _Profil createState() => _Profil();
}

class _Profil extends State<Profil> {
  late Response<dynamic> response;
  ProfilInfo profInfo = new ProfilInfo("", "", "", "", "", new Settings(false, false, false, false, false, false));

  userFetch() async {
    response = await httpGet(widget.token.accessToken, '/api/v1/me', <String, dynamic>{});
    Map<String, dynamic> value = new Map<String, dynamic>.from(response.data);

    profInfo = new ProfilInfo(
        value['subreddit']['title'],
        value['subreddit']['display_name'],
        value['subreddit']['icon_img'],
        value['subreddit']['public_description'],
        value['subreddit']['banner_img'],
        new Settings(
          value['pref_nightmode'], 
          value['over_18'], value['in_beta'],
          value['pref_video_autoplay'],
          value['pref_show_snoovatar'],
          value['pref_show_trending']));
    profInfo.icon = profInfo.icon.replaceAll('&amp;', '&');
    if (profInfo.banner != "")
      profInfo.banner = profInfo.banner.replaceAll('&amp;', '&');
  }

  @override
  void initState() {
    super.initState();
    userFetch();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: languid[0],
      child: Column(
        children: [
          profInfo.banner == ""
            ? Container(
                height: 100, decoration: BoxDecoration(color: Colors.blue[300]))
            : Image(
                image: NetworkImage(profInfo.banner),
              ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.all(5),
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(profInfo.icon)
                )
              ),
            ),
            SizedBox(width: 10),
            Column( 
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30),
                Text(
                  profInfo.tilte,
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 10),
                Text(
                  profInfo.name,
                  style: TextStyle(fontSize: 15),
                ),
                SizedBox(height: 10),
              ],
            )
          ],
        ),
        Container(
          margin: const EdgeInsets.all(10),
          child : Text(
            profInfo.description,
            style: TextStyle(fontSize: 15),
          )
        ),

        SwitchListTile(
          value: profInfo.settings.nightMode, 
          onChanged: (bool value) {
            setState(() {
              profInfo.settings.nightMode = value;
            });
          },
          title: Text("Night Mode"),
        ),

        SwitchListTile(
          value: profInfo.settings.over18, 
          onChanged: (bool value) {
            setState(() {
              profInfo.settings.over18 = value;
            });
          },
          title: Text("Show sensible content"),
        ),

        SwitchListTile(
          value: profInfo.settings.inBeta, 
          onChanged: (bool value) {
            setState(() {
              profInfo.settings.inBeta = value;
            });
          },
          title: Text("Beta acces"),
        ),
        
        SwitchListTile(
          value: profInfo.settings.prefVideoAutoplay, 
          onChanged: (bool value) {
            setState(() {
              profInfo.settings.prefVideoAutoplay = value;
            });
          },
          title: Text("Autoplay video"),
        ),

        SwitchListTile(
          value: profInfo.settings.prefShowSnoovatar, 
          onChanged: (bool value) {
            setState(() {
              profInfo.settings.prefShowSnoovatar = value;
            });
          },
          title: Text("Show Snoo Avatars"),
        ),

        SwitchListTile(
          value: profInfo.settings.prefShowTrending, 
          onChanged: (bool value) {
            setState(() {
              profInfo.settings.prefShowTrending = value;
            });
          },
          title: Text("Show Trending"),
        )
      ],
    ));
  }
}
