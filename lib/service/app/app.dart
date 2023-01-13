import 'dart:convert';
import 'dart:typed_data';

import 'package:english/dao/word/word.dart';
import 'package:english/dicts/reader.dart';
import 'package:english/dicts/relation.dart';
import 'package:english/service/word/word.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../entity/word/po/word.dart';
import '../../entity/word/vo/word.dart';

class AppService {
  WordService wordService = Get.find();
  var wordDao = Get.find<WordDao>();
  var queueCount = 4;
  int dailyWantCount = 100;
  String? _bookName;

  String get bookName {
    return _bookName ?? wordService.bookNames[0];
  }

  String getBookId(String? bookName) {
    return wordService.bookMap[bookName]?.id ?? "1";
  }

  int get bookId {
    return int.parse(getBookId(_bookName));
  }

  int thinkWaitTime = 1;

  int readWaitTime = 7;

  //艾宾浩斯记忆曲线时间点
  List<int> get reviewTimes {
    int minutes = 60 * 1000;
    int hour = 60 * minutes;
    int day = 24 * 60 * 60 * 1000;
    int month = 30 * day;
    return [
      5 * minutes, //5分钟
      25 * minutes, //30分钟
      12*60 * minutes, //12小时
      1 * day, //1天
      2 * day, //2天
      4 * day, //4天
      7 * day, //7天
      15 * day, //15天
      month, //1月
      2 * month, //2月
      4 * month, //4月
      7 * month, //7月
      15 * month, //15月
    ];
  }

  int get wordCount {
    return wordService.bookMap[bookName]?.words?.length ?? 0;
  }

  ///加载词汇数据库
  Future<void> readWords() async {
    await wordService.loadWords();
    // await insertToDb();
  }

  //将单词数据插入到数据库
  Future<void> insertToDb() async {
    if (bookLoaded()) {
      return;
    }
    wordDao.clearWord();
    var start = DateTime.now().millisecondsSinceEpoch;
    var count = 0;
    for (var book in wordService.bookMap.values) {
      var words = book.words;
      if (words != null) {
        var wordPOs = words.map((e) {
          return WordPO(word: e.id, book: book.id);
        }).toList();
        count += wordPOs.length;
        await wordDao.addWords(wordPOs);
      }
    }
    var end = DateTime.now().millisecondsSinceEpoch;
    print('insert words use time: ${end - start} word count:$count');
    setBookLoaded();
  }

  bool bookLoaded() {
    var storage = GetStorage();
    return storage.read("book-loaded") == "true";
  }

  void setBookLoaded() {
    var storage = GetStorage();
    storage.write("book-loaded", "true");
    storage.save();
  }

  void saveOptions() {
    var storage = GetStorage();
    storage.write("study.dailyWantCount", dailyWantCount);
    storage.write("study.thinkWaitTime", thinkWaitTime);
    storage.write("study.readWaitTime", readWaitTime);
    storage.write("study.queueCount", queueCount);
    storage.write("study.bookName", bookName);
    storage.save();
  }

  void readOptions() {
    var storage = GetStorage();
    var dailyWantCount = storage.read(
          "study.dailyWantCount",
        ) ??
        "100";
    this.dailyWantCount = int.parse(dailyWantCount.toString());
    var thinkWaitTime = storage.read(
          "study.thinkWaitTime",
        ) ??
        "1";
    this.thinkWaitTime = int.parse(thinkWaitTime.toString());
    var readWaitTime = storage.read(
          "study.readWaitTime",
        ) ??
        "7";
    this.readWaitTime = int.parse(readWaitTime.toString());
    var queueCount = storage.read(
          "study.queueCount",
        ) ??
        "4";
    this.queueCount = int.parse(queueCount.toString());

    _bookName = storage.read(
      "study.bookName",
    );
  }

  Word? getWord(String? id) {
    return wordService.wordMap[id];
  }

  void selectBook(String bookName) {
    _bookName = bookName;
    saveOptions();
  }
}
