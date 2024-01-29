import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Kategori extends StatefulWidget {
  const Kategori({Key? key}) : super(key: key);

  @override
  State<Kategori> createState() => _KategoriState();
}

class _KategoriState extends State<Kategori> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  // ignore: non_constant_identifier_names
  final User = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          title: const Center(
            child: Text(
              'Kategori',
              style: TextStyle(color: Colors.white),
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {},
            ),
          ],
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xff0096ff), Color(0xff6610f2)],
                  begin: FractionalOffset.bottomLeft,
                  end: FractionalOffset.bottomRight),
            ),
          ),
        ),
        body: Container(
            decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Colors.blue, width: 1))),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Bahasa Inggris",
                    style: TextStyle(fontSize: 16, color: Colors.blue),
                  ),
                  Row(
                    children: [
                      Text(
                        "Lihat Semua",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ],
              ),
              StreamBuilder<QuerySnapshot>(
                stream:
                    firestore.collection("books").where("kategori").snapshots(),
                builder: ((context, snapshot) {
                  return snapshot.hasData
                      ? SafeArea(
                          child: ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: ((context, index) {
                            DocumentSnapshot data = snapshot.data!.docs[index];
                            return CardBook(data, context);
                          }),
                        ))
                      : const Center(
                          child: CircularProgressIndicator(),
                        );
                }),
              )
            ])));
  }
}

// ignore: non_constant_identifier_names
Card CardBook(DocumentSnapshot data, BuildContext context) {
  return Card(
    margin: const EdgeInsets.only(right: 5, left: 5, top: 5),
    child: InkWell(
        onTap: () {},
        splashColor: Colors.blueAccent,
        child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent, width: 3)),
            child: Center(
                child: Column(children: [
              SizedBox(
                  height: 200,
                  child: Column(
                    children: <Widget>[
                      Image.network(
                        data["image"],
                        height: 150,
                        width: 150,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 150,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data["judul_buku"],
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.blue,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                data["pengarang"],
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.blue,
                                ),
                              ),
                            ]),
                      ),
                    ],
                  ))
            ])))),
  );
}
