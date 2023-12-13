import 'dart:convert';

import 'package:fast_parking_system/src/models/attendants_model.dart';
import 'package:fast_parking_system/src/screens/account.dart';
import 'package:fast_parking_system/src/screens/home.dart';
import 'package:fast_parking_system/src/screens/login.dart';
import 'package:fast_parking_system/src/screens/profile.dart';
import 'package:fast_parking_system/src/screens/wallet.dart';
import 'package:fast_parking_system/src/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AttendantsScreen extends StatefulWidget {
  const AttendantsScreen({Key? key}) : super(key: key);

  static const routeName = '/attendants';

  @override
  _AttendantsScreenState createState() => _AttendantsScreenState();
}

class _AttendantsScreenState extends State<AttendantsScreen> {
  TextEditingController searchController = TextEditingController();
  late Attendants? _attendants = null;
  final storage = const FlutterSecureStorage();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _readAll();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getAttendants();
  }

  void getAttendants() async {
    final dynamic argument = ModalRoute.of(context)?.settings.arguments;

    if (argument is int) {
      _attendants = await ApiService().getAttendants(
        locationId: argument,
      );
    }

    setState(() {});
  }

  Future<void> _readToken() async {}

  Future<void> _readAll() async {
    String? token = await storage.read(key: 'token');
    print('token:  $token');

    Map<String, String> allValues = await storage.readAll();
    print(allValues);
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
                await storage.delete(key: 'token');
                Navigator.restorablePushNamed(context, Login.routeName);
              },
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color.fromRGBO(217, 217, 217, 1),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Image(image: AssetImage('assets/images/home.png')),
                label: 'Home'),
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
        body: _attendants == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                padding: const EdgeInsets.all(20),
                color: const Color.fromRGBO(60, 95, 107, 1),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                      color: Color.fromRGBO(217, 217, 217, 1),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: ListView.builder(
                    restorationId: 'sampleItemListView',
                    itemCount: _attendants!.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = _attendants?.data[index];

                      return ListTile(
                          title: Text('${item?.fullName}'.toUpperCase()),
                          titleTextStyle: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                          leading: Image.asset(
                            'assets/images/avatar.png',
                            height: 100,
                          ),
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${item?.location}',
                                style: const TextStyle(color: Colors.black),
                              ),
                              Text(
                                '${item?.id}',
                                style: const TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                          trailing: Image.memory(
                            base64Decode(item!.qrCode),
                            width: 100,
                            height: 100,
                          ),
                          onTap: () {});
                    },
                  ),
                ),
              ));
  }
}
