import 'package:flutter/material.dart';
import 'server.dart';
//import 'home.dart';
import 'main.dart';
class SignUpPage extends StatefulWidget {
  SignUpPage({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  Server server = new Server();
  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'login times',
            ),

            TextField(
              obscureText: false,
              controller: usernameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Username',
              ),
            ),
            TextField(
              obscureText: true,
              controller: passwordController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: ' Comfirm Password',
              ),
            ),

            RaisedButton(
              onPressed: () {
                server.signUp(usernameController.text, passwordController.text)
        .then((uid){
                      print("successfully printed UID is: " + uid);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyApp()),
                      );
                  })
                    .catchError((e){
                      print("failed to signup. ");
                 });
              },
              child: const Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 20)
              ),
            ),
          ],
        ),
      ),

    );
  }
}


