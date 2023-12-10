import 'dart:convert';
import 'package:fast_parking_system/src/screens/home_attendant.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:fast_parking_system/src/constants.dart';
import 'package:fast_parking_system/src/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  static const routeName = '/login';

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController userIdController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // Create storage
  final storage = const FlutterSecureStorage();

  Future<void> sendLoginRequest() async {
    var url = Uri.parse(ApiConstants.url + ApiConstants.login);
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "user_id": userIdController.text,
          "password": passwordController.text,
        }));

    if (response.statusCode == 200) {
      var data = json.decode(response.body.toString());
      print(data['data']);

      // save token
      await storage.write(key: 'token', value: data['data']['token']);

      // save is_admin
      bool isAdmin = data['data']['is_admin'];
      print(isAdmin.toString());
      await storage.write(key: 'isAdmin', value: isAdmin.toString());

      // save user_id
      int userId = data['data']['user_id'];
      print(userId.toString());
      await storage.write(key: 'userId', value: userId.toString());

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Login Success!"),
      ));
      if (isAdmin) Navigator.restorablePushNamed(context, Home.routeName);
      else Navigator.restorablePushNamed(context, HomeAttendant.routeName);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Login Failed"),
      ));
    }
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
                Container(
                  margin: const EdgeInsets.only(bottom: 20.0),
                  child: TextFormField(
                    controller: userIdController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person_outline_outlined),
                        prefixIconColor: Colors.white,
                        fillColor: Colors.white,
                        labelText: 'USER ID',
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 2))),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 20.0),
                  child: TextFormField(
                    controller: passwordController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.fingerprint),
                        prefixIconColor: Colors.white,
                        fillColor: Colors.white,
                        labelText: 'PASSWORD',
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 2))),
                  ),
                ),
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
                  onPressed: sendLoginRequest,
                  // onPressed: () {
                  //   // Navigate to the settings page. If the user leaves and returns
                  //   // to the app after it has been killed while running in the
                  //   // background, the navigation stack is restored.
                  //   Navigator.restorablePushNamed(context, Home.routeName);
                  // },
                  child: Text(
                    'login'.toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  )))
        ])));
  }
}
