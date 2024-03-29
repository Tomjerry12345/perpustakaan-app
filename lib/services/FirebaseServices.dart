// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/ModelQuery.dart';
import '../utils/log_utils.dart';

class FirebaseServices {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> signInWithEmailAndPassword(email, password) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  void add(String path, data) {
    _db.collection(path).add(data).then((DocumentReference doc) =>
        log('DocumentSnapshot added with ID', v: doc.id));
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAll(String path) {
    return _db.collection(path).get();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllStream(String path) {
    return _db.collection(path).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> query(
      String path, List<ModelQuery> query) {
    Query<Map<String, dynamic>> collection = _db.collection(path);

    for (var e in query) {
      collection = collection.where(e.key, isEqualTo: e.value);
    }

    return collection.snapshots();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> queryFuture(
      String path, List<ModelQuery> query) {
    Query<Map<String, dynamic>> collection = _db.collection(path);

    for (var e in query) {
      collection = collection.where(e.key, isEqualTo: e.value);
    }

    return collection.get();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> searching(
      String path, String key, String value) {
    Query<Map<String, dynamic>> collection = _db.collection(path);

    log("value ", v: value);

    collection = collection.where(key, arrayContainsAny: [
      value.substring(0, 1).toUpperCase() + value.substring(1),
      value.substring(0, 1).toLowerCase() + value.substring(1),
    ]);

    return collection.snapshots();
  }

  Future<void> update(String path, String id, data) async {
    return _db
        .collection(path)
        .doc(id)
        .update(data)
        .then((value) => log("sukses"))
        .catchError((error) => log("Failed to update user: $error"));
  }

  void delete(String path, String id) {
    _db
        .collection(path)
        .doc(id)
        .delete()
        .then((value) => log('Berhasil menghapush data'))
        .catchError((error) => log("Failed to delete user: $error"));
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
