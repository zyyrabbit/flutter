import 'dart:convert';
import 'package:crypto/crypto.dart';

class CommonUtil {
  static String encodeBase64(String data){
    var content = utf8.encode(data);
    var digest = base64Encode(content);
    return digest;
  }

  static String sha512Hash(String data){
    var bytes = utf8.encode(data); // data being hashed
    var digest = sha512.convert(bytes);

    print("Digest as bytes: ${digest.bytes}");
    print("Digest as hex string: $digest");
  }
}