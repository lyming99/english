import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class WordListController extends GetxController {
  var pageController = PageController();
  var pageIndex = 0.obs;
  var title = "播放列表".obs;

  @override
  void onInit() {
    super.onInit();
    print('word list on init.');
  }

  @override
  void onReady() {
    super.onReady();
    print('word list on ready.');
  }

  @override
  void onClose() {
    print('word list on close.');
    super.onClose();
  }

  void onPageChanged(int index) {
    pageIndex.value = index;
    switch (index) {
      case 0:
        title.value = "播放列表";
        break;
      case 1:
        title.value = "已学习(PASS)";
        break;
      case 2:
        title.value = "熟词(已删除)";
        break;
    }
  }
}
