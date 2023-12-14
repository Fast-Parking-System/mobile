import 'package:fast_parking_system/src/models/whoami_model.dart';
import 'package:fast_parking_system/src/screens/account.dart';
import 'package:fast_parking_system/src/screens/home.dart';
import 'package:fast_parking_system/src/screens/home_attendant.dart';
import 'package:fast_parking_system/src/screens/login.dart';
import 'package:fast_parking_system/src/screens/qr_code.dart';
import 'package:fast_parking_system/src/screens/wallet_admin_detail.dart';
import 'package:fast_parking_system/src/screens/wallet_admin_list.dart';
import 'package:fast_parking_system/src/screens/wallet_attendant.dart';
import 'package:fast_parking_system/src/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  static const routeName = '/profile';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Profile> {
  TextEditingController searchController = TextEditingController();
  late WhoAmI? _whoami = null;
  final storage = const FlutterSecureStorage();
  int _selectedIndex = 3;
  String isAdmin = 'false';

  @override
  void initState() {
    super.initState();
    _readAll();
    getWhoAmI();
  }

  void getWhoAmI() async {
    _whoami = (await ApiService().getWhoAmI())!;
    // print(_whoami);
    setState(() {});
  }

  Future<void> _readAll() async {
    // Read value
    String? token = await storage.read(key: 'token');
    // print('token:  $token');
    isAdmin = (await storage.read(key: 'isAdmin'))!;
    // Read all values
    Map<String, String> allValues = await storage.readAll();
    // print(allValues);
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
    // print('isAdmin => $isAdmin');
    switch (index) {
      case 0:
        isAdmin == 'true'
            ? Navigator.restorablePushNamed(context, Home.routeName)
            : Navigator.restorablePushNamed(context, HomeAttendant.routeName);
        break;
      case 1:
        isAdmin == 'true'
            ? Navigator.restorablePushNamed(context, Account.routeName)
            : Navigator.restorablePushNamed(context, QRCode.routeName);
        break;
      case 2:
        isAdmin == 'true'
            ? Navigator.restorablePushNamed(context, Wallet.routeName)
            : Navigator.push(
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
          items: <BottomNavigationBarItem>[
            const BottomNavigationBarItem(
                icon: Image(image: AssetImage('assets/images/home.png')),
                label: 'Home'),
            BottomNavigationBarItem(
                icon: (isAdmin == 'true')
                    ? const Image(
                        image: AssetImage('assets/images/account.png'))
                    : const Image(image: AssetImage('assets/images/qr.png')),
                label: (isAdmin == 'true') ? 'Add Account' : 'QR Code'),
            const BottomNavigationBarItem(
                icon: Image(image: AssetImage('assets/images/wallet.png')),
                label: 'Wallet'),
            const BottomNavigationBarItem(
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
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                color: const Color.fromRGBO(60, 95, 107, 1),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                      color: Color.fromRGBO(217, 217, 217, 1),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: LayoutBuilder(builder: (context, constraints) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints(minHeight: constraints.maxHeight),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Image(
                                image: AssetImage('assets/images/avatar.png')),
                            Text(
                              "Hi ${_whoami!.data.fullName} !",
                              style: const TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ), //<------------
                            Container(
                              margin: const EdgeInsets.only(top: 10),
                              child: SizedBox(
                                width: double.infinity,
                                height: 5,
                                // height: double.infinity,
                                child: Container(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.only(top: 10, bottom: 10),
                              child: const Text(
                                "Info Profile",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ), //<------------
                            ListTile(
                                leading: const CircleAvatar(child: Text('N')),
                                title: const Text(
                                  'Nama',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                subtitle: Text(
                                  _whoami!.data.fullName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black),
                                )),
                            ListTile(
                                leading: const CircleAvatar(child: Text('I')),
                                title: const Text(
                                  'User ID',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                subtitle: Text(
                                  _whoami!.data.id,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black),
                                )),
                            ListTile(
                                leading: const CircleAvatar(child: Text('J')),
                                title: const Text(
                                  'Jenis Kelamin',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                subtitle: Text(
                                  _whoami!.data.gender,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black),
                                )),
                            if (isAdmin == 'false')
                              ListTile(
                                  leading: Image.asset(
                                    'assets/images/location.png',
                                    width: 40,
                                  ),
                                  title: const Text(
                                    'Lokasi Bekerja',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  subtitle: Text(
                                    _whoami!.data.location,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black),
                                  ))
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ));
  }
}

            // : Container(
            //     width: double.infinity,
            //     padding: const EdgeInsets.all(20),
            //     color: const Color.fromRGBO(60, 95, 107, 1),
            //     child: Container(
            //       padding: const EdgeInsets.all(10),
            //       decoration: const BoxDecoration(
            //           color: Color.fromRGBO(217, 217, 217, 1),
            //           borderRadius: BorderRadius.all(Radius.circular(20))),
            //       child: SingleChildScrollView(
            //           child: Column(
            //         children: [
            //           const Image(
            //               image: AssetImage('assets/images/avatar.png')),
            //           Text(
            //             "Hi ${_whoami!.data.fullName} !",
            //             style: const TextStyle(
            //                 fontSize: 50,
            //                 fontWeight: FontWeight.w500,
            //                 color: Colors.black),
            //           ), //<------------
            //           SizedBox(
            //             width: double.infinity,
            //             height: 5,
            //             // height: double.infinity,
            //             child: Container(
            //               color: Colors.black,
            //             ),
            //           ),
            //           const Text(
            //             "Info Profile",
            //             style: TextStyle(
            //                 fontSize: 30,
            //                 fontWeight: FontWeight.w500,
            //                 color: Colors.black),
            //           ), //<------------
            //           Row(
            //             mainAxisAlignment: MainAxisAlignment.start,
            //             textDirection: TextDirection.ltr,
            //             children: [
            //               Container(
            //                 width: 50.0,
            //                 height: 50.0,
            //                 margin:
            //                     const EdgeInsets.only(left: 10.0, right: 30.0),
            //                 decoration: const BoxDecoration(
            //                     // color: Color.fromRGBO(131, 130, 130, 1),
            //                     color: Color(0xff93A0AE),
            //                     borderRadius:
            //                         BorderRadius.all(Radius.circular(10))),
            //               ),
            //               Column(children: [
            //                 const Text(
            //                   "Nama",
            //                   textAlign: TextAlign.left,
            //                   style: TextStyle(
            //                       fontSize: 30,
            //                       fontWeight: FontWeight.w500,
            //                       color: Colors.black),
            //                 ), //<------------
            //                 Text(
            //                   _whoami!.data.fullName,
            //                   style: const TextStyle(
            //                       fontSize: 30,
            //                       fontWeight: FontWeight.w500,
            //                       color: Colors.black),
            //                 ), //<------------
            //               ])
            //             ],
            //           ),
            //           const SizedBox(height: 30),
            //           Row(
            //             children: [
            //               Container(
            //                 width: 50.0,
            //                 height: 50.0,
            //                 margin:
            //                     const EdgeInsets.only(left: 10.0, right: 30.0),
            //                 decoration: const BoxDecoration(
            //                     // color: Color.fromRGBO(131, 130, 130, 1),
            //                     color: Color(0xff93A0AE),
            //                     borderRadius:
            //                         BorderRadius.all(Radius.circular(10))),
            //               ),
            //               Column(children: [
            //                 const Text(
            //                   "User ID",
            //                   textAlign: TextAlign.left,
            //                   style: TextStyle(
            //                       fontSize: 30,
            //                       fontWeight: FontWeight.w500,
            //                       color: Colors.black),
            //                 ), //<------------
            //                 Text(
            //                   _whoami!.data.id,
            //                   textAlign: TextAlign.left,
            //                   style: const TextStyle(
            //                       fontSize: 30,
            //                       fontWeight: FontWeight.w500,
            //                       color: Colors.black),
            //                 ), //<------------
            //               ])
            //             ],
            //           ),
            //           const SizedBox(height: 30),
            //           Row(
            //             children: [
            //               Container(
            //                 width: 50.0,
            //                 height: 50.0,
            //                 margin:
            //                     const EdgeInsets.only(left: 10.0, right: 30.0),
            //                 decoration: const BoxDecoration(
            //                     // color: Color.fromRGBO(131, 130, 130, 1),
            //                     color: Color(0xff93A0AE),
            //                     borderRadius:
            //                         BorderRadius.all(Radius.circular(10))),
            //               ),
            //               Column(children: [
            //                 const Text(
            //                   "Jenis Kelamin",
            //                   textAlign: TextAlign.left,
            //                   style: TextStyle(
            //                       fontSize: 30,
            //                       fontWeight: FontWeight.w500,
            //                       color: Colors.black),
            //                 ), //<------------
            //                 Text(
            //                   _whoami!.data.gender,
            //                   textAlign: TextAlign.left,
            //                   style: const TextStyle(
            //                       fontSize: 30,
            //                       fontWeight: FontWeight.w500,
            //                       color: Colors.black),
            //                 ), //<------------
            //               ])
            //             ],
            //           )
            //         ],
            //       )),
            //     ),
            //   ));
//   }