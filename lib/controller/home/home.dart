import 'dart:math';

import 'package:english/dao/word/word.dart';
import 'package:english/entity/record/po/record.dart';
import 'package:english/service/app/app.dart';
import 'package:english/util/time.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../util/theme.dart';
import '../../widget/book_icon.dart';

class HomeController extends GetxController {
  var studyTime = 0.0.obs;
  var reviewCount = 0.obs;
  var dailyWordCount = 0.obs;
  var progress = "加载中...".obs;
  var progressPercent = 0.0.obs;
  var wordBook = "加载中...".obs;
  var username = "加载中...".obs;
  var bookIcon = BookImage().obs;
  AppService appService = Get.find();
  var wordDao = Get.find<WordDao>();

  void toStudy() async {
    await Get.toNamed("/study");
    await const Duration(milliseconds: 500).delay();
    setStatusBar(Get.context!);
    fetchInfo();
  }

  @override
  void onInit() {
    super.onInit();
    fetchInfo();
  }

  void fetchInfo() async {
    username.value = "";
    wordBook.value = appService.bookName;
    var bookInfo = appService.wordService.bookInfo[appService.bookName] as Map;
    bookIcon.value = BookImage(
      title: bookInfo["title"],
      subTitle: bookInfo["subTitle"],
      color: bookInfo["color"],
      fontColor: bookInfo["fontColor"],
      wordCount: "",
    );
    await appService.readWords();
    bookIcon.value = BookImage(
      title: bookInfo["title"],
      subTitle: bookInfo["subTitle"],
      color: bookInfo["color"],
      fontColor: bookInfo["fontColor"],
      wordCount: "词汇量:${appService.wordService.bookMap[appService.bookName]?.words?.length}",
    );
    var allCount = await wordDao.queryWordCount(appService.bookId);
    var progressCount = await wordDao.queryProgressWordCount(appService.bookId);
    var dailyCount = await wordDao.queryDailyPassWordCount();
    progress.value = "$progressCount/$allCount";
    dailyWordCount.value = dailyCount ?? 0;
    var reviewCount = await wordDao.queryReviewWordCount();
    this.reviewCount.value = reviewCount ?? 0;
    var studyTime = (await wordDao.queryStudyTime()) ?? 0;
    this.studyTime.value = studyTime / 1000 / 60;
  }

  ///todo 单词书切换
  ///统计变化
  void selectBook(String bookName) {
    appService.selectBook(bookName);
    fetchInfo();
  }
}
