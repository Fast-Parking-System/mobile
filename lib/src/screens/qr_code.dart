import 'dart:convert';

import 'package:fast_parking_system/src/models/locations_model.dart';
import 'package:fast_parking_system/src/models/pokemon_model.dart';
import 'package:fast_parking_system/src/models/whoami_model.dart';
import 'package:fast_parking_system/src/sample_feature/sample_item_list_view.dart';
import 'package:fast_parking_system/src/screens/account.dart';
import 'package:fast_parking_system/src/screens/home.dart';
import 'package:fast_parking_system/src/screens/profile.dart';
import 'package:fast_parking_system/src/screens/login.dart';
import 'package:fast_parking_system/src/screens/qr_code.dart';
import 'package:fast_parking_system/src/screens/wallet.dart';
import 'package:fast_parking_system/src/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class QRCode extends StatefulWidget {
  const QRCode({Key? key}) : super(key: key);

  static const routeName = '/qr-code';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<QRCode> {
  TextEditingController searchController = TextEditingController();
  late Pokemon? _pokemon = null;
  late WhoAmI? _whoami = null;
  final storage = const FlutterSecureStorage();
  int _selectedIndex = 2;

  @override
  void initState() {
    super.initState();
    _readAll();
    getWhoAmI();
  }

  void getWhoAmI() async {
    _whoami = (await ApiService().getWhoAmI())!;
    print(_whoami);
    setState(() {});
  }

  Future<void> _readAll() async {
    // Read value
    String? token = await storage.read(key: 'token');
    print('token:  $token');
    // Read all values
    Map<String, String> allValues = await storage.readAll();
    print(allValues);
    // setState(() {
    //   _items = all.entries
    //       .map((entry) => _SecItem(entry.key, entry.value))
    //       .toList(growable: false);
    // });
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
        Navigator.restorablePushNamed(context, QRCode.routeName);
        break;
      case 3:
        Navigator.restorablePushNamed(context, Wallet.routeName);
        break;
      case 4:
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
            // : GridView.count(
            //         crossAxisCount: 2,
            //         children: List.generate(_whoami!.data.length, (index) {
            //           return Column(
            //             children: [
            //               const Image(image: AssetImage('assets/images/location.png')),
            //               Center(
            //                 child: Text(
            //                   _whoami!.data[index].name.toUpperCase(),
            //                   style: Theme.of(context).textTheme.headlineSmall,
            //                 ),
            //               )
            //             ],
            //           );
            //         }),
            //       ),
            : Container(
                // ... Your existing code ...
                child: Column(
                  children: [
                    // ... Your existing code ...

                    // Add this part to display the base64 image
                    const SizedBox(height: 30),
                    _whoami!.data.qrCode != null
                        ? Image.memory(
                            base64Decode(_whoami!.data.qrCode!),
                            width: 200.0,
                            height: 200.0,
                          )
                        : const SizedBox.shrink(),

                    // ... Your existing code ...
                  ],
                ),
              ));
  }
}
