import 'dart:convert';
import 'dart:io';

import 'package:english/dao/floor.dart';
import 'package:floor/floor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../entity/word/po/word.dart';
import '../../entity/word/vo/word.dart';
import '../../service/app/app.dart';

class AppController extends GetxController {
  var appService = Get.find<AppService>();

  @override
  void onInit() async {
    super.onInit();
    _init();
  }

  Future<void> _init() async {
    appService.readOptions();
  }
}
