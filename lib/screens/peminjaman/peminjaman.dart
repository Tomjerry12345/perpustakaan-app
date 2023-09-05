import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:web_dashboard_app_tut/services/FirebaseServices.dart';
import 'package:web_dashboard_app_tut/widget/header/header_widget.dart';

class Peminjaman extends StatefulWidget {
  const Peminjaman({Key? key}) : super(key: key);

  @override
  State<Peminjaman> createState() => _PeminjamanState();
}

class _PeminjamanState extends State<Peminjaman> {
  final firebaseServices = FirebaseServices();

  // final List<Map<String, String>> data = [
  //   {
  //     "nama_peminjam": "Amrul",
  //     "judul_buku": "One piece",
  //     "tanggal_peminjaman": "20/11/2023",
  //     "tanggal_pengembalian": "21/11/2023"
  //   },
  //   {
  //     "nama_peminjam": "Amrul",
  //     "judul_buku": "One piece",
  //     "tanggal_peminjaman": "23/11/2023",
  //     "tanggal_pengembalian": "24/11/2023"
  //   },
  //   {
  //     "nama_peminjam": "Andri",
  //     "judul_buku": "One piece",
  //     "tanggal_peminjaman": "25/11/2023",
  //     "tanggal_pengembalian": "26/11/2023"
  //   }
  // ];

  Map<String, List<Map<String, String>>> groupDataByPeminjam(
      List<QueryDocumentSnapshot<Object?>>? data) {
    Map<String, List<Map<String, String>>> groupedData = {};

    if (data == null) {
      return groupedData; // Jika data null, langsung kembalikan groupedData kosong
    }

    for (var item in data) {
      Map<String, dynamic> d = item.data() as Map<String, dynamic>;
      String namaPeminjam = d["nama_peminjam"];
      if (!groupedData.containsKey(namaPeminjam)) {
        groupedData[namaPeminjam] = [d.cast<String, String>()];
      } else {
        groupedData[namaPeminjam]!.add(d.cast<String, String>());
      }
    }
    return groupedData;
  }

  List<DataRow> _buildDataTableRows(List<Map<String, String>> peminjamData) {
    List<DataRow> rows = [];
    for (var item in peminjamData) {
      rows.add(
        DataRow(cells: [
          DataCell(Text(item['judul_buku']!)),
          DataCell(Text(item['pengarang']!)),
          DataCell(Text(item['rak']!)),
        ]),
      );
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(children: [
        HeaderWidget(title: "Peminjaman"),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
              stream: firebaseServices.getAllStream("peminjaman"),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final snap = snapshot.data;
                  final data = snap?.docs;
                  Map<String, List<Map<String, String>>> groupedData = groupDataByPeminjam(data);
                  return ListView.builder(
                    itemCount: groupedData.length,
                    itemBuilder: (context, index) {
                      String namaPeminjam = groupedData.keys.elementAt(index);
                      List<Map<String, String>> peminjamData = groupedData[namaPeminjam]!;
                      return ExpansionTile(
                        backgroundColor: Colors.blue,
                        title: Text(namaPeminjam),
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columns: [
                                DataColumn(label: Text('Judul Buku')),
                                DataColumn(label: Text('Pengarang')),
                                DataColumn(label: Text('Rak')),
                              ],
                              rows: _buildDataTableRows(peminjamData),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }
                return Expanded(child: const Center(child: CircularProgressIndicator()));
              }),
        )
      ]),
    );
  }
}
