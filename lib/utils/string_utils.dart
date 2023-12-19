List<String> normalizeTitle(String title) {
  // Mengonversi ke huruf kecil dan menghapus karakter khusus
  String normalizedTitle =
      title.toLowerCase().replaceAll(RegExp(r'[^\w\s]'), '');

  // Memisahkan judul menjadi kata-kata terpisah
  List<String> words = normalizedTitle.split(' ');

  // Mengembalikan judul yang sudah dinormalisasi dalam bentuk list kata
  return words;
}
