import 'dart:convert';
import 'package:fast_parking_system/src/screens/home_attendant.dart';
import 'package:fast_parking_system/src/screens/wallet_attendant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fast_parking_system/src/models/whoami_model.dart';
import 'package:fast_parking_system/src/screens/profile.dart';
import 'package:fast_parking_system/src/screens/login.dart';
import 'package:fast_parking_system/src/services/api_service.dart';

class QRCode extends StatefulWidget {
  const QRCode({Key? key}) : super(key: key);

  static const routeName = '/qr-code';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<QRCode> {
  TextEditingController searchController = TextEditingController();
  late WhoAmI? _whoami = null;
  final storage = const FlutterSecureStorage();
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    getWhoAmI();
  }

  void getWhoAmI() async {
    _whoami = (await ApiService().getWhoAmI())!;
    setState(() {});
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
        Navigator.restorablePushNamed(context, QRCode.routeName);
        break;
      case 2:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    WalletAttendant(userId: _whoami!.data.id)));
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
                icon: Image(image: AssetImage('assets/images/qr.png')),
                label: 'Show QR'),
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
        body: _whoami == null
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 20.0),
                        child: Text(
                          "Lokasi ${_whoami!.data.location}",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      Image.memory(
                        base64Decode(_whoami!.data.qrCode),
                        width: double.infinity,
                        height: 400,
                      ),
                    ],
                  ),
                ),
              ));
  }
}
