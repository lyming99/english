import 'package:english/service/app/app.dart';
import 'package:english/service/word/word.dart';
import 'package:english/widget/sentence.dart';
import 'package:get/get.dart';

class SelectBookController extends GetxController {
  AppService appService = Get.find();

  get bookCount => appService.wordService.bookNames.length;

  get bookNames => appService.wordService.bookNames;

  get selectBookName => appService.bookName;

  get bookInfo => appService.wordService.bookInfo;

  get bookMap => appService.wordService.bookMap;
}
