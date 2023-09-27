import 'dart:math';

String generateRandomString(int length) {
  final random = Random();
  const possibleDigits = "0123456789";

  String randomString = "";
  for (int i = 0; i < length; i++) {
    int randomIndex = random.nextInt(possibleDigits.length);
    randomString += possibleDigits[randomIndex];
  }

  return randomString;
}