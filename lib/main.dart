

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'login.dart';
import 'server.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Title',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        brightness: Brightness.dark,
      ),
      home: LoginPage(title: 'Login to Blacklister'),
    );
  }
}

class MyApp extends StatefulWidget {
  final String username;
  MyApp(this.username);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyAppState(username);
  }
}

class _MyAppState extends State<MyApp> {
  final GoogleSignIn _googleSignIn = new GoogleSignIn();
  final String username;
  _MyAppState(this.username);
  Server server = new Server();

  String _text = '';

//  static Stream<DocumentSnapshot> ds = Firestore.instance.collection("blacklists").document("eric123").snapshots();//  List<String> _urls = ["one", "two", "three"];

  List<String> _urls = [];

  Map<String, dynamic> docData;

  bool switchOn = true;

  @override
  void initState() {
    super.initState();
    print("username test: " + username);
    Stream<DocumentSnapshot> ds = Firestore.instance
        .collection("blacklists")
        .document(username)
        .snapshots();
    Firestore.instance
        .collection("blacklists")
        .document(username)
        .get()
        .then((ds) {
      docData = ds.data;
      switchOn = docData["enabled"];
      print("switchOn test: " + switchOn.toString());
      setState(() {
        _urls = [];
        for (var url in docData["list"]) {
          _urls.add(url);
        }
        print("updated url: " + _urls.toString());
      });
    }).catchError((e) {
      print("failed to get the url" + e.toString());
    });
  }

  void updateUrlList() {
    List<dynamic> list = [];

    docData['list'] = _urls;
    Firestore.instance
        .collection("blacklists")
        .document(username)
        .updateData(docData)
        .then((v) {
      print("successfully updated it.");
    }).catchError((e) {
      print("failed to update it");
    });
  }

  void onPressed() {
    setState(() {
      _urls.add(_text);
//      print(_urls);
    });
    updateUrlList();
  }

  void onChanged(String value) {
    setState(() {
      _text = value;
    });
  }



  @override
  Widget build(BuildContext context) {
    Color hexToColor(String code) {
      return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
    }
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Welcome to Flutter",
        home: new Scaffold(
            appBar: AppBar(
              title: Text('Edit your blacklist'),
              backgroundColor: Colors.black,
              actions: <Widget>[
                new IconButton(
                  icon: new Icon(Icons.lock_open),
                  onPressed: () {
                    server
                        .signOut()
                        .then(
                          (uid) {
                        Navigator.of(context).pop();
                      },
                    ).catchError((e) {
                      ;
                      print("failed to login");
                    });
                  },
                ),
              ],
            ),
            body: new Container(
              padding: const EdgeInsets.all(30.0),
              color: Colors.white,
              child: new Container(
                  child: new Center(
                child: new Column(children: [
                  new Padding(padding: EdgeInsets.only(top: 10.0)),
                  new Text(
                    'Add to the blacklist by entering a URL below',
                    style: new TextStyle(
                      color: Colors.black,
                      fontSize: 17.0,
                    ),
                  ),
                  new Padding(padding: EdgeInsets.only(top: 10.0)),
                  new TextField(
                    onChanged: (String value) {
                      onChanged(value);
                    },
                    decoration: new InputDecoration(
                      labelText: "Enter URL",
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                        borderSide: new BorderSide(),
                      ),
                      //fillColor: Colors.green
                    ),
                    keyboardType: TextInputType.url,
                    style: new TextStyle(
                      fontFamily: "Poppins",
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10.0),
                    child: RaisedButton(
                        onPressed: () {
                          onPressed();
                        },
                        child: Text('Add to Blacklist')),
                  ),
                  new Text('Enable or disable URL detection on computer:'),
                  new Switch(
                    value: switchOn,
                    onChanged: (value) {
                      setState(() {
                        switchOn = value;
                      });
                      docData['enabled'] = value;
                      Firestore.instance
                          .collection("blacklists")
                          .document(username)
                          .updateData(docData)
                          .then((v) {
                        print("successfully updated it.");
                      }).catchError((e) {
                        print("failed to update it");
                      });
                    },
                    activeTrackColor: Colors.blue,
                    activeColor: Colors.lightBlue,
                  ),
                  new Text('(Press and hold any list item to delete it)'),
                  new Expanded(
                      child: new ListView.builder(
                          itemCount: _urls.length,
                          itemBuilder: (context, index) {
                            return Card(
                                child: ListTile(
                                   title: Text((index + 1).toString()),
                                    subtitle: Row(children: <Widget>[
                                      Padding(
                                        padding:
                                        EdgeInsets.fromLTRB(0, 5.0, 12.0, 5.0),
                                        child: Text((_urls.reversed)
                                        .elementAt((index).abs()))),
                                    ]),
                                onLongPress: () {
                                setState(() {
                                  _urls.removeAt(
                                      (index - _urls.length + 1).abs());
                                });
                                updateUrlList();
                              },
                            ));
                          })),
                ]),
              )),
            )));
  }
}
