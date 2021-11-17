import 'dart:convert';

import 'package:crypto/crypto.dart' as crypto;

class CryptoHelper {
  static String sha1Str(String str) {
    return crypto.sha1.convert(utf8.encode(str)).toString();
  }
}
