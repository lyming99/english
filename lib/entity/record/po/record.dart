import 'package:floor/floor.dart';
import 'package:flutter/cupertino.dart';

@Entity(tableName: "record")
class RecordPO {
  @primaryKey
  String? id;

  //word、section、unit
  String? type;
  String? book;
  int? number;
  int? time;
  int? startTime;
  int? endTime;
  int? recycle;
  bool? complete;

  RecordPO({
    this.id,
    this.type,
    this.book,
    this.number,
    this.time,
    this.recycle,
    this.complete,
    this.startTime,
    this.endTime,
  });
}

