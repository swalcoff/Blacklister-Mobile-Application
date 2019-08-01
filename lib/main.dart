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

void main() => runApp(new MyApp());

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
  Future<List<DocumentSnapshot>> _urls =  ds.toList();

  void onPressed() {
    setState(() {
      _urls.add(_text);
//      print(_urls);
    });
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
                                color: hexToColor("#F2A03D"), fontSize: 25.0),),
                          new Padding(padding: EdgeInsets.only(top: 10.0)),
                          new TextField(
                            onChanged: (String value) {
                              onChanged(value);
                            },
                            decoration: new InputDecoration(
                              labelText: "Enter URL",
                              fillColor: Colors.white,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(25.0),
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
//                          StreamBuilder(
//                            stream: Firestore.instance.collection("blacklists")
//                                .document("eric123")
//                                .snapshots(),
//                            builder: (context, snapshot) {
//                              if (!snapshot.hasData)
//                                return const Text("Loading...");
//                              return ListView.builder(
//                                itemBuilder: (BuildContext ctxt, int index) {
//                                  return new Text(
//                                      snapshot.data.documents[index]);
//                                },
//                                itemExtent: 80.0,
//                                itemCount: snapshot.data.documents.length,);
//                            },
//                          )
                            Column(children: _urls.map((element) => Card(
                                child: Column(
                                  children: <Widget>[
                                    Text(element)
                                  ],
                                )
                            ),).toList(),)
                        ]
                    ),
//


                  )
              ),
            )
        )
    );
  }
}