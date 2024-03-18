import 'package:admin_perpustakaan/screens/buku_tamu/buku_tamu.dart';
import 'package:admin_perpustakaan/services/FirebaseServices.dart';
import 'package:flutter/material.dart';
import 'package:admin_perpustakaan/screens/data_anggota/data_anggota.dart';
import 'package:admin_perpustakaan/screens/data_buku/data_buku.dart';
import 'package:admin_perpustakaan/screens/peminjaman/peminjaman.dart';
import 'package:admin_perpustakaan/screens/pengembalian/pengembalian.dart';
import 'package:admin_perpustakaan/screens/scan/scan.dart';
import 'package:admin_perpustakaan/widget/gambar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

// Future<Widget> LogOut() async {
//   final fs = FirebaseServices();

//   await fs.(
//                               emailTxt, passTxt);
//   return Container();
// }

class _DashboardScreenState extends State<DashboardScreen> {
  //setting the expansion function for the navigation rail
  bool isExpanded = true;
  int index = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NavigationRail(
              leading: Container(
                margin: const EdgeInsets.only(top: 5, bottom: 2),
                child: Wrap(direction: Axis.vertical, children: [
                  Wrap(
                    spacing: 5.0,
                    runSpacing: 3.0,
                    direction: Axis.horizontal,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage: AssetImage(gambar.logo),
                      ),
                      const Wrap(
                        direction: Axis.vertical,
                        children: [
                          Text(
                            'Perpustakaan Wilayah',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Sulawesi Selatan',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                    width: 200,
                    child: Divider(color: Colors.white),
                  ),
                ]),
              ),
              extended: isExpanded,
              backgroundColor: Colors.blue.shade700,
              unselectedIconTheme:
                  const IconThemeData(color: Colors.white, opacity: 1),
              unselectedLabelTextStyle: const TextStyle(
                color: Colors.white,
              ),
              selectedIconTheme: IconThemeData(color: Colors.blue.shade300),
              onDestinationSelected: (value) {
                setState(() {
                  index = value;
                });
              },
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.qr_code),
                  label: Text("Scan"),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.book),
                  label: Text("Data Buku"),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.bookmark_remove),
                  label: Text("Peminjaman"),
                ),
                // NavigationRailDestination(
                //   icon: Icon(Icons.person),
                //   label: Text("Profile"),
                // ),
                NavigationRailDestination(
                  icon: Icon(Icons.bookmark_add),
                  label: Text("Pengembalian"),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.menu_book),
                  label: Text("Buku tamu"),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.group),
                  label: Text("Data Anggota"),
                ),
                // NavigationRailDestination(
                //   icon: Icon(Icons.logout),
                //   label: Text("Log out"),
                // ),
              ],
              selectedIndex: index),
          index == 0
              ? const Scan()
              : index == 1
                  ? const DataBuku()
                  : index == 2
                      ? const Peminjaman()
                      : index == 3
                          ? const Pengembalian()
                          : index == 4
                              ? const BukuTamu()
                              : const DataAnggota()
        ],
      ),
    );
  }
}
