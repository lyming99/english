import 'dart:convert';
import 'dart:typed_data';

import 'package:english/dao/word/word.dart';
import 'package:english/dicts/reader.dart';
import 'package:english/service/word/word.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../entity/word/po/word.dart';
import '../../entity/word/vo/word.dart';

class AppService {
  WordService wordService = Get.find();
  var wordDao = Get.find<WordDao>();
  var queueCount = 4;
  int dailyWantCount = 100;
  bool autoPass = false;
  String? _bookName;

  String get bookName {
    return _bookName ?? wordService.bookNames[0];
  }

  String getBookId(String? bookName) {
    return wordService.bookMap[bookName]?.id ?? "2";
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
      25 * minutes, //25分钟
      hour, //1小时
      1 * day - hour, //1天后
      1 * day - hour, //2天后
      2 * day - hour, //4天后
      3 * day - hour, //7天后
      8 * day - hour, //15天后
      month - 15 * day - hour, //1月后
      1 * month - hour, //2月后
      2 * month - hour, //4月后
      3 * month - hour, //7月后
      8 * month - hour, //15月后
      15 * month - hour, //30月后
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
    storage.write("study.autoPass", autoPass ? "true" : "false");
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
    var autoPass = storage.read("autoPass");
    this.autoPass = autoPass.toString() == "true";
  }

  ///通过单词id获取单词数据
  Word? getWord(String? id) {
    return wordService.wordMap[id];
  }

  Word? getWordBySpell(String? spell) {
    var find = wordService.wordMap.values
        .firstWhere((element) => element.word == spell, orElse: () {
      return Word();
    });
    if (find.id == null) {
      return null;
    }
    return find;
  }
  WordVO? getWordVO(String? id) {
    return toWordVO(wordService.wordMap[id]);
  }
  WordVO? toWordVO(Word? word) {
    if (word != null) {
      return WordVO(
        wordId: word.id,
        word: word.word,
        usaVoice: word.usVoice,
        ukVoice: word.ukVoice,
        means: word.means?.split("\n"),
        sentence: () {
          var len = word.sentences?.length ?? 0;
          if (len > 0) {
            return word.sentences?[0].sentence;
          }
        }(),
        sentenceMeans: () {
          var len = word.sentences?.length ?? 0;
          if (len > 0) {
            return word.sentences?[0].sentenceCn;
          }
        }(),
      );
    }
    return null;
  }

  void selectBook(String bookName) {
    _bookName = bookName;
    saveOptions();
  }

  /// 查询单词是否删除: -1为删除，null或者其它状态为为删除
  Future<bool?> queryWordDeleteStatus(String? word) async {
    var status = await wordDao.queryWordStatus(word ?? "");
    var statusFlag = status?.status;
    return statusFlag == -1;
  }

  /// 删除单词：设为熟词
  Future<void> deleteWord(String? wordId) async {
    await wordDao.upsetWordStatusById(wordId, -1);
  }

  /// 恢复单词：重新学习
  Future<void> restoreWord(String? wordId) async {
    await wordDao.upsetWordStatusById(wordId, 0);
  }
}
