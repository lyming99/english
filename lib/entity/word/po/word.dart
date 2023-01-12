import 'dart:convert';

import 'package:floor/floor.dart';
import 'package:flutter/cupertino.dart';

import '../vo/word.dart';

@Entity(tableName: "word")
class WordPO {
  @primaryKey
  int? id;
  String? book;

  //单词
  String? word;

  WordPO({
    this.id,
    this.word,
    this.book,
  });
}

@Entity(tableName: "word_status")
class WordStatusPO {
  @primaryKey
  int? id;
  String? word;

  //0:学习中 1:已完成 -1:删除
  int? status;

  //学习周期
  int? studyCycle;
  int? nextReviewTime;
  int? createTime;
  int? updateTime;

  WordStatusPO({
    this.id,
    this.word,
    this.status,
    this.studyCycle,
    this.nextReviewTime,
    this.createTime,
    this.updateTime,
  });
}

@Entity(tableName: "word_study_time_count")
class WordStudyTimeCountPO {
  @primaryKey
  int? id;
  int? startTime;
  int? endTime;
  String? word;
  int? studyCycle;
  int? playComplete;

  WordStudyTimeCountPO({
    this.id,
    this.startTime,
    this.endTime,
    this.word,
    this.studyCycle,
    this.playComplete,
  });
}

@Entity(tableName: "study_time_count")
class StudyTimeCountPO {
  @primaryKey
  int? id;
  int? startTime;
  int? endTime;

  StudyTimeCountPO({
    this.id,
    this.startTime,
    this.endTime,
  });
}
