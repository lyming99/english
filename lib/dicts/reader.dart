import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';
import 'package:flutter/services.dart';
import 'package:cryptography/cryptography.dart';

import 'relation.dart';

class Word {
  String? id;
  String? word;
  String? usVoice;
  String? ukVoice;
  String? means;
  String? helper;
  List<Sentence>? sentences;

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'word': this.word,
      'usVoice': this.usVoice,
      'ukVoice': this.ukVoice,
      'means': this.means,
      'helper': this.helper,
      'sentences': this.sentences,
    };
  }

  factory Word.fromMap(Map<String, dynamic> map) {
    var sentences = map['sentences'] as List<dynamic>;
    return Word(
      id: map['id'] as String?,
      word: map['word'] as String?,
      usVoice: map['usVoice'] as String?,
      ukVoice: map['ukVoice'] as String?,
      means: map['means'] as String?,
      helper: map['helper'] as String?,
      sentences: sentences.map((e) {
        return Sentence(
          sentence: e["sentence"] as String,
          sentenceCn: e["sentenceCn"] as String,
        );
      }).toList(),
    );
  }

  Word({
    this.id,
    this.word,
    this.usVoice,
    this.ukVoice,
    this.means,
    this.helper,
    this.sentences,
  });
}

class Sentence {
  String? sentence;
  String? sentenceCn;

  Sentence({
    this.sentence,
    this.sentenceCn,
  });
}

class Book {
  String? id;
  String? name;
  List<Word>? words;

  Book({
    this.id,
    this.name,
    this.words,
  });
}

Future<List<Book>> readBookMap(Map<String, Word> wordMap) async {
  var res = <String, Book>{};
  for (var id in bookMap.keys) {
    var book = Book(id: id.toString(), name: bookMap[id], words: []);
    res[id.toString()] = book;
  }
  var relations = relation.split(",");
  for (var r in relations) {
    var arr = r.split(">");
    var wordId = arr[0];
    var bookId = arr[1];
    var word = wordMap[wordId];
    var book = res[bookId];
    if (word != null) {
      book?.words?.add(word);
    }
  }
  return res.values.toList();
}

Future<Map<String, Word>> readWordMap() async {
  var wordMap = <String, Word>{};
  var readTextTime = DateTime.now();
  var json = await _readWordsText();
  var convertJsonTime = DateTime.now();
  List<dynamic> wordsJson = const JsonDecoder().convert(json);
  for (var value in wordsJson) {
    var word = Word.fromMap(value);
    wordMap[word.id!] = word;
  }
  var endTime = DateTime.now();
  print(
      "read text use time:${convertJsonTime.millisecondsSinceEpoch - readTextTime.millisecondsSinceEpoch} "
      "\n convert json use time:${endTime.millisecondsSinceEpoch - convertJsonTime.millisecondsSinceEpoch}");
  return wordMap;
}

Future<List<int>> _decrypt(Uint8List src) async {
  final key = Key.fromUtf8('7duxouJsdlJASJ!SdsfO=sdf23joj&sd');
  var iv = IV.fromLength(16);
  if (Platform.isAndroid || Platform.isIOS) {
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
  } else {
    var aes = AES(key);
    return aes.decrypt(Encrypted(src), iv: iv);
  }
}

Future<String> _readWordsText() async {
  var readBuffTime = DateTime.now().millisecondsSinceEpoch;
  ByteData data = await rootBundle.load("assets/dict.db");
  var buff = data.buffer.asUint8List();
  var decryptTime = DateTime.now().millisecondsSinceEpoch;
  var decode = await _decrypt(buff);
  var gzipTime = DateTime.now().millisecondsSinceEpoch;
  var uzip = gzip.decoder.convert(decode);
  var textTime = DateTime.now().millisecondsSinceEpoch;
  var utf = utf8.decoder.convert(uzip);
  var endTime = DateTime.now().millisecondsSinceEpoch;
  print('read file use time:${decryptTime - readBuffTime}');
  print('decrypt file use time:${gzipTime - decryptTime}');
  print('gzip file use time:${textTime - gzipTime}');
  print('convert text use time:${endTime - textTime}');
  return utf;
}
