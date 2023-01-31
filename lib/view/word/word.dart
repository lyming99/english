import 'dart:math';

import 'package:english/entity/word/vo/word.dart';
import 'package:english/widget/max_width_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../util/audio.dart';
import '../../widget/sentence.dart';

class WordView extends StatelessWidget {
  WordVO? word;
  bool ukVoice;
  bool showDetail;
  int cycle;

  WordView({
    Key? key,
    this.word,
    this.ukVoice = true,
    this.showDetail = true,
    this.cycle = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //单词
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "${word?.word}",
                  style: const TextStyle(
                    fontSize: 32,
                    color: Colors.deepOrangeAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (cycle > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.5),
                      // border: Border.all(color: Colors.blueGrey),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      "复习$cycle",
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          //音标
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (ukVoice)
                  InkWell(
                    onTap: () {
                      playWordSound(word?.word, 1);
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.volume_down_outlined,
                            color: Colors.black54,
                          ),
                          const Text(
                            "英 ",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                          Column(
                            children: [
                              MaxWidthText(
                                text: "[${word?.ukVoice}]",
                                maxLines: 1,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                ),
                                maxWidth: 1000,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                if (!ukVoice)
                  InkWell(
                    onTap: () {
                      playWordSound(word?.word, 2);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.volume_down_outlined,
                            color: Colors.black54,
                          ),
                          const Text(
                            "美 ",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                          MaxWidthText(
                            text: "[${word?.usaVoice}]",
                            maxLines: 1,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                            maxWidth: 1000,
                          ),
                        ],
                      ),
                    ),
                  )
              ],
            ),
          ),
          //释义
          if (showDetail)
            LayoutBuilder(builder: (context, cons) {
              return Container(
                width: cons.maxWidth,
                margin: const EdgeInsets.only(top: 16),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 4,
                        blurStyle: BlurStyle.outer,
                        color: Colors.grey.withOpacity(0.2))
                  ],
                ),
                child: Text(
                  word?.means?.map((e) => e.toString()).join("\n") ?? "",
                  style: TextStyle(color: Colors.black54, fontSize: 16),
                ),
              );
            }),

          //例句
          if (showDetail)
            LayoutBuilder(builder: (context, cons) {
              return Container(
                margin: const EdgeInsets.only(top: 16),
                width: cons.maxWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        playSentenceSound(word?.sentence ?? "",
                            cacheName: word?.wordId ?? word?.word);
                      },
                      child: WordSentence(
                        sentence: word?.sentence,
                        // showVoice: true,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        top: 10,
                      ),
                      child: WordSentence(
                        sentence: word?.sentenceMeans,
                      ),
                    ),
                  ],
                ),
              );
            }),

          // 词根词缀
          // if (showDetail)
          //   Container(
          //     margin: EdgeInsets.only(top: 30),
          //     child: WordAffix(
          //       word: word,
          //     ),
          //   ),
        ],
      ),
    );
  }
}
