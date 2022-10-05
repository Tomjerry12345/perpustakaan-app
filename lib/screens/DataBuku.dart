import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class databuku extends StatefulWidget {
  const databuku({Key? key}) : super(key: key);

  @override
  State<databuku> createState() => _databukuState();
}

class _databukuState extends State<databuku> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String search = "";
  late TextEditingController searchController =
      TextEditingController(text: search);

  bool _loading = false;
  String judul = "";
  String pengarang = "";
  String penerbit = "";
  String rak = "";
  String halaman = "";
  String sinopsis = "";
  String kategori = "";
  String barcode = "";
  DateTime selectedDate = DateTime.now();
  File? image;

  Future<void> _pickImage(Function setImage) async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imgTmp = File(image.path);
      setImage(imgTmp);
    } on PlatformException catch (e) {
      print("Failed pick image");
    }
  }

  Future<DateTime> _selectDate(
    BuildContext context,
  ) async {
    final selected = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(3000));

    if (selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
      });
    }
    return selectedDate;
  }

  Future editUser(BuildContext context, Function setLoad) async {
    setLoad(true);
    try {
      final docUser = FirebaseFirestore.instance.collection("books");
      // final json = {
      //   "email": email,
      //   "nama": nama,
      //   "no_rekening": noRekening,
      //   "alamat": alamat,
      //   "no_hp": noHp,
      //   "updated_at": DateTime.now(),
      // };

      // await docUser.update(json);

      Navigator.of(this.context).pop('dialog');
      setLoad(false);
    } on FirebaseException catch (e) {
      Navigator.of(this.context).pop('dialog');
      setLoad(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: search != ""
            ? firestore
                .collection("books")
                .where("judul_buku", isEqualTo: search)
                .snapshots()
            : firestore.collection("books").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 30, bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Data Buku",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: 900, right: 20, top: 10, bottom: 10),
                      width: double.infinity,
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                      child: Center(
                          child: TextField(
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.blueAccent,
                                width: 1.0,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.search),
                              onPressed: () {},
                            )),
                      )),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: 900, right: 20, top: 10, bottom: 10),
                      width: double.infinity,
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                      child: ElevatedButton(
                          child: Text('Tambah Buku'),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.blueAccent,
                              textStyle: const TextStyle(fontSize: 16)),
                          onPressed: () {
                            // setState(() {
                            //   nama = data["nama"];
                            //   email = data["email"];
                            //   noHp = data['no_hp'];
                            //   noRekening = data["no_rekening"];
                            //   alamat = data["alamat"];
                            // });
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return StatefulBuilder(builder: (BuildContext
                                          context,
                                      void Function(void Function()) setState) {
                                    return Dialog(
                                        insetPadding: EdgeInsets.symmetric(
                                            horizontal: 150),
                                        child: Stack(
                                          children: [
                                            Container(
                                                width: double.infinity,
                                                height: 600,
                                                padding: EdgeInsets.all(20),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Icon(
                                                            Icons.close,
                                                            color: Colors.white,
                                                          ),
                                                          Text(
                                                            "Edit User",
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                          ),
                                                          InkWell(
                                                              child: Icon(
                                                                  Icons.close),
                                                              onTap: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop(
                                                                        'dialog');
                                                              }),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              vertical: 30),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              TextInput(
                                                                  "Judul Buku",
                                                                  false,
                                                                  judul, (String
                                                                      value) {
                                                                setState(() {
                                                                  judul = value;
                                                                });
                                                              }),
                                                              TextInput(
                                                                  "Pengarang",
                                                                  false,
                                                                  pengarang,
                                                                  (String
                                                                      value) {
                                                                setState(() {
                                                                  pengarang =
                                                                      value;
                                                                });
                                                              }),
                                                              TextInput(
                                                                  "Penerbit",
                                                                  false,
                                                                  penerbit,
                                                                  (String
                                                                      value) {
                                                                setState(() {
                                                                  penerbit =
                                                                      value;
                                                                });
                                                              }),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                          Row(
                                                            children: [
                                                              TextInput(
                                                                  "Barcode",
                                                                  false,
                                                                  barcode,
                                                                  (String
                                                                      value) {
                                                                setState(() {
                                                                  barcode =
                                                                      value;
                                                                });
                                                              }),
                                                              TextInput(
                                                                  "Kategori",
                                                                  false,
                                                                  kategori,
                                                                  (String
                                                                      value) {
                                                                setState(() {
                                                                  kategori =
                                                                      value;
                                                                });
                                                              }),
                                                              TextInput(
                                                                  "Halaman",
                                                                  false,
                                                                  halaman,
                                                                  (String
                                                                      value) {
                                                                setState(() {
                                                                  halaman =
                                                                      value;
                                                                });
                                                              }),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              TextInput(
                                                                  "Rak",
                                                                  false,
                                                                  rak, (String
                                                                      value) {
                                                                setState(() {
                                                                  rak = value;
                                                                });
                                                              }),
                                                              TextInput(
                                                                  "Sinopsis",
                                                                  true,
                                                                  sinopsis,
                                                                  (String
                                                                      value) {
                                                                setState(() {
                                                                  sinopsis =
                                                                      value;
                                                                });
                                                              }),
                                                              ImagePick(
                                                                  "Gambar", () {
                                                                _pickImage(
                                                                    (final img) {
                                                                  setState(() {
                                                                    image = img;
                                                                  });
                                                                });
                                                              }, image),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [],
                                                          ),
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          ElevatedButton(
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              primary:
                                                                  Colors.green,
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          20,
                                                                      horizontal:
                                                                          50),
                                                              textStyle:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          16),
                                                            ),
                                                            onPressed: !_loading
                                                                ? () {
                                                                    editUser(
                                                                        context,
                                                                        (bool
                                                                            val) {
                                                                      setState(
                                                                          () {
                                                                        _loading =
                                                                            val;
                                                                      });
                                                                    });
                                                                  }
                                                                : null,
                                                            child: _loading
                                                                ? const CircularProgressIndicator(
                                                                    strokeWidth:
                                                                        2.0,
                                                                    color: Colors
                                                                        .white,
                                                                  )
                                                                : const Text(
                                                                    "Submit"),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                )),
                                          ],
                                        ));
                                  });
                                });
                          }),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 10, right: 10, bottom: 40, top: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                                headingRowColor:
                                    MaterialStateProperty.resolveWith(
                                        (states) => Colors.blue.shade200),
                                columns: [
                                  DataColumn(label: Text("No.")),
                                  DataColumn(label: Text("Judul Buku")),
                                  DataColumn(label: Text("Pengarang")),
                                  DataColumn(label: Text("Penerbit")),
                                  DataColumn(label: Text("Kategori")),
                                  DataColumn(label: Text("Rak Buku")),
                                  DataColumn(label: Text("Sinopsis")),
                                  DataColumn(label: Text("Halaman")),
                                  DataColumn(label: Text("Gambar")),
                                ],
                                rows: List<DataRow>.generate(
                                    snapshot.data!.docs.length, (index) {
                                  DocumentSnapshot data =
                                      snapshot.data!.docs[index];
                                  final number = index + 1;

                                  return DataRow(cells: [
                                    DataCell(Text(number.toString())),
                                    DataCell(Text(data['judul_buku'])),
                                    DataCell(Text(data['pengarang'])),
                                    DataCell(Text(data['penerbit'])),
                                    DataCell(Text(data['kategori'])),
                                    DataCell(Text(data['rak'])),
                                    DataCell(FittedBox(
                                      fit: BoxFit.fitHeight,
                                      child: Text(
                                        data['sinopsis'],
                                      ),
                                    )),
                                    DataCell(Text(data['halaman'])),
                                    DataCell(Text("102Comments")),
                                  ]);
                                })),
                          ),
                          //Now let's set the pagination
                          SizedBox(
                            height: 40.0,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Expanded(
              child: Center(child: CircularProgressIndicator()),
            );
          }
        });
  }

  Container TextInput(
      String? label, bool? multiline, String? value, Function? onChanged) {
    return Container(
      margin: EdgeInsets.only(right: 20),
      width: 300,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(label!),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          TextFormField(
            enabled: label == "Email" ? false : true,
            onChanged: ((value) {
              onChanged!(value);
            }),
            initialValue: value,
            keyboardType:
                multiline! ? TextInputType.multiline : TextInputType.none,
            maxLines: multiline ? 3 : 1,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: label,
            ),
          ),
        ],
      ),
    );
  }

  Container ImagePick(String? label, VoidCallback? onPick, File? img) {
    return Container(
      margin: EdgeInsets.only(right: 20),
      width: 300,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(label!),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          img != null
              ? Container(
                  child: Image.file(
                    img,
                    width: 200,
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                )
              : InkWell(
                  onTap: onPick,
                  child: Container(
                    height: 100,
                    width: 100,
                    child: Icon(Icons.add_a_photo),
                  ),
                )
        ],
      ),
    );
  }
}
