extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  String formatTitik(jumlah) =>
      length > jumlah ? "${substring(0, jumlah)}..." : this;
}
