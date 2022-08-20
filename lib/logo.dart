import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() async {
  var paint = Paint();
  var recorder = PictureRecorder();
  var canvas = Canvas(recorder);
  paint.color = Color(0xff522985);
  paint.color = Colors.white;
  canvas.drawRRect(
      RRect.fromLTRBR(0, 0, 1024, 1024, Radius.circular(96)), paint);
  paint.color = Colors.white;
  var painter = TextPainter(
      text: TextSpan(
          text: "晨晨",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 380,
            color: Colors.deepOrangeAccent
          )),
      textDirection: TextDirection.ltr);
  painter.layout();
  painter.paint(canvas, Offset((1024-painter.width)/2, (1024-painter.height)/2));
  var picture = recorder.endRecording();
  var image = await picture.toImage(1024, 1024);
  var imageBytes = await image.toByteData(format: ImageByteFormat.png);
  var bytes = imageBytes!.buffer.asUint8List();
  await File("hello.png").writeAsBytes(bytes);
  print('image ok');
  runApp(MaterialApp(
    home: Container(
      child: FittedBox(
        child: Image.memory(bytes),
      ),
    ),
  ));
}
