import 'dart:math';

import 'package:flutter/material.dart';

class MaxWidthText extends StatelessWidget {
  double maxWidth;
  String text;
  TextStyle? style;
  int? maxLines;

  MaxWidthText({
    Key? key,
    required this.text,
    required this.maxWidth,
    this.maxLines,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      var painter = TextPainter(
        text: TextSpan(text: text, style: style),
        textDirection: TextDirection.ltr,
      );
      painter.layout(maxWidth: constraints.maxWidth);
      return Container(
        width: min(maxWidth, painter.width),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Text(
            text,
            style: style,
            maxLines: maxLines,
          ),
        ),
      );
    });
  }
}
