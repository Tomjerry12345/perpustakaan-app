import 'package:flutter/material.dart';
import 'package:admin_perpustakaan/model/ModelQuery.dart';
import 'package:admin_perpustakaan/services/FirebaseServices.dart';
import 'package:admin_perpustakaan/widget/header/header_widget.dart';

import 'section/detail_pengembalian.dart';

class Pengembalian extends StatefulWidget {
  const Pengembalian({Key? key}) : super(key: key);

  @override
  State<Pengembalian> createState() => _PengembalianState();
}

class _PengembalianState extends State<Pengembalian> {
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

      final pengembalian = await fs.queryFuture(
          "pengembalian", [ModelQuery(key: "email", value: usersEmail)]);
      final sumPengembalian = pengembalian.size;

      Map<String, dynamic> peminjamanMap = {
        'jumlah_pengembalian': sumPengembalian,
      };

      dataUsers.addAll(peminjamanMap);

      lData.add(dataUsers);
    }

    lData.sort(
        (a, b) => b['jumlah_pengembalian'].compareTo(a['jumlah_pengembalian']));

    setState(() {
      listData = lData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(children: [
        HeaderWidget(
          title: !isClick ? "Pengembalian" : nama,
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
                ? listData.isNotEmpty
                    ? ListView.builder(
                        itemCount: listData.length,
                        itemBuilder: (context, index) {
                          final data = listData[index];

                          return data["jumlah_pengembalian"] > 0
                              ? Card(
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
                                        "Jumlah pengembalian : ${data["jumlah_pengembalian"]}"),
                                    trailing: IconButton(
                                        onPressed: () {},
                                        icon: const Icon(Icons.arrow_right)),
                                  ),
                                )
                              : null;
                        },
                      )
                    : const Center(child: CircularProgressIndicator())
                : DetailPengembalian(id: email, onGetData: getData))
      ]),
    );
  }
}
