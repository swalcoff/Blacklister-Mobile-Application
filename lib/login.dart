import 'package:flutter/material.dart';
import 'signUp.dart';
//import 'home.dart';
import 'server.dart';
import 'main.dart';
class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Server server = new Server();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();


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
            RaisedButton(
              onPressed: () {
                server.signIn(usernameController.text, passwordController.text)
                    .then((uid) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyApp()),
                  );
                },).catchError((e) {
                  ;
                  print("failed to login");
                });
              },
              child: const Text(
                  'Login',
                  style: TextStyle(fontSize: 20)
              ),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpPage(title:'SignUp')),
                );
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


