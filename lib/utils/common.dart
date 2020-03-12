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

  ///验证URL
  static bool isUrl(String value) {
    return RegExp(r"^((https|http|ftp|rtsp|mms)?:\/\/)[^\s]+")
      .hasMatch(value);
  }

  static String getCurrntDateTime() {
    return DateTime.parse('${DateTime.now().toString()}-0800').toString();
  }

  static String getCurrntDate() {
    String dateTime = getCurrntDateTime();
    return dateTime.split(' ')[0];
  }
}