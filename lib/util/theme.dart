import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void setStatusBar(BuildContext context) {
  var th = Theme.of(context).brightness == Brightness.light
      ? SystemUiOverlayStyle.dark
      : SystemUiOverlayStyle.light;
  SystemChrome.setSystemUIOverlayStyle(th.copyWith(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
  ));
}
