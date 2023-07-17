import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class terlaris extends StatefulWidget {
  const terlaris({Key? key}) : super(key: key);

  @override
  State<terlaris> createState() => _terlarisState();
}

class _terlarisState extends State<terlaris> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final User = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          child: new Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: new Center(
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
          stream: firestore
              .collection("books")
              .where("isFavorit", isEqualTo: "1")
              .snapshots(),
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
                  child: Column(
                children: [
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
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(color: Colors.blue, width: 1))),
                    height: 35,
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
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
