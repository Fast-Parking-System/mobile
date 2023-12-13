import 'dart:convert';

import 'package:fast_parking_system/src/constants.dart';
import 'package:fast_parking_system/src/models/register_model.dart';
import 'package:fast_parking_system/src/screens/home.dart';
import 'package:fast_parking_system/src/models/locations_model.dart';
import 'package:fast_parking_system/src/screens/login.dart';
import 'package:fast_parking_system/src/screens/qr_code.dart';
import 'package:fast_parking_system/src/screens/profile.dart';
import 'package:fast_parking_system/src/screens/wallet_admin_detail.dart';
import 'package:fast_parking_system/src/screens/wallet_admin_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fast_parking_system/src/services/api_service.dart';
import 'package:http/http.dart' as http;

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  static const routeName = '/account';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Account> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  late Locations? _locations = null;
  final storage = const FlutterSecureStorage();
  int _selectedIndex = 1;
  late int? selectedLocationId = null;
  late String? selectedGender = null;

  @override
  void initState() {
    super.initState();
    getLocations();
  }

  void getLocations() async {
    _locations = (await ApiService().getLocations())!;
    print(_locations);
    setState(() {});
  }

  Future<void> sendRegisterRequest() async {
    var url = Uri.parse(ApiConstants.url + ApiConstants.register);
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "full_name": fullNameController.text,
          "mobile": phoneController.text,
          "location_id": selectedLocationId,
          "gender": selectedGender,
          "password": passwordController.text,
          "is_admin": false
        }));

    if (response.statusCode == 200) {
      // var data = json.decode(response.body.toString());
      Register model = registerFromJson(response.body);

      // Save auth/login data to storage
      // await storage.write(key: 'token', value: data['data']['token']);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Create Account Success! User Id = ${model.data.userId}"),
      ));
      // Navigator.restorablePushNamed(context, Home.routeName);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Create Account Failed"),
      ));
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.restorablePushNamed(context, Home.routeName);
        break;
      case 1:
        Navigator.restorablePushNamed(context, Account.routeName);
        break;
      case 2:
        Navigator.restorablePushNamed(context, Wallet.routeName);
        break;
      case 3:
        Navigator.restorablePushNamed(context, Profile.routeName);
        break;
      case 4:
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(217, 217, 217, 1),
          automaticallyImplyLeading: false,
          title: const Text(
            'FPS',
            style: TextStyle(color: Colors.black, fontSize: 30.0),
          ),
          actions: [
            IconButton(
              icon: const Image(image: AssetImage('assets/images/logout.png')),
              onPressed: () async {
                // Navigate to the logout page. If the user leaves and returns
                // to the app after it has been killed while running in the
                // background, the navigation stack is restored.
                await storage.delete(key: 'token');
                Navigator.restorablePushNamed(context, Login.routeName);
              },
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Image(image: AssetImage('assets/images/home.png')),
                label: 'Account'),
            BottomNavigationBarItem(
                icon: Image(image: AssetImage('assets/images/account.png')),
                label: 'Add Account'),
            BottomNavigationBarItem(
                icon: Image(image: AssetImage('assets/images/wallet.png')),
                label: 'Wallet'),
            BottomNavigationBarItem(
                icon: Image(image: AssetImage('assets/images/user.png')),
                label: 'Profile'),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: const Color.fromRGBO(60, 95, 107, 1),
          onTap: _onItemTapped,
        ),
        body: SingleChildScrollView(
            child: Container(
          padding: const EdgeInsets.all(20),
          color: const Color.fromRGBO(60, 95, 107, 1),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
                color: Color.fromRGBO(217, 217, 217, 1),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Container(
                      margin: const EdgeInsets.only(bottom: 20.0),
                      child: const Text(
                        "Fast Parking System",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                            fontWeight: FontWeight.normal),
                      )),
                  Form(
                      child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 40.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 20.0),
                          child: TextFormField(
                            controller: fullNameController,
                            style: const TextStyle(color: Colors.black),
                            decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.person_outline_outlined),
                                prefixIconColor: Colors.black,
                                filled: true,
                                fillColor: Colors.white,
                                labelText: 'Nama Lengkap',
                                labelStyle: TextStyle(color: Colors.black),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 2))),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 20.0),
                          child: TextFormField(
                            controller: phoneController,
                            style: const TextStyle(color: Colors.black),
                            decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.phone),
                                prefixIconColor: Colors.black,
                                fillColor: Colors.white,
                                filled: true,
                                labelText: 'No HP',
                                labelStyle: TextStyle(color: Colors.black),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 2))),
                          ),
                        ),

                        // Location dropdown
                        Container(
                          margin: const EdgeInsets.only(bottom: 20.0),
                          child: DropdownButtonFormField<int>(
                            value: selectedLocationId,
                            items: _locations?.data.map((location) {
                                  return DropdownMenuItem<int>(
                                    value: location.id,
                                    child: Text(location.name),
                                  );
                                }).toList() ??
                                [],
                            onChanged: (value) {
                              setState(() {
                                selectedLocationId = value!;
                              });
                            },
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.location_on),
                              labelText: 'Lokasi',
                              hintText: 'Lokasi',
                              prefixIconColor: Colors.black,
                              filled: true,
                              fillColor: Colors.white,
                              labelStyle: TextStyle(color: Colors.black),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Gender dropdown
                        Container(
                          margin: const EdgeInsets.only(bottom: 20.0),
                          child: DropdownButtonFormField<String>(
                            value: selectedGender,
                            items: ['Laki-Laki', 'Perempuan'].map((gender) {
                              return DropdownMenuItem<String>(
                                value: gender,
                                child: Text(gender),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedGender = value!;
                              });
                            },
                            decoration: InputDecoration(
                              prefixIcon: selectedGender == 'Laki-Laki'
                                  ? const Icon(Icons.male)
                                  : const Icon(Icons.female),
                              labelText: 'Jenis Kelamin',
                              hintText: 'Jenis Kelamin',
                              prefixIconColor: Colors.black,
                              filled: true,
                              fillColor: Colors.white,
                              labelStyle: const TextStyle(color: Colors.black),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 20.0),
                          child: TextFormField(
                            controller: passwordController,
                            style: const TextStyle(color: Colors.black),
                            decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.fingerprint),
                                prefixIconColor: Colors.black,
                                fillColor: Colors.white,
                                filled: true,
                                labelText: 'Password',
                                labelStyle: TextStyle(color: Colors.black),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 2))),
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
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              fixedSize: const Size(200, 50),
                              padding: const EdgeInsets.all(10.0),
                              textStyle: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                              shape: const StadiumBorder(),
                              side: const BorderSide(
                                  color: Colors.white, width: 2)),
                          onPressed: sendRegisterRequest,
                          // onPressed: () {
                          //   // Navigate to the settings page. If the user leaves and returns
                          //   // to the app after it has been killed while running in the
                          //   // background, the navigation stack is restored.
                          //   Navigator.restorablePushNamed(context, Home.routeName);
                          // },
                          child: Text(
                            'Create'.toUpperCase(),
                            style: const TextStyle(color: Colors.white),
                          )))
                ])),
          ),
        )));
  }
}
