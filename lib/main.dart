//import 'package:flutter/material.dart';
//
////implementation 1:
//void main() => runApp(MyApp());
//
//
////implementation 2:
////void main() {
////  runApp(MyApp());
////}
//
////these are both valid and functionally identical implementations!
//
//// @override tells dart and flutter that we are overriding a method that is already defined. this isn't necessary but works as a useful sort of annotation (readability)
//class MyApp extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      home: Scaffold(
//        appBar: AppBar(
//          title: Text('EasyList'),
//        ),
//        body: ,
//      ),
//    );
//  }
//}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'login_signup_page.dart';
import 'login.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Title',
      home: LoginPage(title: 'login'),
    );
  }
}

class MyApp extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyAppState();
  }
}
class _MyAppState extends State<MyApp> {
  String _text = '';
//  List<String> _urls = ["one", "two", "three"];

  static Stream<DocumentSnapshot> ds = Firestore.instance.collection("blacklist").document("eric123").snapshots(); //['first url', 'second url', 'third url'];
  List<String> _urls = [];

  Map<String, dynamic> docData;

  bool switchOn;


  @override
  void initState() {
    super.initState();
    Firestore.instance.collection("blacklists").document("eric123").get().then((ds){
      print(ds.documentID);
      print(ds.data);
      docData = ds.data;
      setState(() {
        switchOn = docData["enabled"];
        _urls = [];
        for (var url in docData["list"]) {
          _urls.add(url);
        }
        print("updated url: " + _urls.toString());
      });
    }).catchError((e){
      print("failed to get the url" + e.toString());
    });


  }

  void updateUrlList() {
    List<dynamic> list = [];

    docData['list'] = _urls;
    Firestore.instance.collection("blacklists").document("eric123").updateData(docData).then((v){
      print("successfully updated it.");
    }).catchError((e){
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

  void onChanged(String value){
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
        home: new Material(
            child: new Container (
              padding: const EdgeInsets.all(30.0),
              color: Colors.white,
              child: new Container(
                  child: new Center(
                    child: new Column(
                        children: [
                          new Padding(padding: EdgeInsets.only(top: 10.0)),
                          new Text(
                            'Add to the blacklist by entering a URL below',
                            style: new TextStyle(
                                color: hexToColor("#F2A03D"),
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
                                borderSide: new BorderSide(
                                ),
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
                                child: Text('Add to Blacklist')
                            ),
                          ),
                          new Text('(Press and hold any list item to delete it)'),
                          new Switch(
                                 value: switchOn,
                                 onChanged: (value){
                                   setState(() {
                                     switchOn = value;
                                   });
                                   docData['enabled'] = value;
                                   Firestore.instance.collection("blacklists").document("eric123").updateData(docData).then((v){
                                     print("successfully updated it.");
                                     }).catchError((e){
                                                                       print("failed to update it");
                                                                    });
                                                            }),
                          new Expanded(
                              child: new ListView.builder(
                                  itemCount: _urls.length,
                                  itemBuilder: (context, index) {
                                    return Card(
                                        child: ListTile(
                                          title: Text((index+1).toString()),
                                          subtitle: Row(
                                              children: <Widget>[
                                                Padding(
                                                    padding: EdgeInsets.fromLTRB(0, 5.0, 12.0, 5.0),
                                                    child: Text((_urls.reversed).elementAt((index).abs()))
                                                ),
                                              ]
                                          ),
                                          onLongPress: () {
                                            setState(() {
                                              _urls.removeAt((index - _urls.length + 1).abs());
                                            });
                                            updateUrlList();
                                          },
                                        )
                                    );
                                  }
                              )
                          ),
                        ]
                    ),
                  )
              ),
            )
        )
    );
  }
}