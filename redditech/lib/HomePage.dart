import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home.dart';
import 'httpRequest.dart';
import 'Profil.dart';
import 'OurColors.dart';

// This URL is an endpoint that's provided by the authorization server. It's
// usually included in the server's documentation of its OAuth2 API.

void hideUI() {
  Future.delayed(Duration(seconds: 2)).then((value) =>
      SystemChrome.setEnabledSystemUIMode(
          SystemUiMode.immersive //This line is used for showing the bottom bar
          ));
}

class MyHomePage extends StatefulWidget {
  final TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  final TokenInfo token;

  MyHomePage({Key? key, required this.token});

  @override
  _MyHomePage createState() => _MyHomePage();
}

class _MyHomePage extends State<MyHomePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // hideUI();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> screen = <Widget>[
      Home(scaffoldKey: _scaffoldKey, token: widget.token),
      Profil(token: widget.token)
    ];
    // hideUI();
    return MaterialApp(
        home: Scaffold(
            key: _scaffoldKey,
            /*drawer: Drawer(
          child: ListView(
        children: [
          DrawerHeader(child: Container(color: Colors.red)),
          ListTile(title: Text('Page1'))
        ],
      )),*/
            body: IndexedStack(
              index: _selectedIndex,
              children: screen,
            ),
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white70),
              child: BottomNavigationBar(
                  currentIndex: _selectedIndex,
                  selectedItemColor: cultured[0],
                  unselectedItemColor: taupe[2],
                  onTap: _onItemTapped,
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        label: 'Home',
                        backgroundColor: languid[2]),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.face),
                        label: 'Profil',
                        backgroundColor: languid[1]),
                  ],
                  type: BottomNavigationBarType.shifting),
            )));
  }
}
