import 'package:english/controller/app/app.dart';
import 'package:english/controller/study/study.dart';
import 'package:english/service/study/study.dart';
import 'package:english/service/word/word.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class WordListController extends GetxController {
  var pageController = PageController();
  var pageIndex = 0.obs;
  var title = "播放列表".obs;
  var passList = Rx(<String>[]);
  var deleteList = Rx(<String>[]);
  var allList = Rx(<String>[]);

  @override
  void onInit() {
    super.onInit();
    fetchWordList();
  }

  void fetchWordList() async {
    AppController app = Get.find();
    StudyController study = Get.find();
    var passList =
        await app.appService.wordDao.queryBookPassWord(app.appService.bookId);
    this.passList.value =
        passList.map((e) => study.appService.getWord(e)?.word ?? "").toList();

    var deleteList =
        await app.appService.wordDao.queryBookDeleteWord(app.appService.bookId);
    this.deleteList.value =
        deleteList.map((e) => study.appService.getWord(e)?.word ?? "").toList();
    var allList =
        await app.appService.wordDao.queryBookNotDeleteWord(app.appService.bookId);
    var all =
        allList.map((e) => study.appService.getWord(e)?.word ?? "").toList();
    all.sort();
    this.allList.value = all;

    onPageChanged(pageIndex.value);
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
}
