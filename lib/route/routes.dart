import 'package:english/controller/selectBook/selectBook.dart';
import 'package:english/controller/study/wordList.dart';
import 'package:english/view/selectBook/selectBook.dart';
import 'package:get/get.dart';

import '../controller/home/home.dart';
import '../controller/statistic/statistic.dart';
import '../controller/study/study.dart';
import '../service/home/home.dart';
import '../service/study/study.dart';
import '../view/home/home.dart';
import '../view/statistic/statistic.dart';
import '../view/study/study.dart';

//路由
var pages = [
  //主页
  GetPage(
      name: "/",
      page: () {
        Get.put(HomeService());
        Get.put(HomeController());
        return HomeView();
      }),

  //学习界面
  GetPage(
      name: "/study",
      page: () {
        Get.put(StudyService());
        Get.put(StudyController());
        return StudyPage();
      }),

  //选择书本界面
  GetPage(
      name: "/selectBook",
      page: () {
        Get.put(SelectBookController());
        return SelectBookPage();
      }),

  //统计详情界面
  GetPage(
      name: "/statistic",
      page: () {
        Get.put(StatisticController());
        return StatisticPage();
      }),
];
