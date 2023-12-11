import 'package:fast_parking_system/src/models/locations_model.dart';
import 'package:fast_parking_system/src/models/whoami_model.dart';
import 'package:fast_parking_system/src/screens/login.dart';
import 'package:fast_parking_system/src/screens/qr_code.dart';
import 'package:fast_parking_system/src/screens/profile.dart';
import 'package:fast_parking_system/src/screens/wallet_attendant.dart';
import 'package:fast_parking_system/src/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HomeAttendant extends StatefulWidget {
  const HomeAttendant({Key? key}) : super(key: key);

  static const routeName = '/home_attendant';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomeAttendant> {
  TextEditingController searchController = TextEditingController();
  late WhoAmI? _whoami = null;
  late Locations? _locations = null;
  final storage = const FlutterSecureStorage();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _readAll();
    getLocations();
    getWhoAmI();
  }

  void getWhoAmI() async {
    _whoami = (await ApiService().getWhoAmI())!;
    print(_whoami);
    setState(() {});
  }

  void getLocations() async {
    _locations = (await ApiService().getLocations())!;
    print(_locations);
    setState(() {});
  }

  Future<void> _readToken() async {}

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
        Navigator.restorablePushNamed(context, HomeAttendant.routeName);
        break;
      case 1:
        Navigator.restorablePushNamed(context, QRCode.routeName);
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
          backgroundColor: const Color.fromRGBO(217, 217, 217, 1),
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
        body: _locations == null
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
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(bottom: 50.0),
                        width: double.infinity,
                        child: Text(
                          "Hi ${_whoami!.data.fullName}",
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 50,
                              fontWeight: FontWeight.w500),
                        ),
                      ), //<------------
                      Image.asset('assets/images/location_lg.png'),
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(top: 50.0),
                        width: double.infinity,
                        child: Text(
                          _whoami!.data.location,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 50,
                              fontWeight: FontWeight.w500),
                        ),
                      ), //<------------
                    ],
                  ),
                ),
              ));
  }
}
