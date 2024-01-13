import 'dart:io';

import 'package:admin_perpustakaan/utils/log_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_snackbar/fast_snackbar.dart';
import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:admin_perpustakaan/services/FirebaseServices.dart';
import 'package:admin_perpustakaan/utils/flutter_pdf_split.dart';
import 'package:admin_perpustakaan/utils/position.dart';
import 'package:admin_perpustakaan/utils/string_utils.dart';

class DataBuku extends StatefulWidget {
  const DataBuku({Key? key}) : super(key: key);

  @override
  State<DataBuku> createState() => _DataBukuState();
}

class _DataBukuState extends State<DataBuku> {
  final fs = FirebaseServices();

  late TextEditingController searchController = TextEditingController(text: "");

  String txtSearch = "";

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
  Uint8List image = Uint8List(8);
  File? tmpImage;
  bool isPicked = false;
  String image1 = "";
  String pdfLink = "";
  Map<String, dynamic> _pdfFile = {"fileBytes": null, "fileName": ""};

  void defaultState() {
    setState(() {
      judul = "";
      pengarang = "";
      penerbit = "";
      rak = "";
      halaman = "";
      sinopsis = "";
      kategori = "";
      barcode = "";
      image = Uint8List(8);
      tmpImage = null;
      isPicked = false;
      _pdfFile = {"fileBytes": null, "fileName": ""};
    });
  }

  Future<void> _pickImage(Function setImage) async {
    try {
      XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imgTmp = await image.readAsBytes();
      setImage(File(image.path), imgTmp);
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

  Future<void> splitPDF(path) async {
    String? directory = await FilePickerWeb.platform.getDirectoryPath();
    if (directory != null) {
      FlutterPdfSplitResult splitResult = await FlutterPdfSplit.split(
        FlutterPdfSplitArgs(path, directory, outFilePrefix: "Test"),
      );
      debugPrint(splitResult.toString());
    } else {
      context.showFastSnackbar("directory null",
          color: TypeFastSnackbar.success);
    }
  }

  Future addBooks(BuildContext context, Function setLoad) async {
    setLoad(true);
    try {
      var snapshot = await FirebaseStorage.instance
          .ref()
          .child("images")
          .child('${DateTime.now()}-${judul}-${barcode}.jpg')
          .putData(image);
      var downloadUrl = await snapshot.ref.getDownloadURL();

      var snapshotBuku = await FirebaseStorage.instance
          .ref()
          .child("buku")
          .child(_pdfFile["fileName"])
          .putData(_pdfFile["fileBytes"]);
      var downloadUrlBuku = await snapshotBuku.ref.getDownloadURL();

      final doc = FirebaseFirestore.instance.collection("books");
      final json = {
        "barcode": barcode,
        "isFavorit": "0",
        "isRecomended": "0",
        "halaman": halaman,
        "image": downloadUrl,
        "buku": downloadUrlBuku,
        "judul_buku": judul,
        "key_buku": normalizeTitle(judul),
        "kategori": kategori,
        "penerbit": penerbit,
        "pengarang": pengarang,
        "rak": rak,
        "sinopsis": sinopsis,
        "tanggal": selectedDate,
      };

      await doc.add(json);

      Navigator.of(this.context).pop('dialog');
      setLoad(false);
      defaultState();
    } on FirebaseException catch (e) {
      Navigator.of(this.context).pop('dialog');
      setLoad(false);
    }
  }

  Future editBook(BuildContext context, Function setLoad, String? id) async {
    setLoad(true);
    try {
      var downloadUrl = "";
      var downloadUrlBuku = _pdfFile["fileName"];
      if (isPicked) {
        var snapshot = await FirebaseStorage.instance
            .ref()
            .child("images")
            .child('${DateTime.now()}-${judul}-${barcode}.jpg')
            .putData(image);
        downloadUrl = await snapshot.ref.getDownloadURL();
      }

      if (_pdfFile["fileBytes"] != null) {
        var snapshotBuku = await FirebaseStorage.instance
            .ref()
            .child("buku")
            .child(_pdfFile["fileName"])
            .putData(_pdfFile["fileBytes"]);
        downloadUrlBuku = await snapshotBuku.ref.getDownloadURL();
      }

      log("key_buku", v: normalizeTitle(judul));

      final doc = FirebaseFirestore.instance.collection("books").doc(id);
      final json = {
        "barcode": barcode,
        "halaman": halaman,
        "judul_buku": judul,
        "key_buku": normalizeTitle(judul),
        "kategori": kategori,
        "penerbit": penerbit,
        "pengarang": pengarang,
        "rak": rak,
        "buku": downloadUrlBuku,
        "sinopsis": sinopsis,
        "tanggal": selectedDate,
        "image": isPicked ? downloadUrl : image1
      };

      await doc.update(json);

      Navigator.of(this.context).pop('dialog');
      setLoad(false);
      defaultState();
    } on FirebaseException catch (e) {
      Navigator.of(this.context).pop('dialog');
      setLoad(false);
    }
  }

  Future setFavorit(String? value, String? id) async {
    try {
      final doc = FirebaseFirestore.instance.collection("books").doc(id);
      final json = {
        "isFavorit": value == "1" ? "0" : "1",
      };

      await doc.update(json);
    } on FirebaseException catch (e) {}
  }

  Future setRecommend(String? value, String? id) async {
    try {
      final docUser = FirebaseFirestore.instance.collection("books").doc(id);
      final json = {
        "isRecomended": value == "1" ? "0" : "1",
      };

      await docUser.update(json);
    } on FirebaseException catch (e) {}
  }

  Future deleteBook(String? id, BuildContext context, Function setLoad) async {
    setLoad(true);
    try {
      final doc = FirebaseFirestore.instance.collection("books").doc(id);

      await doc.delete();

      Navigator.of(this.context).pop('dialog');
      setLoad(false);
    } on FirebaseException catch (e) {
      Navigator.of(this.context).pop('dialog');
      setLoad(false);
    }
  }

  void _pickPDF(Function setFile) async {
    FilePickerResult? result = await FilePickerWeb.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      final res = result.files.first;
      Uint8List? fileBytes = res.bytes;
      String fileName = res.name;

      setFile({"fileBytes": fileBytes, "fileName": fileName});
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: txtSearch != ""
            ? fs.searching("books", "key_buku", txtSearch)
            : fs.getAllStream("books"),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Header(),
                  TambahBuku(),
                  Searching(),
                  Expanded(
                    child: InteractiveViewer(
                      constrained: false,
                      child: DataTable(
                          headingRowColor: MaterialStateProperty.resolveWith(
                              (states) => Colors.blue.shade200),
                          columns: [
                            DataColumn(label: Text("No.")),
                            DataColumn(label: Text("Judul Buku")),
                            DataColumn(label: Text("Pengarang")),
                            DataColumn(label: Text("Penerbit")),
                            DataColumn(label: Text("Kategori")),
                            DataColumn(label: Text("Rak Buku")),
                            // DataColumn(label: Text("Sinopsis")),
                            DataColumn(label: Text("Halaman")),
                            DataColumn(label: Text("Gambar")),
                            DataColumn(label: Text("Aksi")),
                          ],
                          rows: List<DataRow>.generate(
                              snapshot.data!.docs.length, (index) {
                            DocumentSnapshot data = snapshot.data!.docs[index];
                            final number = index + 1;

                            return DataRow(cells: [
                              DataCell(Text(number.toString())),
                              DataCell(Text(data['judul_buku'])),
                              DataCell(Text(data['pengarang'])),
                              DataCell(Text(data['penerbit'])),
                              DataCell(Text(data['kategori'])),
                              DataCell(Text(data['rak'])),
                              // DataCell(Container(
                              //   constraints: BoxConstraints(
                              //     maxWidth: 100,
                              //   ),
                              //   child: Text(
                              //     data['sinopsis'],
                              //   ),
                              // )),
                              DataCell(Text(data['halaman'])),
                              DataCell(Container(
                                width: 50,
                                height: 50,
                                child: Image.network(data["image"]),
                              )),
                              DataCell(Container(
                                  child: Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        setState(() {
                                          judul = data['judul_buku'];
                                          pengarang = data['pengarang'];
                                          penerbit = data['penerbit'];
                                          rak = data['rak'];
                                          halaman = data['halaman'];
                                          sinopsis = data['sinopsis'];
                                          kategori = data['kategori'];
                                          barcode = data['barcode'];
                                          isPicked = false;
                                          image = Uint8List(8);
                                          tmpImage = null;
                                          image1 = data['image'];
                                          _pdfFile = {
                                            "fileBytes": null,
                                            "fileName": data['buku']
                                          };
                                        });
                                      });
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return StatefulBuilder(builder:
                                                (BuildContext context,
                                                    void Function(
                                                            void Function())
                                                        setState) {
                                              return Dialog(
                                                  insetPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 150),
                                                  child: Stack(
                                                    children: [
                                                      Container(
                                                          width:
                                                              double.infinity,
                                                          height: 630,
                                                          padding:
                                                              EdgeInsets.all(
                                                                  20),
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Icon(
                                                                      Icons
                                                                          .close,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                    Text(
                                                                      "Edit Buku",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              20,
                                                                          fontWeight:
                                                                              FontWeight.w700),
                                                                    ),
                                                                    InkWell(
                                                                        child: Icon(Icons
                                                                            .close),
                                                                        onTap:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop('dialog');
                                                                        }),
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            30),
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
                                                                            judul,
                                                                            (String
                                                                                value) {
                                                                          setState(
                                                                              () {
                                                                            judul =
                                                                                value;
                                                                          });
                                                                        }),
                                                                        TextInput(
                                                                            "Pengarang",
                                                                            false,
                                                                            pengarang,
                                                                            (String
                                                                                value) {
                                                                          setState(
                                                                              () {
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
                                                                          setState(
                                                                              () {
                                                                            penerbit =
                                                                                value;
                                                                          });
                                                                        }),
                                                                        TextInput(
                                                                            "Barcode",
                                                                            false,
                                                                            barcode,
                                                                            (String
                                                                                value) {
                                                                          setState(
                                                                              () {
                                                                            barcode =
                                                                                value;
                                                                          });
                                                                        }),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          20,
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        TextInput(
                                                                            "Kategori",
                                                                            false,
                                                                            kategori,
                                                                            (String
                                                                                value) {
                                                                          setState(
                                                                              () {
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
                                                                          setState(
                                                                              () {
                                                                            halaman =
                                                                                value;
                                                                          });
                                                                        }),
                                                                        TextInput(
                                                                            "Rak",
                                                                            false,
                                                                            rak,
                                                                            (String
                                                                                value) {
                                                                          setState(
                                                                              () {
                                                                            rak =
                                                                                value;
                                                                          });
                                                                        }),
                                                                        TextInput(
                                                                            "Sinopsis",
                                                                            true,
                                                                            sinopsis,
                                                                            (String
                                                                                value) {
                                                                          setState(
                                                                              () {
                                                                            sinopsis =
                                                                                value;
                                                                          });
                                                                        }),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          20,
                                                                    ),
                                                                    Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        ImagePick(
                                                                            "Gambar",
                                                                            () {
                                                                          _pickImage((final img,
                                                                              final img1) {
                                                                            setState(() {
                                                                              image = img1;
                                                                              tmpImage = img;
                                                                              isPicked = true;
                                                                            });
                                                                          });
                                                                        },
                                                                            image,
                                                                            tmpImage,
                                                                            'edit',
                                                                            isPicked,
                                                                            image1),
                                                                        PdfPick(
                                                                            "Edit Buku",
                                                                            () {
                                                                          _pickPDF(
                                                                              (final file) {
                                                                            setState(() {
                                                                              _pdfFile = file;
                                                                            });
                                                                          });
                                                                        }, "edit",
                                                                            _pdfFile)
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          20,
                                                                    ),
                                                                    Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [],
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          20,
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
                                                                      style: ElevatedButton
                                                                          .styleFrom(
                                                                        primary:
                                                                            Colors.green,
                                                                        padding: EdgeInsets.symmetric(
                                                                            vertical:
                                                                                20,
                                                                            horizontal:
                                                                                50),
                                                                        textStyle:
                                                                            const TextStyle(fontSize: 16),
                                                                      ),
                                                                      onPressed: !_loading
                                                                          ? () {
                                                                              editBook(context, (bool val) {
                                                                                setState(() {
                                                                                  _loading = val;
                                                                                });
                                                                              }, data.id);
                                                                            }
                                                                          : null,
                                                                      child: _loading
                                                                          ? const CircularProgressIndicator(
                                                                              strokeWidth: 2.0,
                                                                              color: Colors.white,
                                                                            )
                                                                          : const Text("Submit"),
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
                                    },
                                    child: Container(
                                      margin:
                                          EdgeInsets.only(top: 1, bottom: 1),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                        color: Colors.amber,
                                      ),
                                      width: 30,
                                      height: 30,
                                      child: Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  InkWell(
                                    onTap: (() {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return StatefulBuilder(builder:
                                                (BuildContext context,
                                                    void Function(
                                                            void Function())
                                                        setState) {
                                              return Dialog(
                                                  insetPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 300),
                                                  child: Stack(
                                                    children: [
                                                      Container(
                                                          width: 400,
                                                          height: 240,
                                                          padding:
                                                              EdgeInsets.all(
                                                                  20),
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                      "Hapus Buku",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              20,
                                                                          fontWeight:
                                                                              FontWeight.w700),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                  margin: EdgeInsets
                                                                      .symmetric(
                                                                          vertical:
                                                                              30),
                                                                  child: Text(
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    "Apakah anda yakin menghapus buku ${data["judul_buku"]}?",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight.w400),
                                                                  )),
                                                              Container(
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    ElevatedButton(
                                                                      style: ElevatedButton
                                                                          .styleFrom(
                                                                        primary:
                                                                            Colors.red,
                                                                        padding: EdgeInsets.symmetric(
                                                                            vertical:
                                                                                20,
                                                                            horizontal:
                                                                                30),
                                                                        textStyle:
                                                                            const TextStyle(fontSize: 16),
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop("dialog");
                                                                      },
                                                                      child: const Text(
                                                                          "Close"),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    ElevatedButton(
                                                                      style: ElevatedButton
                                                                          .styleFrom(
                                                                        primary:
                                                                            Colors.green,
                                                                        padding: EdgeInsets.symmetric(
                                                                            vertical:
                                                                                20,
                                                                            horizontal:
                                                                                30),
                                                                        textStyle:
                                                                            const TextStyle(fontSize: 16),
                                                                      ),
                                                                      onPressed: !_loading
                                                                          ? () {
                                                                              deleteBook(data.id, context, (bool val) {
                                                                                setState(() {
                                                                                  _loading = val;
                                                                                });
                                                                              });
                                                                            }
                                                                          : null,
                                                                      child: _loading
                                                                          ? const CircularProgressIndicator(
                                                                              strokeWidth: 2.0,
                                                                              color: Colors.white,
                                                                            )
                                                                          : const Text("Ya"),
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
                                    child: Container(
                                      margin:
                                          EdgeInsets.only(top: 1, bottom: 1),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                        color: Colors.red,
                                      ),
                                      width: 30,
                                      height: 30,
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  // InkWell(
                                  //   onTap: (() {
                                  //     setFavorit(data['isRecomended'], data.id);
                                  //   }),
                                  //   child: Container(
                                  //     margin:
                                  //         EdgeInsets.only(top: 1, bottom: 1),
                                  //     decoration: BoxDecoration(
                                  //       borderRadius: BorderRadius.all(
                                  //           Radius.circular(10.0)),
                                  //       color: Colors.green,
                                  //     ),
                                  //     width: 50,
                                  //     height: 50,
                                  //     child: Icon(
                                  //       Icons.favorite,
                                  //       color: data['isFavorit'] == "1"
                                  //           ? Colors.pink
                                  //           : Colors.grey[600],
                                  //     ),
                                  //   ),
                                  // ),
                                  // SizedBox(
                                  //   width: 8,
                                  // ),
                                  // InkWell(
                                  //   onTap: (() {
                                  //     setRecommend(
                                  //         data['isRecomended'], data.id);
                                  //   }),
                                  //   child: Container(
                                  //     margin:
                                  //         EdgeInsets.only(top: 1, bottom: 1),
                                  //     decoration: BoxDecoration(
                                  //       borderRadius: BorderRadius.all(
                                  //           Radius.circular(10.0)),
                                  //       color: Colors.blue,
                                  //     ),
                                  //     width: 50,
                                  //     height: 50,
                                  //     child: Icon(
                                  //       Icons.recommend,
                                  //       color: data['isRecomended'] == "1"
                                  //           ? Colors.lightGreenAccent
                                  //           : Colors.grey[600],
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ))),
                            ]);
                          })),
                    ),
                  ),
                ],
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
      width: 230,
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
              // labelText: label,
            ),
          ),
        ],
      ),
    );
  }

  Container ImagePick(String? label, VoidCallback? onPick, Uint8List? img,
      File? tmpImg, String? type, bool isPick, String? img1) {
    return Container(
      margin: EdgeInsets.only(right: 20),
      width: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(label!),
          V(8),
          type == 'edit'
              ? isPicked
                  ? InkWell(
                      onTap: onPick,
                      child: Container(
                        child: Image.memory(
                          img!,
                          width: 120,
                          height: 120,
                          fit: BoxFit.fill,
                        ),
                      ),
                    )
                  : InkWell(
                      onTap: onPick,
                      child: Container(
                        child: Image.network(
                          img1!,
                          width: 120,
                          height: 120,
                          fit: BoxFit.fill,
                        ),
                      ),
                    )
              : tmpImage != null
                  ? InkWell(
                      onTap: onPick,
                      child: Container(
                        child: Image.memory(
                          img!,
                          width: 120,
                          height: 120,
                          fit: BoxFit.fill,
                        ),
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

  Widget Header() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Data Buku",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget TambahBuku() {
    return Container(
        width: double.infinity,
        margin: EdgeInsets.only(top: 10, bottom: 10),
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Wrap(alignment: WrapAlignment.spaceBetween, children: [
          Container(
            height: 40,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5)),
            child: ElevatedButton(
                child: Text('Tambah Buku'),
                style: ElevatedButton.styleFrom(
                    primary: Colors.blueAccent,
                    textStyle: const TextStyle(fontSize: 16)),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return StatefulBuilder(builder: (BuildContext context,
                            void Function(void Function()) setState) {
                          return Dialog(
                              insetPadding:
                                  EdgeInsets.symmetric(horizontal: 150),
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
                                                  "Tambah Buku",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                InkWell(
                                                    child: Icon(Icons.close),
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .pop('dialog');
                                                    }),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 30),
                                            child: Column(
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    TextInput(
                                                        "Judul Buku",
                                                        false,
                                                        judul, (String value) {
                                                      setState(() {
                                                        judul = value;
                                                      });
                                                    }),
                                                    TextInput("Pengarang",
                                                        false, pengarang,
                                                        (String value) {
                                                      setState(() {
                                                        pengarang = value;
                                                      });
                                                    }),
                                                    TextInput("Penerbit", false,
                                                        penerbit,
                                                        (String value) {
                                                      setState(() {
                                                        penerbit = value;
                                                      });
                                                    }),
                                                    TextInput("Barcode", false,
                                                        barcode,
                                                        (String value) {
                                                      setState(() {
                                                        barcode = value;
                                                      });
                                                    }),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Row(
                                                  children: [
                                                    TextInput("Kategori", false,
                                                        kategori,
                                                        (String value) {
                                                      setState(() {
                                                        kategori = value;
                                                      });
                                                    }),
                                                    TextInput("Halaman", false,
                                                        halaman,
                                                        (String value) {
                                                      setState(() {
                                                        halaman = value;
                                                      });
                                                    }),
                                                    TextInput("Rak", false, rak,
                                                        (String value) {
                                                      setState(() {
                                                        rak = value;
                                                      });
                                                    }),
                                                    TextInput("Sinopsis", true,
                                                        sinopsis,
                                                        (String value) {
                                                      setState(() {
                                                        sinopsis = value;
                                                      });
                                                    }),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    ImagePick("Gambar", () {
                                                      _pickImage((final img,
                                                          final img1) {
                                                        setState(() {
                                                          image = img1;
                                                          tmpImage = img;
                                                          isPicked = true;
                                                        });
                                                      });
                                                    }, image, tmpImage, 'add',
                                                        isPicked, image1),
                                                    PdfPick("Tambah Buku", () {
                                                      _pickPDF((final file) {
                                                        setState(() {
                                                          _pdfFile = file;
                                                        });
                                                      });
                                                    }, "tambah", _pdfFile)
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
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
                                                  MainAxisAlignment.center,
                                              children: [
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    primary: Colors.green,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 20,
                                                            horizontal: 50),
                                                    textStyle: const TextStyle(
                                                        fontSize: 16),
                                                  ),
                                                  onPressed: !_loading
                                                      ? () {
                                                          addBooks(context,
                                                              (bool val) {
                                                            setState(() {
                                                              _loading = val;
                                                            });
                                                          });
                                                        }
                                                      : null,
                                                  child: _loading
                                                      ? const CircularProgressIndicator(
                                                          strokeWidth: 2.0,
                                                          color: Colors.white,
                                                        )
                                                      : const Text("Submit"),
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
        ]));
  }

  Widget Searching() {
    return Container(
      height: 40,
      width: 250,
      margin: EdgeInsets.only(top: 10, bottom: 10),
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(5)),
      child: Center(
          child: TextField(
        controller: searchController,
        decoration: InputDecoration(
            hintText: "Masukkan nama buku",
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
              onPressed: () {
                setState(() {
                  txtSearch = searchController.text;
                });
              },
            )),
      )),
    );
  }

  Container PdfPick(String? label, VoidCallback? onPick, String? type,
      Map<String, dynamic> pdfFile) {
    return Container(
      margin: EdgeInsets.only(right: 20),
      width: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(label!),
          V(8),
          InkWell(
            onTap: onPick,
            child: Container(
              height: 100,
              width: 100,
              color: Colors.grey,
              padding: EdgeInsets.all(8),
              child: pdfFile["fileName"] == ""
                  ? Icon(Icons.assignment_add)
                  : Center(child: Text(pdfFile["fileName"])),
            ),
          )
        ],
      ),
    );
  }
}
