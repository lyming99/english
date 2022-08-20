import 'package:english/dicts/reader.dart';
import 'package:flutter/material.dart';

class WordService {
  var bookNames = [
    "小学英语",
    "初中英语",
    "高中英语",
    "大学英语四级词汇",
    "大学英语六级词汇",
    "大学英语专业四级",
    "大学英语专业八级",
    "全国等级考试",
    "考研英语",
    "考博英语",
    "BEC词汇",
    "GMAT词汇",
    "GRE词汇",
    "托福词汇",
    "雅思词汇",
    "托业词汇",
    "SAT词汇",
    "ACT词汇",
    "MBA词汇",
  ];
  var bookInfo = {
    "小学英语": {
      "color":Color(0xFF2A5485),
      "fontColor":Colors.white,
      "title":"小学",
      "subTitle":"小学英语",
    },
    "初中英语":  {
      "color":Color(0xFF471DA9),
      "fontColor":Colors.white,
      "title":"初中",
      "subTitle":"初中英语",
    },
    "高中英语":  {
      "color":Color(0xFF137A52),
      "fontColor":Colors.white,
      "title":"高中",
      "subTitle":"高中英语",
    },
    "大学英语四级词汇":  {
      "color":Color(0xFF4E7C16),
      "fontColor":Colors.white,
      "title":"四级",
      "subTitle":"四级词汇",
    },
    "大学英语六级词汇":  {
      "color":Color(0xFF8F4D1F),
      "fontColor":Colors.white,
      "title":"六级",
      "subTitle":"六级词汇",
    },
    "大学英语专业四级":  {
      "color":Color(0xFF73143F),
      "fontColor":Colors.white,
      "title":"专四",
      "subTitle":"专业四级词汇" ,
    },
    "大学英语专业八级":  {
      "color":Color(0xFF611DA1),
      "fontColor":Colors.white,
      "title":"专八",
      "subTitle":"专业八级词汇",
    },
    "考博英语":  {
      "color":Color(0xFF6B802D),
      "fontColor":Colors.white,
      "title":"考博",
      "subTitle":"考博英语",
    },
    "考研英语":  {
      "color":Color(0xFFA2342A),
      "fontColor":Colors.white,
      "title":"考研",
      "subTitle":"考研英语",
    },
    "全国等级考试":  {
      "color":Color(0xFF88580F),
      "fontColor":Colors.white,
      "title":"等级考试",
      "subTitle":"全国等级考试",
    },
    "BEC词汇":  {
      "color":Color(0xFF750E58),
      "fontColor":Colors.white,
      "title":"BEC",
      "subTitle":"BEC词汇",
    },
    "GMAT词汇":  {
      "color":Color(0xFF387312),
      "fontColor":Colors.white,
      "title":"GMAT",
      "subTitle":"GMAT词汇",
    },
    "GRE词汇":  {
      "color":Color(0xFF0F4B8F),
      "fontColor":Colors.white,
      "title":"GRE",
      "subTitle":"GRE词汇",
    },
    "托福词汇":  {
      "color":Color(0xFF7C300E),
      "fontColor":Colors.white,
      "title":"托福",
      "subTitle":"托福词汇",
    },
    "雅思词汇":  {
      "color":Color(0xFF528D21),
      "fontColor":Colors.white,
      "title":"雅思",
      "subTitle":"雅思词汇",
    },
    "托业词汇":  {
      "color":Color(0xFF8C1136),
      "fontColor":Colors.white,
      "title":"托业",
      "subTitle":"托业词汇",
    },
    "SAT词汇":  {
      "color":Color(0xFF438535),
      "fontColor":Colors.white,
      "title":"SAT",
      "subTitle":"SAT词汇",
    },
    "ACT词汇":  {
      "color": Color(0xFF8A6515),
      "fontColor":Colors.white,
      "title":"ACT",
      "subTitle":"ACT词汇",
    },
    "MBA词汇":  {
      "color":Color(0xFFB61553),
      "fontColor":Colors.white,
      "title":"MBA",
      "subTitle":"MBA词汇",
    },
  };
  var wordMap = <String, Word>{};
  var bookMap = <String, Book>{};
  var loaded = false;

  Future<void> loadWords() async {
    if (loaded) return;
    loaded = true;
    var words = await readWordMap();
    var books = await readBookMap(words);
    for (var element in words.values) {
      var word = element.id;
      if (word != null) {
        wordMap[word] = element;
      }
    }
    for (var value in books) {
      var name = value.name;
      if (name != null) {
        bookMap[name] = value;
        print('$name');
      }
    }
  }

}
