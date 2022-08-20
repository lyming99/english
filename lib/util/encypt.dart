import 'dart:convert';
import 'dart:io';

import 'package:encrypt/encrypt.dart';
import 'package:flutter/services.dart';

Future<String> wordsText() async {
  ByteData data = await rootBundle.load("assets/dict.db");
  var buff = data.buffer.asUint8List();
  final key = Key.fromUtf8('7duxouJsdlJASJ!SdsfO=sdf23joj&sd');
  var iv = IV.fromLength(16);
  final encrypter = Encrypter(AES(key));
  var decode = encrypter.decryptBytes(Encrypted(buff), iv: iv);
  var uzip = gzip.decoder.convert(decode);
  var utf = utf8.decoder.convert(uzip);
  return utf;
}
