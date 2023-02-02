import 'package:english/controller/app/app.dart';
import 'package:english/controller/study/study.dart';
import 'package:english/entity/word/po/word.dart';
import 'package:english/service/study/study.dart';
import 'package:english/service/word/word.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../entity/word/vo/word.dart';
import '../../service/app/app.dart';

class WordListController extends GetxController {
  var pageController = PageController();
  var pageIndex = 0.obs;
  var title = "播放列表".obs;
  var passList = Rx(<String>[]);
  var deleteList = Rx(<String>[]);
  var allList = Rx(<String>[]);

  var wordSearchText = "".obs;
  @override
  void onInit() {
    super.onInit();
    fetchWordList();
  }

  void fetchWordList() async {
    await fetchBookPassWordList();
    await fetchBookDeleteWordList();
    await fetchBookAllWordList();
    onPageChanged(pageIndex.value);
  }

  /// 查询所有单词列表
  Future<void> fetchBookAllWordList() async {
    AppController app = Get.find();
    StudyController study = Get.find();
    var allList = await app.appService.wordDao
        .queryBookNotDeleteWord(app.appService.bookId);
    var all =
        allList.map((e) => study.appService.getWord(e)?.word ?? "").toList();
    all.sort();
    this.allList.value = all;
  }

  /// 查询删除单词列表
  Future<void> fetchBookDeleteWordList() async {
    AppController app = Get.find();
    StudyController study = Get.find();
    var deleteList =
        await app.appService.wordDao.queryBookDeleteWord(app.appService.bookId);
    this.deleteList.value =
        deleteList.map((e) => study.appService.getWord(e)?.word ?? "").toList();
  }

  /// 查询pass单词列表
  Future<void> fetchBookPassWordList() async {
    AppController app = Get.find();
    StudyController study = Get.find();
    var passList =
        await app.appService.wordDao.queryBookPassWord(app.appService.bookId);
    this.passList.value =
        passList.map((e) => study.appService.getWord(e)?.word ?? "").toList();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void onPageChanged(int index) {
    pageIndex.value = index;
    StudyController studyService = Get.find();
    switch (index) {
      case 0:
        title.value = "播放列表 · ${studyService.playingWords.length}";
        break;
      case 1:
        title.value = "已学习(PASS) · ${passList.value.length}";
        break;
      case 2:
        title.value = "熟词(已删除) · ${deleteList.value.length}";
        break;
      case 3:
        title.value = "全部单词 · ${allList.value.length}";
        break;
    }
  }

  WordVO? getWordVO(String word) {
    AppService wordService = Get.find();
    return wordService.toWordVO(wordService.getWordBySpell(word));
  }

  /// 根据单词含义搜索单词
  bool isContainsMeans(String word,String meansText){
    var wordVo = getWordVO(word);
    var means = wordVo?.means;
    if(means!=null) {
      for (var mean in means) {
        var contains = mean.toString().toLowerCase().contains(meansText.toLowerCase());
        if(contains){
          return true;
        }
      }
    }
    return false;
  }

  /// 设为熟词：删除单词
  Future<void> deleteWord(WordVO word) async {
    AppService wordService = Get.find();
    await wordService.deleteWord(word.wordId);
    word.isDelete = await wordService.queryWordDeleteStatus(word.wordId);
  }

  /// 重新学习：从删除数据库，恢复单词
  Future<void> restoreWord(WordVO word) async {
    AppService wordService = Get.find();
    await wordService.restoreWord(word.wordId);
    word.isDelete = await wordService.queryWordDeleteStatus(word.wordId);
  }

  /// 获取单词删除状态
  Future<void> getDeleteStatus(WordVO word) async {
    AppService wordService = Get.find();
    word.isDelete = await wordService.queryWordDeleteStatus(word.wordId);
  }
}
