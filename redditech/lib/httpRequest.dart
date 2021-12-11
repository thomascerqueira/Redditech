import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'Loading.dart';

Future<dynamic> httpGet(
    String tokenAcces, String uri, Map<String, dynamic> parameters) async {
  final response = await Dio().get("https://oauth.reddit.com" + uri,
      options: Options(headers: <String, dynamic>{
        'User-Agent': 'MyAPI/0.0.1',
        'Authorization': 'bearer $tokenAcces'
      }),
      queryParameters: parameters);
  if (response.statusCode != 200) print("error ${response.statusCode}");
  return response;
}

dynamic Post(String uri, String clientId, String code, String redi) async {
  final id = base64.encode(utf8.encode(clientId + ':'));
  final response = await Dio().post(uri,
      options: Options(
        headers: <String, String>{
          'authorization': 'Basic $id',
          'content-type': 'application/x-www-form-urlencoded'
        },
      ),
      data: 'grant_type=authorization_code&code=$code&redirect_uri=$redi');
  if (response.statusCode == 200) {
    print(response.data);
    return response.data;
  } else
    throw Exception;
}

class WaitToken extends StatefulWidget {
  final clientId;
  final uri;
  final code;

  WaitToken(
      {Key? key,
      required this.clientId,
      required this.uri,
      required this.code});
  @override
  _WaitToken createState() => _WaitToken();
}

class _WaitToken extends State<WaitToken> with SingleTickerProviderStateMixin {
  late AnimationController controller;

  void callPost() async {
    dynamic newReponse = await Post(
        "https://www.reddit.com/api/v1/access_token",
        widget.clientId,
        widget.code,
        widget.uri);
    TokenInfo test =
        TokenInfo.fromJson(new Map<String, dynamic>.from(newReponse));
    runApp(MyHomePage(token: test));
  }

  @override
  void initState() {
    super.initState();

    callPost();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(body: Center(child: PdfLoader(type: "LBGCircle"))));
  }
}

class TokenInfo {
  final String accessToken;
  final String tokenType;
  final int expireIn;
  final String scope;
  final String refreshToken;

  TokenInfo(this.accessToken, this.tokenType, this.expireIn, this.scope,
      this.refreshToken);

  factory TokenInfo.fromJson(Map<String, dynamic> json) {
    return (TokenInfo(json['access_token'], json['token_type'],
        json['expires_in'], json['scope'], json['refresh_token']));
  }

  // printToken() {
  //   print("$accessToken, $tokenType, $expireIn, $scope, $refreshToken");
  // }
}
