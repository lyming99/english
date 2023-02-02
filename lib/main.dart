import 'dart:convert';
import 'dart:io';

import 'package:english/controller/app/app.dart';
import 'package:english/dicts/reader.dart';
import 'package:english/route/routes.dart';
import 'package:english/service/app/app.dart';
import 'package:english/service/word/word.dart';
import 'package:english/util/assets.dart';
import 'package:floor/floor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'dao/floor.dart';
import 'util/encypt.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //强制竖屏
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  await GetStorage.init();
  var path = await sqfliteDatabaseFactory.getDatabasePath("english.db");
  path = path.replaceAll("\\", "/");
  var index = path.lastIndexOf("/");
  var dbDir = Directory(path.substring(0, index));
  if (!dbDir.existsSync()) {
    dbDir.createSync(recursive: true);
  }
  if ((!File(path).existsSync() || await File(path).length() < 100000)) {
    await releaseAssetsToFile("assets/dict.db1", File(path));
  }
  var appDatabase =
      await $FloorAppDatabase.databaseBuilder("english.db").build();
  Get.put(appDatabase);
  Get.put(appDatabase.wordDao);
  Get.put(WordService());
  Get.put(AppService());
  Get.put(AppController());
  runApp(const MyApp());
}

class MyApp extends GetView<AppController> {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      getPages: pages,
      scrollBehavior: NoShadowScrollBehavior().copyWith(
        physics: const BouncingScrollPhysics(),
      ),
    );
  }
}

/// 隐藏水波纹配置
class NoShadowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    switch (getPlatform(context)) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return child;
      case TargetPlatform.android:
        return GlowingOverscrollIndicator(
          showLeading: false,
          showTrailing: false,
          axisDirection: axisDirection,
          color: Theme.of(context).accentColor,
          child: child,
        );
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return GlowingOverscrollIndicator(
          //不显示头部水波纹
          showLeading: false,
          //不显示尾部水波纹
          showTrailing: false,
          axisDirection: axisDirection,
          color: Theme.of(context).accentColor,
          child: child,
        );
    }
  }
}
