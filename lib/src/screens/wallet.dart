import 'package:fast_parking_system/src/models/analytics_model.dart';
import 'package:fast_parking_system/src/screens/account.dart';
import 'package:fast_parking_system/src/screens/home.dart';
import 'package:fast_parking_system/src/screens/login.dart';
import 'package:fast_parking_system/src/screens/qr_code.dart';
import 'package:fast_parking_system/src/screens/profile.dart';
import 'package:fast_parking_system/src/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Wallet extends StatefulWidget {
  const Wallet({Key? key}) : super(key: key);

  static const routeName = '/wallet';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Wallet> {
  TextEditingController searchController = TextEditingController();
  late Analytics? _analytics = null;
  final storage = const FlutterSecureStorage();
  int _selectedIndex = 3;

  @override
  void initState() {
    super.initState();
    getAnalytics();
  }

  void getAnalytics() async {
    _analytics = (await ApiService().getAnalytics())!;
    setState(() {});
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
        body: _analytics == null
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
                  child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      controller: ScrollController(),
                      child: Column(
                        children: [
                          // Daily Analytics
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Daily Analytics',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Table(
                            border: TableBorder.all(
                                color: Colors.grey[
                                    300]!), // Set border color to a lighter shade of grey
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                            children: [
                              const TableRow(
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(60, 95, 107,
                                      1), // Darker color for headers
                                ),
                                children: [
                                  TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'Date',
                                        style: TextStyle(
                                            color: Colors
                                                .white), // White text for headers
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'Amount',
                                        style: TextStyle(
                                            color: Colors
                                                .white), // White text for headers
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              ..._analytics?.data.daily.map(
                                    (daily) => TableRow(
                                      children: [
                                        TableCell(
                                          verticalAlignment:
                                              TableCellVerticalAlignment.middle,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              daily.date,
                                              style: const TextStyle(
                                                  color: Colors
                                                      .black87), // Adjust text color as needed
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          verticalAlignment:
                                              TableCellVerticalAlignment.middle,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "Rp${daily.amount.toString()}",
                                              style: const TextStyle(
                                                  color: Colors
                                                      .black87), // Adjust text color as needed
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ) ??
                                  [
                                    const TableRow(children: [Text('No data')])
                                  ]
                            ],
                          ),
                          // Weekly Analytics
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Weekly Analytics',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors
                                        .black, // Adjust title text color as needed
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Table(
                            border: TableBorder.all(
                                color: Colors.grey[
                                    300]!), // Set border color to a lighter shade of grey
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                            children: [
                              const TableRow(
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(60, 95, 107,
                                      1), // Darker color for headers
                                ),
                                children: [
                                  TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'Start Date',
                                        style: TextStyle(
                                            color: Colors
                                                .white), // White text for headers
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'End Date',
                                        style: TextStyle(
                                            color: Colors
                                                .white), // White text for headers
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'Amount',
                                        style: TextStyle(
                                            color: Colors
                                                .white), // White text for headers
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              ..._analytics?.data.weekly.map(
                                    (weekly) => TableRow(
                                      children: [
                                        TableCell(
                                          verticalAlignment:
                                              TableCellVerticalAlignment.middle,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              weekly.startDate,
                                              style: const TextStyle(
                                                  color: Colors
                                                      .black87), // Adjust text color as needed
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          verticalAlignment:
                                              TableCellVerticalAlignment.middle,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              weekly.endDate,
                                              style: const TextStyle(
                                                  color: Colors
                                                      .black87), // Adjust text color as needed
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          verticalAlignment:
                                              TableCellVerticalAlignment.middle,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "Rp${weekly.amount.toString()}",
                                              style: const TextStyle(
                                                  color: Colors
                                                      .black87), // Adjust text color as needed
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ) ??
                                  [
                                    const TableRow(children: [Text('No data')])
                                  ]
                            ],
                          ),
                          // Monthly Analytics
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Monthly Analytics',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors
                                        .black, // Adjust title text color as needed
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Table(
                            border: TableBorder.all(
                                color: Colors.grey[
                                    300]!), // Set border color to a lighter shade of grey
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                            children: [
                              const TableRow(
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(60, 95, 107,
                                      1), // Darker color for headers
                                ),
                                children: [
                                  TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'Month',
                                        style: TextStyle(
                                            color: Colors
                                                .white), // White text for headers
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'Amount',
                                        style: TextStyle(
                                            color: Colors
                                                .white), // White text for headers
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              ..._analytics?.data.monthly.map(
                                    (monthly) => TableRow(
                                      children: [
                                        TableCell(
                                          verticalAlignment:
                                              TableCellVerticalAlignment.middle,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              monthly.month,
                                              style: const TextStyle(
                                                  color: Colors
                                                      .black87), // Adjust text color as needed
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          verticalAlignment:
                                              TableCellVerticalAlignment.middle,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "Rp${monthly.amount.toString()}",
                                              style: const TextStyle(
                                                  color: Colors
                                                      .black87), // Adjust text color as needed
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ) ??
                                  [
                                    const TableRow(children: [Text('No data')])
                                  ]
                            ],
                          ),
                          // Yearly Analytics
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Yearly Analytics',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors
                                        .black, // Adjust title text color as needed
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Table(
                            border: TableBorder.all(
                                color: Colors.grey[
                                    300]!), // Set border color to a lighter shade of grey
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                            children: [
                              const TableRow(
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(60, 95, 107,
                                      1), // Darker color for headers
                                ),
                                children: [
                                  TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'Year',
                                        style: TextStyle(
                                            color: Colors
                                                .white), // White text for headers
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'Amount',
                                        style: TextStyle(
                                            color: Colors
                                                .white), // White text for headers
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              ..._analytics?.data.yearly.map(
                                    (yearly) => TableRow(
                                      children: [
                                        TableCell(
                                          verticalAlignment:
                                              TableCellVerticalAlignment.middle,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              yearly.year.toString(),
                                              style: const TextStyle(
                                                  color: Colors
                                                      .black87), // Adjust text color as needed
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          verticalAlignment:
                                              TableCellVerticalAlignment.middle,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "Rp${yearly.amount.toString()}",
                                              style: const TextStyle(
                                                  color: Colors
                                                      .black87), // Adjust text color as needed
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ) ??
                                  [
                                    const TableRow(children: [Text('No data')])
                                  ]
                            ],
                          )
                        ],
                      )),
                ),
              ));
  }
}
