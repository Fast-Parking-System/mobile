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
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<AttendantsScreen> {
  TextEditingController searchController = TextEditingController();
  late Attendants? _attendants = null;
  final storage = const FlutterSecureStorage();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _readAll();
    getAttendants();
  }

  void getAttendants() async {
    _attendants = (await ApiService().getAttendants())!;
    print('attendants');
    print(_attendants);
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
            // : GridView.count(
            //         crossAxisCount: 2,
            //         children: List.generate(_locations!.data.length, (index) {
            //           return Column(
            //             children: [
            //               const Image(image: AssetImage('assets/images/location.png')),
            //               Center(
            //                 child: Text(
            //                   _locations!.data[index].name.toUpperCase(),
            //                   style: Theme.of(context).textTheme.headlineSmall,
            //                 ),
            //               )
            //             ],
            //           );
            //         }),
            //       ),
            : Container(
                padding: const EdgeInsets.all(20),
                color: const Color.fromRGBO(60, 95, 107, 1),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                      color: Color.fromRGBO(217, 217, 217, 1),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: ListView.builder(
                    // Providing a restorationId allows the ListView to restore the
                    // scroll position when a user leaves and returns to the app after it
                    // has been killed while running in the background.
                    restorationId: 'sampleItemListView',
                    itemCount: _attendants!.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = _attendants?.data[index];
                      print(item);

                      return ListTile(
                          title: Text('SampleItem ${item?.id}'),
                          leading: const CircleAvatar(
                            // Display the Flutter Logo image asset.
                            foregroundImage:
                                AssetImage('assets/images/flutter_logo.png'),
                          ),
                          onTap: () {
                            // Navigate to the details page. If the user leaves and returns to
                            // the app after it has been killed while running in the
                            // background, the navigation stack is restored.
                            // Navigator.restorablePushNamed(
                            //   context,
                            //   SampleItemDetailsView.routeName,
                            // );
                          });
                    },
                  ),
                ),
              ));
  }
}
