import 'package:english/dao/word/word.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'dart:async';

import '../entity/word/po/word.dart';

part 'floor.g.dart';

@Database(
  version: 1,
  entities: [
    WordPO,
    WordStatusPO,
    StudyTimeCountPO,
    WordStudyTimeCountPO,
  ],
)
abstract class AppDatabase extends FloorDatabase {
  WordDao get wordDao;
}
