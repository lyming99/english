import 'dart:math';

import 'package:english/dao/word/word.dart';
import 'package:english/entity/record/po/record.dart';
import 'package:english/entity/word/vo/word.dart';
import 'package:english/service/app/app.dart';
import 'package:get/get.dart';

import '../../entity/word/po/word.dart';
import '../../entity/word/vo/section.dart';
import '../../util/time.dart';

///1.取词 ok
///2.
class StudyService {
  AppService appService = Get.find();
  WordDao wordDao = Get.find();

  Future<List<WordVO>> fetchStudyQueueWords(int studyQueueMaxCount) async {
    var studying = await wordDao.queryStudyingWords(studyQueueMaxCount);
    //如果长度不够，则查询需要复习的
    if (studying.length < studyQueueMaxCount) {
      var count = studyQueueMaxCount - studying.length;
      var reviews = await wordDao.queryNeedReviewWords(min(5, count));
      studying.addAll(reviews);
      for (var word in reviews) {
        if (word.word == null) {
          continue;
        }
        var status = await wordDao.queryWordStatus(word.word!);
        if (status != null) {
          status.status = 0;
          status.updateTime = DateTime.now().millisecondsSinceEpoch;
          await wordDao.updateStatus(status);
        }
      }
    }
    //如果长度还是不够，这查询新词
    var studyCount =
        await wordDao.queryDailyStudyCount(appService.bookId) ?? 0;
    var dailyWantCount=appService.dailyWantCount;
    if(dailyWantCount==-1) {
      dailyWantCount = 1000000;
    }
    if (studyCount < dailyWantCount) {
      if (studying.length < studyQueueMaxCount) {
        var count = studyQueueMaxCount - studying.length;
        var countMax = dailyWantCount - studyCount;
        count = min(countMax, count);
        var studyWords =
            await wordDao.queryNotStudyWords(appService.bookId, count);
        studying.addAll(studyWords);
        for (var word in studyWords) {
          wordDao.createWordStatus(WordStatusPO(
            word: word.word,
            status: 0,
            studyCycle: 0,
            nextReviewTime: 0,
            createTime: DateTime.now().millisecondsSinceEpoch,
            updateTime: DateTime.now().millisecondsSinceEpoch,
          ));
        }
      }
    }
    return studying
        .map((e) {
          return toWord(e)!;
        })
        .toList()
        .sublist(0, min(studying.length, studyQueueMaxCount));
  }

  WordVO? toWord(WordPO po) {
    var word = appService.getWord(po.word);
    if (word != null) {
      return WordVO(
        wordId: po.word,
        word: word.word,
        usaVoice: word.usVoice,
        ukVoice: word.ukVoice,
        means: word.means?.split("\n"),
        sentence: () {
          var len = word.sentences?.length ?? 0;
          if (len > 0) {
            return word.sentences?[0].sentence;
          }
        }(),
        sentenceMeans: () {
          var len = word.sentences?.length ?? 0;
          if (len > 0) {
            return word.sentences?[0].sentenceCn;
          }
        }(),
      );
    }
    return null;
  }

  Future<WordVO?> fetchNextWord() async {
    //查询复习词
    var reviews = await wordDao.queryNeedReviewWords(1);
    for (var word in reviews) {
      if (word.word == null) {
        continue;
      }
      var status = await wordDao.queryWordStatus(word.word!);
      if (status != null) {
        status.status = 0;
        status.updateTime = DateTime.now().millisecondsSinceEpoch;
        await wordDao.updateStatus(status);
      }
      return toWord(word)!;
    }
    //查询新词
    //判断
    var studyCount =
        await wordDao.queryDailyStudyCount(appService.bookId) ?? 0;
    if (studyCount < appService.dailyWantCount) {
      var studyWords = await wordDao.queryNotStudyWords(appService.bookId, 1);
      for (var word in studyWords) {
        wordDao.createWordStatus(WordStatusPO(
          word: word.word,
          status: 0,
          studyCycle: 0,
          nextReviewTime: 0,
          createTime: DateTime.now().millisecondsSinceEpoch,
          updateTime: DateTime.now().millisecondsSinceEpoch,
        ));
        return toWord(word)!;
      }
    }
    return null;
  }

  Future<void> pass(String word) async {
    var status = await wordDao.queryWordStatus(word);
    if (status != null) {
      //将当前单词状态设置为1，周期+1，计算下次复习时间
      status.status = 1;
      var cycle = status.studyCycle ?? 0;
      var timeSpan =
      appService.reviewTimes[min(cycle, appService.reviewTimes.length - 1)];
      status.studyCycle = cycle + 1;
      var currentTime = DateTime.now().millisecondsSinceEpoch;
      status.nextReviewTime = currentTime + timeSpan;
      status.updateTime = currentTime;
      await wordDao.updateStatus(status);
    }
  }
  Future<void> delete(String word) async {
    var status = await wordDao.queryWordStatus(word);
    if (status != null) {
      //将当前单词状态设置为-1(删除)
      status.status = -1;
      var currentTime = DateTime.now().millisecondsSinceEpoch;
      status.updateTime = currentTime;
      await wordDao.updateStatus(status);
    }
  }

  ///playComplete:是否正常播放结束
  Future<void> addWordStudyRecord(int startTime, int endTime, bool playComplete,
      WordStatusPO status) async {
    wordDao.addWordStudyTimeRecord(WordStudyTimeCountPO(
      word: status.word,
      startTime: startTime,
      endTime: endTime,
      studyCycle: status.studyCycle,
      playComplete: playComplete ? 1 : 0,
    ));
  }

  Future<void> addStudyRecord(int startTime, int endTime) async {
    wordDao.addStudyTimeRecord(StudyTimeCountPO(
      startTime: startTime,
      endTime: endTime,
    ));
  }
}
