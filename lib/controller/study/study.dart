import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:english/dao/word/word.dart';
import 'package:english/entity/word/vo/word.dart';
import 'package:english/service/app/app.dart';
import 'package:english/service/study/study.dart';
import 'package:english/service/word/word.dart';
import 'package:english/view/review/list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wakelock/wakelock.dart';

import '../../entity/word/po/word.dart';
import '../../util/audio.dart';

typedef Future<void> PlayCallback(Player player);

class Player {
  bool _start = false;
  bool _playing = false;

  /// 显示时间,单位: 秒
  int showTime;
  int thinkTime;
  int startTime = DateTime.now().millisecondsSinceEpoch;
  int? stopTime;
  WordStatusPO? wordStatus;
  PlayCallback thinkStart;
  PlayCallback thinkEnd;
  PlayCallback showStart;
  PlayCallback showEnd;
  PlayCallback onEnd;
  bool playComplete = true;

  Player.create({
    required this.thinkStart,
    required this.thinkEnd,
    required this.showStart,
    required this.showEnd,
    required this.onEnd,
    this.showTime = 7,
    this.thinkTime = 3,
  }) {
    start();
  }

  void start() async {
    if (!_start) {
      //等待playing结束
      for (;;) {
        await const Duration(milliseconds: 100).delay();
        if (_playing == false) {
          break;
        }
      }
      _start = true;
      _playing = true;
      _loop();
    }
  }

  void stop() async {
    if (_start == false) {
      return;
    }
    stopTime = DateTime.now().millisecondsSinceEpoch;
    _start = false;
    for (;;) {
      await const Duration(milliseconds: 100).delay();
      if (_playing == false) {
        break;
      }
    }
  }

  void _loop() async {
    for (; _start;) {
      startTime = DateTime.now().millisecondsSinceEpoch;
      playComplete = true;
      if (_start) {
        await thinkStart(this);
      }
      if (_start) {
        await Duration(seconds: thinkTime).delay();
      }
      if (_start) {
        await thinkEnd(this);
      }
      if (_start) {
        await showStart(this);
      }
      if (_start) {
        await Duration(seconds: showTime).delay();
      }
      if (_start) {
        await showEnd(this);
      }
      if (!_start) {
        playComplete = false;
      }
      await onEnd(this);
    }
    _playing = false;
    _start = false;
  }
}

class _StudyTimeRecorder {
  int? startTime;
  int? endTime;
  StudyService service;

  void recordStart() {
    startTime = DateTime.now().millisecondsSinceEpoch;
  }

  void recordEnd() {
    if (startTime == null) {
      return;
    }
    endTime = DateTime.now().millisecondsSinceEpoch;
    //记录
    service.addStudyRecord(startTime!, endTime!);
    startTime = DateTime.now().millisecondsSinceEpoch;
  }

  _StudyTimeRecorder({
    this.startTime,
    this.endTime,
    required this.service,
  });
}

class StudyController extends GetxController with WidgetsBindingObserver {
  var word = Rx<WordVO?>(null);
  var dailyStudyCount = 0.obs;
  var reviewCount = 0.obs;
  var thinking = false.obs;
  var playing = false.obs;
  var controlEnable = true.obs;
  var playButtonEnable = true.obs;
  var playingIndex = 0;
  var playingWords = <WordVO>[];
  var timeRecord = _StudyTimeRecorder(service: Get.find());
  AppService appService = Get.find();
  StudyService studyService = StudyService();
  WordDao wordDao = Get.find();
  Player? player;
  var wordStatus = Rx<WordStatusPO?>(null);

  var studyTime = "0分钟".obs;

  //每日学习数量
  var dailyWantCount = 0.obs;

  //思考等待时间
  var thinkWaitTime = 1.obs;

  //阅读等待时间
  var readWaitTime = 7.obs;

  //循环队列数量
  var queueCount = 4.obs;

  var autoPass = false.obs;

  var playCount = <String, int>{};

  // 鸡块旋转。。。
  get autoRotating => false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        timeRecord.recordStart();
        break;
      case AppLifecycleState.paused:
        stopPlay();
        timeRecord.recordEnd();
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  void onInit() {
    super.onInit();
    _init();
    WidgetsBinding.instance?.addObserver(this);
    timeRecord.recordStart();
    //屏幕常亮
    // BlendMode.screen.i
    Wakelock.enable();
  }

  void _init() async {
    await fetchOptions();
    await fetchWords();
    await fetchCount();
    await startPlay();
  }

  Future<void> fetchOptions() async {
    appService.readOptions();
    dailyWantCount.value = appService.dailyWantCount;
    thinkWaitTime.value = appService.thinkWaitTime;
    readWaitTime.value = appService.readWaitTime;
    queueCount.value = appService.queueCount;
    autoPass.value = appService.autoPass;
    autoPass.listen((value) {
      appService.autoPass = value;
      appService.saveOptions();
    });
    dailyWantCount.listen((value) {
      appService.dailyWantCount = value;
      appService.saveOptions();
    });
    thinkWaitTime.listen((value) {
      appService.thinkWaitTime = value;
      appService.saveOptions();
    });
    readWaitTime.listen((value) {
      appService.readWaitTime = value;
      appService.saveOptions();
    });
    queueCount.listen((value) {
      appService.queueCount = value;
      appService.saveOptions();
    });
  }

  @override
  void onClose() {
    Wakelock.disable();
    timeRecord.recordEnd();
    WidgetsBinding.instance?.removeObserver(this);
    super.onClose();
    //结束后恢复亮主题
    stopPlay();
  }

  Future<void> fetchWords() async {
    var studyQueueMaxCount = appService.queueCount;
    var words = await studyService.fetchStudyQueueWords(studyQueueMaxCount);
    playingWords = words;
  }

  Future<void> fetchNextWord(int index) async {
    var word = await studyService.fetchNextWord();
    if (word != null) {
      playingWords[index] = word;
      playingIndex++;
      if (playingIndex > playingWords.length) {
        playingIndex = 0;
      }
    } else {
      playingWords.removeAt(index);
    }
  }

  Future<void> stopPlay() async {
    if (!playButtonEnable.value) {
      return;
    }
    thinking.value = false;
    playButtonEnable.value = false;
    player?.stop();
    playing.value = false;
    playButtonEnable.value = true;
  }

  Future<void> startPlay() async {
    if (!playButtonEnable.value) {
      return;
    }
    playButtonEnable.value = false;
    player?.stop();
    playing.value = true;
    player = Player.create(
      thinkTime: thinkWaitTime.value,
      showTime: readWaitTime.value,
      thinkStart: (Player player) async {
        thinking.value = true;
        wordStatus.value = null;
        //取词播放
        var index = playingIndex;
        var arr = playingWords;
        if (index >= arr.length) {
          playingIndex = index = 0;
        }
        if (index < arr.length) {
          word.value = arr[index];
          var wordId = arr[index].wordId;
          if (wordId != null) {
            player.wordStatus = await wordDao.queryWordStatus(wordId);
            wordStatus.value = player.wordStatus;
          }
          await playWordSound(word.value?.word, 1);
          // await time?.delay();
        } else {
          word.value = null;
          wordStatus.value = null;
          stopPlay();
        }
        //重设
        player.showTime = readWaitTime.value;
        //如果是复习状态，并且是自动pass状态，则减少showTime
        var cycle = player.wordStatus?.studyCycle;
        if (cycle != null && readWaitTime.value > 0) {
          if (cycle >= 1) {
            // 复习轮数越高，复习时间越短
            player.showTime = (readWaitTime.value * (1 - cycle / 8)).toInt();
            if (player.showTime < 1) {
              player.showTime = 1;
            }
          }
        }
      },
      thinkEnd: (Player player) async {
        thinking.value = false;
      },
      showStart: (Player player) async {
        //显示释义
      },
      showEnd: (Player player) async {
        if (appService.autoPass == true) {
          var key = player.wordStatus?.word ?? "";
          var wordPlayCount = playCount[key] ?? 0;
          wordPlayCount++;
          playCount[key] = wordPlayCount;
          var cycle = player.wordStatus?.studyCycle ?? 0;
          //循环次数减少
          if (wordPlayCount > 3 ||
              (cycle == 1 && wordPlayCount == 2) ||
              cycle > 1) {
            return;
          }
        }
        playingIndex++;
        if (playingIndex >= playingWords.length) {
          playingIndex = 0;
        }
        fetchCount();
      },
      onEnd: (Player player) async {
        //统计单词学习时间
        var startTime = player.startTime;
        var endTime = player.stopTime ?? DateTime.now().millisecondsSinceEpoch;
        var status = player.wordStatus;
        if (status != null) {
          studyService.addWordStudyRecord(
              startTime, endTime, player.playComplete, status);
        }
        if (appService.autoPass == true) {
          var key = player.wordStatus?.word ?? "";
          var wordPlayCount = playCount[key] ?? 0;
          var cycle = player.wordStatus?.studyCycle ?? 0;
          if (wordPlayCount > 3 ||
              (cycle == 1 && wordPlayCount == 2) ||
              cycle > 1) {
            playCount[key] = 0;
            pass();
          }
        }
      },
    );

    playButtonEnable.value = true;
  }

  void next() async {
    if (!controlEnable.value) {
      return;
    }
    controlEnable.value = false;
    await stopPlay();
    playingIndex++;
    if (playingIndex >= playingWords.length) {
      playingIndex = 0;
    }
    await startPlay();
    await fetchCount();
    controlEnable.value = true;
  }

  void previous() async {
    if (!controlEnable.value) {
      return;
    }
    controlEnable.value = false;
    await stopPlay();
    playingIndex--;
    if (playingIndex < 0) {
      playingIndex = max(playingWords.length - 1, 0);
    }
    await startPlay();
    await fetchCount();
    controlEnable.value = true;
  }

  void pass() async {
    if (!controlEnable.value) {
      return;
    }
    controlEnable.value = false;
    await stopPlay();
    var word = this.word.value?.wordId;
    if (word != null) {
      await studyService.pass(word);
    }
    await fetchNextWord(playingIndex);
    await startPlay();
    await fetchCount();
    controlEnable.value = true;
  }

  void delete() async {
    if (!controlEnable.value) {
      return;
    }
    controlEnable.value = false;
    await stopPlay();
    var word = this.word.value?.wordId;
    if (word != null) {
      await studyService.delete(word);
    }
    await fetchNextWord(playingIndex);
    await startPlay();
    await fetchCount();
    controlEnable.value = true;
  }

  /// 从播放列表删除单词
  Future<void> deleteByWord(String? word) async {
    var wordIndex = playingWords.indexWhere((element) => element.word == word);
    if (wordIndex == -1) {
      return;
    }
    await fetchNextWord(wordIndex);
    await fetchCount();
  }

  void togglePlay() async {
    if (playing.value) {
      await stopPlay();
    } else {
      await startPlay();
    }
  }

  Future<void> fetchCount() async {
    var dailyCount = await wordDao.queryDailyPassWordCount();
    dailyStudyCount.value = dailyCount ?? 0;
    var reviewCount = await wordDao.queryReviewWordCount();
    this.reviewCount.value = reviewCount ?? 0;

    var time = (await wordDao.queryStudyTime()) ?? 0;
    var use = (time / 1000 / 60).toStringAsFixed(1);
    studyTime.value = use + " 分钟";
  }

  void fetchWordStatus() async {
    var word = this.word.value;
    if (word != null) {
      wordStatus.value = await wordDao.queryWordStatus(word.wordId ?? "");
    }
  }
}
