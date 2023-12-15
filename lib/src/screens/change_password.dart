import 'package:fast_parking_system/src/models/change_password_model.dart';
import 'package:fast_parking_system/src/screens/profile.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:fast_parking_system/src/services/api_service.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  static const routeName = '/change-password';

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePasswordScreen> {
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();
  late ChangePassword? _changePasswordResponse = null;

  final storage = const FlutterSecureStorage();

  Future<void> sendChangePasswordRequest() async {
    _changePasswordResponse = await ApiService().sendChangePasswordRequest(
      oldPassword: oldPasswordController.text,
      newPassword: newPasswordController.text,
      confirmNewPassword: confirmNewPasswordController.text,
    );

    if (_changePasswordResponse != null &&
        _changePasswordResponse!.data.isUpdated) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Change Password Success!"),
      ));
      Navigator.restorablePushNamed(context, Profile.routeName);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Change Password Failed"),
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
                    controller: oldPasswordController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person_outline_outlined),
                        prefixIconColor: Colors.white,
                        fillColor: Colors.white,
                        labelText: 'Old Password',
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 2))),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 20.0),
                  child: TextFormField(
                    controller: newPasswordController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.fingerprint),
                        prefixIconColor: Colors.white,
                        fillColor: Colors.white,
                        labelText: 'New Password',
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 2))),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 20.0),
                  child: TextFormField(
                    controller: confirmNewPasswordController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.fingerprint),
                        prefixIconColor: Colors.white,
                        fillColor: Colors.white,
                        labelText: 'Confirm New Password',
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 2))),
                  ),
                )
              ],
            ),
          )),
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
                  onPressed: sendChangePasswordRequest,
                  child: Text(
                    'Change Password'.toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  )))
        ])));
  }
}
