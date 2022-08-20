import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:encrypt/encrypt.dart';

Future<void> encryptTest() async {
  var json = await File("assets/dict.json").readAsBytes();
  var data = gzip.encoder.convert(json);
  final key = Key.fromUtf8('7duxouJsdlJASJ!SdsfO=sdf23joj&sd');
  var iv = IV.fromLength(16);
  final encrypter = Encrypter(AES(key));
  var encode = encrypter.encryptBytes(data, iv: iv);
  File("assets/dict.encypt").writeAsBytes(encode.bytes);
}

Future<void> decryptTest() async {
  var startTime = DateTime.now();
  var data = await File("assets/dict.encypt").readAsBytes();
  var decodes = await _decrypt(data);
  print('wocao');
  final key = Key.fromUtf8('7duxouJsdlJASJ!SdsfO=sdf23joj&sd');
  var iv = IV.fromLength(16);
  final encrypter = Encrypter(AES(key));
  var decode = encrypter.decryptBytes(Encrypted(data), iv: iv);
  var uzip = gzip.decoder.convert(decodes);
  var utf = utf8.decoder.convert(uzip);
  const JsonDecoder().convert(utf);
  var sub = utf.substring(0,100);
  print('$sub');
  var endTime = DateTime.now();
  print('use time:${endTime.millisecondsSinceEpoch-startTime.millisecondsSinceEpoch}');
}

Future<List<int>> _decrypt(Uint8List src) async {
  final key = Key.fromUtf8('7duxouJsdlJASJ!SdsfO=sdf23joj&sd');
  var iv = IV.fromLength(16);
  var aes = AesCtr.with256bits(macAlgorithm: Hmac.sha256());
  var secretKey = await aes.newSecretKeyFromBytes(key.bytes);
  final correctMac = await aes.macAlgorithm.calculateMac(
    src,
    secretKey: secretKey,
    nonce: iv.bytes,
    aad: [],
  );
  var secretBox = SecretBox(src,nonce: iv.bytes,mac:correctMac);
  var ret = await aes.decrypt(secretBox, secretKey: secretKey);
  return ret;
}
void main() async {
  // await encryptTest();
  await decryptTest();
}
