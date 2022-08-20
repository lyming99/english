import 'package:flutter/material.dart';

class BookImage extends StatelessWidget {
  String? title;
  String? subTitle;
  String? wordCount;
  Color? fontColor;
  Color? color;

  BookImage({
    Key? key,
    this.title,
    this.subTitle,
    this.wordCount,
    this.fontColor,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 120,
      child: Stack(
        children: [
          Positioned(
            left: 10,
            top: 10,
            child: Text(
              "$title",
              style: TextStyle(
                fontSize: 15,
                color: fontColor ?? Colors.white,
              ),
            ),
          ),
          Positioned(
              top: 32,
              child: Container(
                color: (fontColor ?? Colors.white).withOpacity(0.9),
                width: 80,
                height: 2,
              )),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    "$subTitle",
                    style: TextStyle(
                      color: fontColor ?? Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),

              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "$wordCount",
                    style: TextStyle(
                      color: (fontColor ?? Colors.white).withOpacity(0.4),
                      fontSize: 12,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  width: 30,
                  height: 2,
                  color: (fontColor ?? Colors.white).withOpacity(0.9),
                )
              ],
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
          color: color ?? Colors.blue,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              color: Colors.deepPurple.withOpacity(0.3),
              blurStyle: BlurStyle.outer,
            )
          ]),
    );
  }
}
