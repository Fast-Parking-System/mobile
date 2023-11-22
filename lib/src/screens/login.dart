import 'package:fast_parking_system/src/screens/home.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  static const routeName = '/login';

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var _userId;
  var _password;

  void _updateUserId(val) {
    setState(() {
      _userId = val;
    });
  }
  void _updatePassword(val) {
    setState(() {
      _password = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(60, 95, 107, 1),
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
              margin: const EdgeInsets.only(bottom: 20.0),
              child: Text(
                "fps".toUpperCase(),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 80,
                    fontWeight: FontWeight.bold),
              )),
          Form(
              child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  onChanged: (val){
                    _updateUserId(val);
                  },
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person_outline_outlined),
                      labelText: 'USER ID',
                      hintText: 'User ID',
                      border: OutlineInputBorder()),
                ),
                TextFormField(
                  onChanged: (val){
                    _updatePassword(val);
                  },
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.fingerprint),
                      labelText: 'PASSWORD',
                      hintText: 'Password',
                      border: OutlineInputBorder()),
                ),
                Text('USER ID is $_userId'),
                Text('PASSWORD is $_password'),
              ],
            ),
          )),
          // Text(
          //   "User ID".toUpperCase(),
          //   style: const TextStyle(color: Colors.white, fontSize: 22),
          // ),
          // Text('Password'.toUpperCase(),
          //     style: const TextStyle(color: Colors.white, fontSize: 22)),
          Container(
              margin: const EdgeInsets.only(top: 10.0),
              child: OutlinedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(200, 50),
                      padding: const EdgeInsets.all(10.0),
                      textStyle: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                      shape: const StadiumBorder(),
                      side: const BorderSide(color: Colors.white, width: 2)),
                  onPressed: () {
                    // Navigate to the settings page. If the user leaves and returns
                    // to the app after it has been killed while running in the
                    // background, the navigation stack is restored.
                    Navigator.restorablePushNamed(context, Home.routeName);
                  },
                  child: Text(
                    'login'.toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  )))
        ])));
  }
}
