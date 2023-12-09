import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:web_dashboard_app_tut/utils/flutter_pdf_split.dart';
import 'package:web_dashboard_app_tut/utils/position.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:web_dashboard_app_tut/utils/snackbar_utils.dart';

class DataBuku extends StatefulWidget {
  const DataBuku({Key? key}) : super(key: key);

  @override
  State<DataBuku> createState() => _DataBukuState();
}

class _DataBukuState extends State<DataBuku> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String search = "";
  late TextEditingController searchController = TextEditingController(text: search);

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
  Map<String, dynamic> _pdfFile = {"fileBytes": null, "fileName": ""};

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
      showSnackbar("directory null", Colors.red);
    }
  }

  Future addBooks(BuildContext context, Function setLoad) async {
    setLoad(true);
    try {
      // var snapshot = await FirebaseStorage.instance
      //     .ref()
      //     .child("images")
      //     .child('${DateTime.now()}-${judul}-${barcode}.jpg')
      //     .putData(image);
      // var downloadUrl = await snapshot.ref.getDownloadURL();

      // var snapshotBuku = await FirebaseStorage.instance
      //     .ref()
      //     .child("buku")
      //     .child(_pdfFile["fileName"])
      //     .putData(_pdfFile["fileBytes"]);
      // var downloadUrlBuku = await snapshotBuku.ref.getDownloadURL();

      // final doc = FirebaseFirestore.instance.collection("books");
      // final json = {
      //   "barcode": barcode,
      //   "isFavorit": "0",
      //   "isRecomended": "0",
      //   "halaman": halaman,
      //   "image": downloadUrl,
      //   "buku": downloadUrlBuku,
      //   "judul_buku": judul,
      //   "kategori": kategori,
      //   "penerbit": penerbit,
      //   "pengarang": pengarang,
      //   "rak": rak,
      //   "sinopsis": sinopsis,
      //   "tanggal": selectedDate,
      // };

      // await doc.add(json);

      // Navigator.of(this.context).pop('dialog');
      // setLoad(false);
      // setState(() {
      //   judul = "";
      //   pengarang = "";
      //   penerbit = "";
      //   rak = "";
      //   halaman = "";
      //   sinopsis = "";
      //   kategori = "";
      //   barcode = "";
      //   image = Uint8List(8);
      //   tmpImage = null;
      //   isPicked = false;
      // });
    } on FirebaseException catch (e) {
      Navigator.of(this.context).pop('dialog');
      setLoad(false);
    }
  }

  Future editBook(BuildContext context, Function setLoad, String? id) async {
    setLoad(true);
    try {
      var downloadUrl = "";
      if (isPicked) {
        var snapshot = await FirebaseStorage.instance
            .ref()
            .child("images")
            .child('${DateTime.now()}-${judul}-${barcode}.jpg')
            .putData(image);
        downloadUrl = await snapshot.ref.getDownloadURL();
      }

      final doc = FirebaseFirestore.instance.collection("books").doc(id);
      final json = {
        "barcode": barcode,
        "halaman": halaman,
        "judul_buku": judul,
        "kategori": kategori,
        "penerbit": penerbit,
        "pengarang": pengarang,
        "rak": rak,
        "sinopsis": sinopsis,
        "tanggal": selectedDate,
        "image": isPicked ? downloadUrl : image1
      };

      await doc.update(json);

      Navigator.of(this.context).pop('dialog');
      setLoad(false);
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
      });
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
      Uint8List? fileBytes = result.files.first.bytes;
      String fileName = result.files.first.name;
      String? pdfPath = result.files.first.path;

      setFile({"fileBytes": fileBytes, "fileName": fileName});
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: search != ""
            ? firestore.collection("books").where("judul_buku", isEqualTo: search).snapshots()
            : firestore.collection("books").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 10),
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
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 10, bottom: 10),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        children: [
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
                                              insetPadding: EdgeInsets.symmetric(horizontal: 150),
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
                                                                  MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Icon(
                                                                  Icons.close,
                                                                  color: Colors.white,
                                                                ),
                                                                Text(
                                                                  "Tambah Buku",
                                                                  style: TextStyle(
                                                                      fontSize: 20,
                                                                      fontWeight: FontWeight.w700),
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
                                                            margin:
                                                                EdgeInsets.symmetric(vertical: 30),
                                                            child: Column(
                                                              children: [
                                                                Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment.start,
                                                                  children: [
                                                                    TextInput(
                                                                        "Judul Buku", false, judul,
                                                                        (String value) {
                                                                      setState(() {
                                                                        judul = value;
                                                                      });
                                                                    }),
                                                                    TextInput("Pengarang", false,
                                                                        pengarang, (String value) {
                                                                      setState(() {
                                                                        pengarang = value;
                                                                      });
                                                                    }),
                                                                    TextInput(
                                                                        "Penerbit", false, penerbit,
                                                                        (String value) {
                                                                      setState(() {
                                                                        penerbit = value;
                                                                      });
                                                                    }),
                                                                    TextInput(
                                                                        "Barcode", false, barcode,
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
                                                                    TextInput(
                                                                        "Kategori", false, kategori,
                                                                        (String value) {
                                                                      setState(() {
                                                                        kategori = value;
                                                                      });
                                                                    }),
                                                                    TextInput(
                                                                        "Halaman", false, halaman,
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
                                                                    TextInput(
                                                                        "Sinopsis", true, sinopsis,
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
                                                                      _pickImage(
                                                                          (final img, final img1) {
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
                                                                  style: ElevatedButton.styleFrom(
                                                                    primary: Colors.green,
                                                                    padding: EdgeInsets.symmetric(
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
                          Container(
                            height: 40,
                            width: 250,
                            decoration: BoxDecoration(
                                color: Colors.white, borderRadius: BorderRadius.circular(5)),
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
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 10, bottom: 40, top: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
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
                                  DataColumn(label: Text("Sinopsis")),
                                  DataColumn(label: Text("Halaman")),
                                  DataColumn(label: Text("Gambar")),
                                  DataColumn(label: Text("Aksi")),
                                ],
                                rows: List<DataRow>.generate(snapshot.data!.docs.length, (index) {
                                  DocumentSnapshot data = snapshot.data!.docs[index];
                                  final number = index + 1;

                                  return DataRow(cells: [
                                    DataCell(Text(number.toString())),
                                    DataCell(Text(data['judul_buku'])),
                                    DataCell(Text(data['pengarang'])),
                                    DataCell(Text(data['penerbit'])),
                                    DataCell(Text(data['kategori'])),
                                    DataCell(Text(data['rak'])),
                                    DataCell(Container(
                                      constraints: BoxConstraints(
                                        maxWidth: 50,
                                      ),
                                      child: Text(
                                        data['sinopsis'],
                                      ),
                                    )),
                                    DataCell(Text(data['halaman'])),
                                    DataCell(Container(
                                      child: Image.network(
                                        data["image"],
                                        width: 100,
                                        height: 100,
                                      ),
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
                                              });
                                            });
                                            showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return StatefulBuilder(builder:
                                                      (BuildContext context,
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
                                                                            "Edit Buku",
                                                                            style: TextStyle(
                                                                                fontSize: 20,
                                                                                fontWeight:
                                                                                    FontWeight
                                                                                        .w700),
                                                                          ),
                                                                          InkWell(
                                                                              child:
                                                                                  Icon(Icons.close),
                                                                              onTap: () {
                                                                                Navigator.of(
                                                                                        context)
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
                                                                                CrossAxisAlignment
                                                                                    .start,
                                                                            children: [
                                                                              TextInput(
                                                                                  "Judul Buku",
                                                                                  false,
                                                                                  judul,
                                                                                  (String value) {
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
                                                                              TextInput("Penerbit",
                                                                                  false, penerbit,
                                                                                  (String value) {
                                                                                setState(() {
                                                                                  penerbit = value;
                                                                                });
                                                                              }),
                                                                            ],
                                                                          ),
                                                                          SizedBox(
                                                                            height: 20,
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              TextInput("Barcode",
                                                                                  false, barcode,
                                                                                  (String value) {
                                                                                setState(() {
                                                                                  barcode = value;
                                                                                });
                                                                              }),
                                                                              TextInput("Kategori",
                                                                                  false, kategori,
                                                                                  (String value) {
                                                                                setState(() {
                                                                                  kategori = value;
                                                                                });
                                                                              }),
                                                                              TextInput("Halaman",
                                                                                  false, halaman,
                                                                                  (String value) {
                                                                                setState(() {
                                                                                  halaman = value;
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
                                                                                  "Rak", false, rak,
                                                                                  (String value) {
                                                                                setState(() {
                                                                                  rak = value;
                                                                                });
                                                                              }),
                                                                              TextInput("Sinopsis",
                                                                                  true, sinopsis,
                                                                                  (String value) {
                                                                                setState(() {
                                                                                  sinopsis = value;
                                                                                });
                                                                              }),
                                                                              ImagePick("Gambar",
                                                                                  () {
                                                                                _pickImage(
                                                                                    (final img,
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
                                                                                  "edit",
                                                                                  isPicked,
                                                                                  image1),
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
                                                                            style: ElevatedButton
                                                                                .styleFrom(
                                                                              primary: Colors.green,
                                                                              padding: EdgeInsets
                                                                                  .symmetric(
                                                                                      vertical: 20,
                                                                                      horizontal:
                                                                                          50),
                                                                              textStyle:
                                                                                  const TextStyle(
                                                                                      fontSize: 16),
                                                                            ),
                                                                            onPressed: !_loading
                                                                                ? () {
                                                                                    editBook(
                                                                                        context,
                                                                                        (bool val) {
                                                                                      setState(() {
                                                                                        _loading =
                                                                                            val;
                                                                                      });
                                                                                    }, data.id);
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
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(top: 1, bottom: 1),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                              color: Colors.amber,
                                            ),
                                            width: 50,
                                            height: 50,
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
                                                          void Function(void Function()) setState) {
                                                    return Dialog(
                                                        insetPadding:
                                                            EdgeInsets.symmetric(horizontal: 300),
                                                        child: Stack(
                                                          children: [
                                                            Container(
                                                                width: 400,
                                                                height: 240,
                                                                padding: EdgeInsets.all(20),
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
                                                                                fontSize: 20,
                                                                                fontWeight:
                                                                                    FontWeight
                                                                                        .w700),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                        margin:
                                                                            EdgeInsets.symmetric(
                                                                                vertical: 30),
                                                                        child: Text(
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          "Apakah anda yakin menghapus buku ${data["judul_buku"]}?",
                                                                          style: TextStyle(
                                                                              fontSize: 16,
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
                                                                              primary: Colors.red,
                                                                              padding: EdgeInsets
                                                                                  .symmetric(
                                                                                      vertical: 20,
                                                                                      horizontal:
                                                                                          30),
                                                                              textStyle:
                                                                                  const TextStyle(
                                                                                      fontSize: 16),
                                                                            ),
                                                                            onPressed: () {
                                                                              Navigator.of(context)
                                                                                  .pop("dialog");
                                                                            },
                                                                            child:
                                                                                const Text("Close"),
                                                                          ),
                                                                          SizedBox(
                                                                            width: 10,
                                                                          ),
                                                                          ElevatedButton(
                                                                            style: ElevatedButton
                                                                                .styleFrom(
                                                                              primary: Colors.green,
                                                                              padding: EdgeInsets
                                                                                  .symmetric(
                                                                                      vertical: 20,
                                                                                      horizontal:
                                                                                          30),
                                                                              textStyle:
                                                                                  const TextStyle(
                                                                                      fontSize: 16),
                                                                            ),
                                                                            onPressed: !_loading
                                                                                ? () {
                                                                                    deleteBook(
                                                                                        data.id,
                                                                                        context,
                                                                                        (bool val) {
                                                                                      setState(() {
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
                                            margin: EdgeInsets.only(top: 1, bottom: 1),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                              color: Colors.red,
                                            ),
                                            width: 50,
                                            height: 50,
                                            child: Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        InkWell(
                                          onTap: (() {
                                            setFavorit(data['isRecomended'], data.id);
                                          }),
                                          child: Container(
                                            margin: EdgeInsets.only(top: 1, bottom: 1),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                              color: Colors.green,
                                            ),
                                            width: 50,
                                            height: 50,
                                            child: Icon(
                                              Icons.favorite,
                                              color: data['isFavorit'] == "1"
                                                  ? Colors.pink
                                                  : Colors.grey[600],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        InkWell(
                                          onTap: (() {
                                            setRecommend(data['isRecomended'], data.id);
                                          }),
                                          child: Container(
                                            margin: EdgeInsets.only(top: 1, bottom: 1),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                              color: Colors.blue,
                                            ),
                                            width: 50,
                                            height: 50,
                                            child: Icon(
                                              Icons.recommend,
                                              color: data['isRecomended'] == "1"
                                                  ? Colors.lightGreenAccent
                                                  : Colors.grey[600],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ))),
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

  Container TextInput(String? label, bool? multiline, String? value, Function? onChanged) {
    return Container(
      margin: EdgeInsets.only(right: 20),
      width: 250,
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
            keyboardType: multiline! ? TextInputType.multiline : TextInputType.none,
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

  Container ImagePick(String? label, VoidCallback? onPick, Uint8List? img, File? tmpImg,
      String? type, bool isPick, String? img1) {
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
}

Container PdfPick(String? label, VoidCallback? onPick, String? type, Map<String, dynamic> pdfFile) {
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
