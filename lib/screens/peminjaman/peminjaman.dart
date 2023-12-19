import 'package:flutter/material.dart';
import 'package:admin_perpustakaan/model/ModelQuery.dart';
import 'package:admin_perpustakaan/screens/peminjaman/section/detail_peminjaman.dart';
import 'package:admin_perpustakaan/services/FirebaseServices.dart';
import 'package:admin_perpustakaan/widget/header/header_widget.dart';

class Peminjaman extends StatefulWidget {
  const Peminjaman({Key? key}) : super(key: key);

  @override
  State<Peminjaman> createState() => _PeminjamanState();
}

class _PeminjamanState extends State<Peminjaman> {
  final fs = FirebaseServices();

  var isClick = false;
  var nama = "";
  var email = "";

  List<Map<String, dynamic>> listData = [];

  @override
  // ignore: must_call_super
  initState() {
    // ignore: avoid_print
    getData();
  }

  void onClickTap(bool clicked) {
    setState(() {
      isClick = clicked;
    });
  }

  Future<void> getData() async {
    final getUsers = await fs.getAll("users");
    final docUsers = getUsers.docs;

    List<Map<String, dynamic>> lData = [];

    for (var users in docUsers) {
      final dataUsers = users.data();
      final usersEmail = dataUsers["email"];

      final peminjaman = await fs.queryFuture(
          "peminjaman", [ModelQuery(key: "email", value: usersEmail)]);
      final sumPeminjaman = peminjaman.size;

      Map<String, dynamic> peminjamanMap = {
        'jumlah_peminjaman': sumPeminjaman,
      };

      dataUsers.addAll(peminjamanMap);

      lData.add(dataUsers);
    }

    lData.sort(
        (a, b) => b['jumlah_peminjaman'].compareTo(a['jumlah_peminjaman']));

    setState(() {
      listData = lData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(children: [
        HeaderWidget(
          title: !isClick ? "Peminjaman" : nama,
          onBackPressed: isClick
              ? () {
                  setState(() {
                    onClickTap(false);
                  });
                }
              : null,
        ),
        Expanded(
            child: !isClick
                ? listData.length > 0
                    ? ListView.builder(
                        itemCount: listData.length,
                        itemBuilder: (context, index) {
                          final data = listData[index];

                          return Card(
                            child: ListTile(
                              onTap: () {
                                onClickTap(true);
                                setState(() {
                                  nama = data["nama"];
                                  email = data["email"];
                                });
                              },
                              title: Text(data["nama"]),
                              subtitle: Text(
                                  "Jumlah peminjaman : ${data["jumlah_peminjaman"]}"),
                              trailing: IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.arrow_right)),
                            ),
                          );
                        },
                      )
                    : Center(child: CircularProgressIndicator())
                : DetailPeminjaman(id: email))
      ]),
    );
  }
}
