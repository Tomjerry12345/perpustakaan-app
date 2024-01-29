// ignore_for_file: file_names

import 'package:animated_custom_dropdown/custom_dropdown.dart';

class ModelBuku with CustomDropdownListFilter {
  final String kategori;

  ModelBuku({required this.kategori});

  @override
  String toString() {
    return kategori;
  }

  @override
  bool filter(String query) {
    return kategori.toLowerCase().contains(query.toLowerCase());
  }
}
