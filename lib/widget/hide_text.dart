import 'package:flutter/material.dart';

class HideText extends StatelessWidget {
  TextSpan text;
  Color color;
  bool show;

  HideText({
    Key? key,
    required this.text,
    required this.color,
    required this.show,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, cons) {
      var painter = TextPainter(
        text: text,
        textDirection: TextDirection.ltr,
      );
      painter.layout();
      return Stack(
        children: [
          Opacity(
            opacity: show ? 1 : 0,
            child: Container(
              // alignment: Alignment.bottomCenter,
              width: painter.width + 12,
              height: painter.height,
              alignment: Alignment.bottomCenter,
              child: RichText(
                text: text,
              ),
            ),
          ),
          Container(
            // alignment: Alignment.bottomCenter,
            width: painter.width + 12,
            height: painter.height,
            decoration: BoxDecoration(
                border:
                Border(bottom: BorderSide(color: Colors.grey, width: 1))),
            // child: show
            //     ? null
            //     : Icon(
            //   Icons.remove_red_eye,
            //   color: color,
            // ),
          ),
        ],
      );
    });
  }
}
