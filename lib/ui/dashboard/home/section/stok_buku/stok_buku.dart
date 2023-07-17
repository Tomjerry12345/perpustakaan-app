import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StokBuku extends StatefulWidget {
  const StokBuku({Key? key}) : super(key: key);

  @override
  State<StokBuku> createState() => _StokBukuState();
}

class _StokBukuState extends State<StokBuku> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: new Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: new Center(
          child: Text(
            'Stok Buku',
            style: TextStyle(color: Colors.white),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xff0096ff), Color(0xff6610f2)],
                begin: FractionalOffset.bottomLeft,
                end: FractionalOffset.bottomRight),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: firestore.collection("books").snapshots(),
          builder: (context, snapshot) {
            return !snapshot.hasData
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 150,
                        childAspectRatio: MediaQuery.of(context).size.height / 1400,
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

  Card CardBook(DocumentSnapshot data, BuildContext contex) {
    return Card(
        margin: EdgeInsets.only(right: 5, left: 5, top: 5),
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
                    child: Column(children: [
                  Container(
                    height: 200,
                    child: Column(children: <Widget>[
                      Image.network(
                        data["image"],
                        height: 150,
                        width: 150,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(
                            data["judul_buku"],
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            data["pengarang"],
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.black,
                            ),
                          ),
                        ]),
                      )
                    ]),
                  )
                ])))));
  }
}
