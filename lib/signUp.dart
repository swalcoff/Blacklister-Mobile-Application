import 'package:flutter/material.dart';
import 'server.dart';
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

  Widget _showLogo() {
    return new Hero(
      tag: 'logo',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 100.0,
          child: Image.asset('assets/blacklisterLogo.png'),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _showLogo(),

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
                  labelText: ' Confirm Password',
                ),
              ),

              Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
                  child: SizedBox(
                    height: 40.0,
                    child: new RaisedButton(
                      elevation: 5.0,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(100.0)),
                      color: Colors.black,
                      child:new Text('Login', style: new TextStyle(fontSize: 20.0, color: Colors.white)),
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
                    ),
                  )),
            ],
          ),
        ),
      ),

    );
  }
}


