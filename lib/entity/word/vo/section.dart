import 'package:english/entity/word/po/word.dart';
import 'package:english/entity/word/vo/word.dart';

class SectionVO {
  int section;
  List<WordVO> wordList;
  List<WordPO> words;
  int studyIndex;
  bool review;

  SectionVO({
    required this.section,
    required this.wordList,
    required this.studyIndex,
    required this.review,
    required this.words,
  });
}
