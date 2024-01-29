import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types
class terlaris extends StatefulWidget {
  const terlaris({Key? key}) : super(key: key);

  @override
  State<terlaris> createState() => _terlarisState();
}

// ignore: camel_case_types
class _terlarisState extends State<terlaris> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  // ignore: non_constant_identifier_names
  final User = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: const Center(
          child: Text(
            'Favorit',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
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
      body: StreamBuilder<QuerySnapshot>(
          stream: firestore
              .collection("books")
              .where("isFavorit", isEqualTo: "1")
              .snapshots(),
          builder: (context, snapshot) {
            return !snapshot.hasData
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 150,
                        childAspectRatio:
                            MediaQuery.of(context).size.height / 1400,
                      ),
                      primary: true,
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: ((context, index) {
                        DocumentSnapshot data = snapshot.data!.docs[index];
                        return CardBook(data, context);
                      }),
                    ),
                  );
          }),
    );
  }

  // ignore: non_constant_identifier_names
  Card CardBook(DocumentSnapshot data, BuildContext contex) {
    return Card(
      margin: const EdgeInsets.only(right: 5, left: 5, top: 5),
      child: InkWell(
          onTap: () {},
          splashColor: Colors.blueAccent,
          child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                color: Colors.blueAccent,
                width: 3,
              )),
              child: Center(
                  child: Column(
                children: [
                  SizedBox(
                    height: 200,
                    child: Column(children: <Widget>[
                      Image.network(
                        data["image"],
                        height: 150,
                        width: 150,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data["judul_buku"],
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                data["pengarang"],
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.black,
                                ),
                              ),
                            ]),
                      )
                    ]),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        border: Border(
                            top: BorderSide(color: Colors.blue, width: 1))),
                    height: 35,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Pembaca 100",
                          style: TextStyle(fontSize: 10),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.favorite,
                              color: Colors.blue,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              "50",
                              style: TextStyle(fontSize: 10),
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              )))),
    );
  }
}
