import 'package:flutter/material.dart';
import 'dart:math';
import 'package:webview_flutter/webview_flutter.dart';
import 'httpRequest.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setEnabledSystemUIMode(
  //     SystemUiMode.immersive //This line is used for showing the bottom bar
  //     );
  runApp(MyTest());
}

class MyTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: "My Test", home: Auth());
  }
}

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

class Auth extends StatefulWidget {
  final clientId = 'Your client ID';
  final randomString = getRandomString(5);
  final uri = "http://localhost";
  final duration = 'permanent';
  final scope =
      'identity, edit, flair, history, modconfig, modflair, modlog, modposts, modwiki, mysubreddits, privatemessages, read, report, save, submit, subscribe, vote, wikiedit, wikiread';

  @override
  _Auth createState() => _Auth();
}

class _Auth extends State<Auth> {
  String code = "";
  @override
  void initState() {
    super.initState();
    () async {
      PermissionStatus _permissionStatus = await Permission.storage.status;

      if (_permissionStatus != PermissionStatus.granted) {
        PermissionStatus permissionStatus = await Permission.storage.request();
        setState(() {
          _permissionStatus = permissionStatus;
        });
      }
    }();
  }

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl:
          "https://www.reddit.com/api/v1/authorize.compact?client_id=${widget.clientId}&response_type=code&state=${widget.randomString}&redirect_uri=${widget.uri}&duration=${widget.duration}&scope=${widget.scope}",
      javascriptMode: JavascriptMode.unrestricted,
      navigationDelegate: (NavigationRequest request) {
        if (request.url.startsWith(widget.uri)) {
          code = request.url.substring(
              request.url.lastIndexOf('=') + 1, request.url.length - 2);
          runApp(WaitToken(
              clientId: widget.clientId, uri: widget.uri, code: code));
        }
        return NavigationDecision.navigate;
      },
    );
  }
}
