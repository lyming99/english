import 'package:english/controller/selectBook/selectBook.dart';
import 'package:english/controller/study/wordList.dart';
import 'package:english/view/selectBook/selectBook.dart';
import 'package:get/get.dart';

import '../controller/home/home.dart';
import '../controller/study/study.dart';
import '../service/home/home.dart';
import '../service/study/study.dart';
import '../view/home/home.dart';
import '../view/study/study.dart';
//路由
var pages = [
  GetPage(
      name: "/",
      page: () {
        Get.put(HomeService());
        Get.put(HomeController());
        return HomeView();
      }),
  GetPage(
      name: "/study",
      page: () {
        Get.put(StudyService());
        Get.put(StudyController());
        return StudyPage();
      }),
  GetPage(
      name: "/selectBook",
      page: () {
        Get.put(SelectBookController());
        return SelectBookPage();
      }),

];