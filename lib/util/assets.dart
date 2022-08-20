
import 'dart:io';

import 'package:flutter/services.dart';

Future<void> releaseAssetsToFile(String assetsName,File file)async{
  ByteData data = await rootBundle.load(assetsName);
  file.writeAsBytes(data.buffer.asUint8List());
}