import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../model/ModelQuery.dart';

class FirebaseServices {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  void add(String path, data) {
    _db
        .collection(path)
        .add(data)
        .then((DocumentReference doc) => print('DocumentSnapshot added with ID: ${doc.id}'));
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAll(String path) {
    return _db.collection(path).get();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllStream(String path) {
    return _db.collection(path).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> query(String path, List<ModelQuery> query) {
    Query<Map<String, dynamic>> collection = _db.collection(path);

    query.forEach((e) {
      collection = collection.where(e.key, isEqualTo: e.value);
    });

    return collection.snapshots();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> queryFuture(
      String path, List<ModelQuery> query) async {
    Query<Map<String, dynamic>> collection = _db.collection(path);

    query.forEach((e) {
      collection = collection.where(e.key, isEqualTo: e.value);
    });

    return collection.get();
  }

  Future<void> update(String path, String id, data) async {
    return _db
        .collection(path)
        .doc(id)
        .update(data)
        .then((value) => print("sukses"))
        .catchError((error) => print("Failed to delete user: $error"));
  }

  void delete(String path, String id) {
    _db
        .collection(path)
        .doc(id)
        .delete()
        .then((value) => print('Berhasil menghapush data'))
        .catchError((error) => print("Failed to delete user: $error"));
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future uploadFile(File file, String type) async {
    String fileName = basename(file.path);
    final firebaseStorageRef = FirebaseStorage.instance.ref().child('$type/$fileName');
    final uploadTask = await firebaseStorageRef.putFile(file);
    final taskSnapshot = uploadTask.ref.getDownloadURL();
    return taskSnapshot;
  }
}
