import 'dart:convert';
import 'package:fast_parking_system/src/screens/account.dart';
import 'package:fast_parking_system/src/screens/home_attendant.dart';
import 'package:fast_parking_system/src/screens/wallet_attendant.dart';
import 'package:flutter/material.dart';
import 'package:fast_parking_system/src/models/whoami_model.dart';
import 'package:fast_parking_system/src/screens/profile.dart';
import 'package:fast_parking_system/src/screens/login.dart';
import 'package:fast_parking_system/src/services/api_service.dart';

class AttendantAdded extends StatefulWidget {
  final int userId;

  const AttendantAdded({Key? key, required this.userId}) : super(key: key);

  static const routeName = '/attendant-added';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<AttendantAdded> {
  late WhoAmI? _attendantDetail = null;
  int _selectedIndex = 1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getAttendantDetail();
  }

  void getAttendantDetail() async {
    _attendantDetail =
        (await ApiService().getAttendantDetail(userId: widget.userId))!;
    if (mounted) {
      setState(() {});
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.restorablePushNamed(context, HomeAttendant.routeName);
        break;
      case 1:
        Navigator.restorablePushNamed(context, Account.routeName);
        break;
      case 2:
        Navigator.restorablePushNamed(context, WalletAttendant.routeName);
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
        body: _attendantDetail == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                padding: const EdgeInsets.all(20),
                color: const Color(0xFF3C5F6B),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Image(
                          image: AssetImage('assets/images/avatar.png')),
                      Container(
                        margin: const EdgeInsets.only(bottom: 20.0),
                        child: Text(
                          _attendantDetail!.data.fullName,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 20.0),
                        child: Text(
                          "Lokasi ${_attendantDetail!.data.location}",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 20.0),
                        child: Text(
                          "User ID ${_attendantDetail!.data.id}",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      Image.memory(
                        base64Decode(_attendantDetail!.data.qrCode),
                        width: double.infinity,
                        height: 200,
                      ),
                    ],
                  ),
                ),
              ));
  }
}
