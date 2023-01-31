import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:english/controller/study/wordList.dart';
import 'package:english/entity/word/vo/word.dart';
import 'package:english/service/word/word.dart';
import 'package:english/view/review/list.dart';
import 'package:english/widget/rotate_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

import '../../controller/study/study.dart';
import '../../util/theme.dart';
import '../word/word.dart';

class StudyPage extends GetView<StudyController> {
  Widget buildWordContent(BuildContext context) {
    return Stack(
      children: [
        if (controller.autoRotating)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: 30),
              width: 300,
              height: 300,
              child: Image.asset("assets/img/chicken.png"),
            ),
          ),
        SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: controller.autoRotating ? 30 : 10,
              vertical: controller.autoRotating ? 30 : 10,
            ),
            child: Obx(() {
              return WordView(
                word: controller.word.value,
                showDetail:
                    controller.autoRotating || !controller.thinking.value,
                cycle: controller.wordStatus.value?.studyCycle ?? 0,
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget buildWordView(BuildContext context) {
    return Stack(
      children: [
        Container(
          child: GestureDetector(
            onDoubleTap: () {
              controller.next();
            },
          ),
        ),
        if (controller.autoRotating)
          RotatingWidget(
            controller: RotatingWidgetsController(
              autoplayEnabled: controller.autoRotating,
            ),
            rotateZ: false,
            rotateX: false,
            rotateY: true,
            duration: Duration(milliseconds: 5),
            child: buildWordContent(context),
          ),
        if (!controller.autoRotating) buildWordContent(context),
        //PASS 按钮
        if (controller.autoPass.value == false)
          Align(
            alignment: Alignment.bottomCenter,
            child: Obx(() {
              if (controller.thinking.value == true ||
                  controller.playing.value == false) return Container();
              return Container(
                margin:
                    const EdgeInsets.only(bottom: 100.0, left: 50, right: 50),
                width: 100,
                height: 100,
                child: Ink(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: [
                      BoxShadow(
                        blurStyle: BlurStyle.outer,
                        blurRadius: 10,
                        color: Colors.green.withOpacity(0.2),
                      )
                    ],
                  ),
                  child: InkWell(
                      borderRadius: BorderRadius.circular(100),
                      onTap: controller.controlEnable.value
                          ? () {
                              controller.pass();
                            }
                          : null,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Icon(
                              Icons.check,
                              color: controller.thinking.value == false
                                  ? Colors.black12
                                  : Colors.black12,
                              size: 50,
                            ),
                            Text(
                              "PASS",
                              style: TextStyle(
                                color: Colors.black12,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
              );
            }),
          ),
        //Delete 按钮
        if (controller.autoRotating == false)
          Align(
            alignment: Alignment.topRight,
            child: Obx(() {
              return Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
                width: 36,
                height: 36,
                child: Ink(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: [
                      BoxShadow(
                        blurStyle: BlurStyle.outer,
                        blurRadius: 10,
                        color: Colors.green.withOpacity(0.2),
                      )
                    ],
                  ),
                  child: InkWell(
                      borderRadius: BorderRadius.circular(100),
                      onTap: controller.controlEnable.value &&
                              controller.thinking.value == false
                          ? () {
                              //删除单词
                              controller.delete();
                            }
                          : null,
                      child: Container(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.delete_outline_rounded,
                          color: controller.thinking.value == false
                              ? Colors.red
                              : Colors.red,
                          size: 24,
                        ),
                      )),
                ),
              );
            }),
          ),

        //PASS 数据
        Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "今日PASS: ",
                  style: TextStyle(
                    color: Colors.grey.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
                Obx(() {
                  return Text(
                    "${controller.dailyStudyCount}",
                    style: TextStyle(
                      color: Colors.green.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  );
                }),
                Text(
                  "    等待复习: ",
                  style: TextStyle(
                    color: Colors.grey.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
                Obx(() {
                  return Text(
                    "${controller.reviewCount.value}",
                    style: TextStyle(
                      color: Colors.redAccent.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  );
                }),
              ],
            ),
          ),
        ),

        //时长数据
        Align(
          alignment: Alignment.bottomRight,
          child: Container(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "时长: ",
                  style: TextStyle(
                    color: Colors.grey.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
                Obx(() {
                  return Text(
                    "${controller.studyTime.value}",
                    style: TextStyle(
                      color: Colors.grey.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildEndView(BuildContext context) {
    return Container(
      child: Center(
        child: Text("恭喜已经完成今日任务，请稍后进入复习～"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios,
            )),
        title: Text(
          "学习",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.transparent,
        ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.help_outline,
              )),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          return controller.word.value == null
              ? buildEndView(context)
              : buildWordView(context);
        }),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              blurStyle: BlurStyle.outer,
              blurRadius: 1,
              color: Colors.grey.withOpacity(0.2),
            )
          ],
        ),
        child: SafeArea(
          child: Container(
            height: 60,
            child: Obx(() {
              return Stack(
                children: [
                  if (controller.word.value != null)
                    Container(
                      alignment: Alignment.center,
                      child: Row(
                        // mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: InkWell(
                                onTap: () {
                                  controller.previous();
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  child: Icon(
                                    Icons.fast_rewind_rounded,
                                    size: 32,
                                    color: Colors.black87,
                                  ),
                                )),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: InkWell(
                                onTap:
                                    controller.playButtonEnable.value == false
                                        ? null
                                        : () {
                                            controller.togglePlay();
                                          },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  child: Icon(
                                    controller.playing.value
                                        ? Icons.pause_outlined
                                        : Icons.play_arrow_rounded,
                                    size: 32,
                                    color: Colors.black87,
                                  ),
                                )),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: InkWell(
                                onTap: () {
                                  //下一个
                                  controller.next();
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  child: Icon(
                                    Icons.fast_forward_rounded,
                                    size: 28,
                                    color: Colors.black87,
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: IconButton(
                          onPressed: () {
                            showOptions(context);
                          },
                          icon: Icon(
                            Icons.av_timer,
                            size: 32,
                          )),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: IconButton(
                          onPressed: () {
                            showWordListBottomSheet(context);
                          },
                          icon: Icon(
                            Icons.list,
                            size: 32,
                          )),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Future<void> showOptions(BuildContext context) async {
    var playing = controller.playing.value;
    if (playing) {
      controller.stopPlay();
    }
    var queueCount = controller.queueCount.value;
    var waitCount = controller.dailyWantCount.value;
    //设定：1 队列 2 思考间隔 3 学习间隔 4 日词汇量
    await showModalBottomSheet(
        context: context,
        // barrierColor: Colors.black.withOpacity(0.1),
        backgroundColor: Colors.transparent,
        builder: (context) {
          return buildOptionView(context);
        });
    if (queueCount != controller.queueCount.value ||
        waitCount != controller.dailyWantCount.value) {
      //重新取词
      var word = controller.word.value;
      await controller.fetchWords();
      if (word != null) {
        var words = controller.playingWords;
        for (var i = 0; i < words.length; i++) {
          var temp = words[i];
          if (word.word == temp.word) {
            controller.playingIndex = i;
            controller.word.value = word;
            controller.fetchWordStatus();
            break;
          }
        }
      } else {
        controller.startPlay();
      }
    }
    if (playing) {
      controller.startPlay();
    }
  }

  Widget buildOptionView(BuildContext context) {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurStyle: BlurStyle.outer,
            blurRadius: 10,
            color: Colors.green.withOpacity(0.1),
          )
        ],
      ),
      child: Center(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
              child: Text(
                "播放设置",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 20,
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: Material(
                  color: Colors.white,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        //每日学习
                        InkWell(
                          onTap: () {
                            showWordPicker(context);
                          },
                          child: Container(
                            padding: EdgeInsets.only(
                              top: 20,
                              bottom: 20,
                              right: 20,
                            ),
                            margin: EdgeInsets.only(
                              left: 20,
                            ),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey.withOpacity(0.1),
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    child: Row(
                                      children: [
                                        Text(
                                          "每日词汇量(个)",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                          ),
                                        ),
                                        // IconButton(
                                        //     splashRadius: 16,
                                        //     padding: EdgeInsets.symmetric(
                                        //       horizontal: 6,
                                        //     ),
                                        //     onPressed: () {},
                                        //     constraints: BoxConstraints(
                                        //       maxWidth: 40,
                                        //       maxHeight: 40,
                                        //     ),
                                        //     icon: Icon(
                                        //       Icons.help_outline,
                                        //       color: Colors.black54,
                                        //       size: 20,
                                        //     )),
                                      ],
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          child: Obx(
                                            () => Text(
                                              "${controller.dailyWantCount.value == -1 || controller.dailyWantCount.value == 1000000 ? "无限" : controller.dailyWantCount.value}",
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Icon(
                                            Icons.keyboard_arrow_right,
                                            color:
                                                Colors.black54.withOpacity(0.5),
                                            size: 24,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        //思考等待
                        InkWell(
                          onTap: () {
                            showThinkTimePicker(context);
                          },
                          child: Container(
                            padding: EdgeInsets.only(
                              top: 20,
                              bottom: 20,
                              right: 20,
                            ),
                            margin: EdgeInsets.only(
                              left: 20,
                            ),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey.withOpacity(0.1),
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    child: Row(
                                      children: [
                                        Text(
                                          "思考等待(秒)",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          child: Obx(
                                            () => Text(
                                              "${controller.thinkWaitTime.value}",
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Icon(
                                            Icons.keyboard_arrow_right,
                                            color:
                                                Colors.black54.withOpacity(0.5),
                                            size: 24,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        //播放等待
                        InkWell(
                          onTap: () {
                            showStudyTimePicker(context);
                          },
                          child: Container(
                            padding: EdgeInsets.only(
                              top: 20,
                              bottom: 20,
                              right: 20,
                            ),
                            margin: EdgeInsets.only(
                              left: 20,
                            ),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey.withOpacity(0.1),
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    child: Row(
                                      children: [
                                        Text(
                                          "阅读等待(秒)",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          child: Obx(
                                            () => Text(
                                              "${controller.readWaitTime.value}",
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Icon(
                                            Icons.keyboard_arrow_right,
                                            color:
                                                Colors.black54.withOpacity(0.5),
                                            size: 24,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        //循环队列
                        InkWell(
                          onTap: () {
                            showQueueCountPicker(context);
                          },
                          child: Container(
                            padding: EdgeInsets.only(
                              top: 20,
                              bottom: 20,
                              right: 20,
                            ),
                            margin: EdgeInsets.only(
                              left: 20,
                            ),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey.withOpacity(0.1),
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    children: const [
                                      Text(
                                        "循环队列(个)",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Obx(
                                        () => Text(
                                          "${controller.queueCount.value}",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Icon(
                                          Icons.keyboard_arrow_right,
                                          color:
                                              Colors.black54.withOpacity(0.5),
                                          size: 24,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        //自动 pass
                        InkWell(
                          onTap: () {
                            showAutoPassPicker(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.only(
                              top: 20,
                              bottom: 20,
                              right: 20,
                            ),
                            margin: const EdgeInsets.only(
                              left: 20,
                            ),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey.withOpacity(0.1),
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    children: const [
                                      Text(
                                        "自动PASS",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Obx(
                                        () {
                                          // 自动pass
                                          return Text(
                                            controller.autoPass.value
                                                ? "是"
                                                : "否",
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black54,
                                            ),
                                          );
                                        },
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Icon(
                                          Icons.keyboard_arrow_right,
                                          color:
                                              Colors.black54.withOpacity(0.5),
                                          size: 24,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showWordPicker(BuildContext context) {
    var countList = [
      10,
      20,
      30,
      40,
      50,
      60,
      70,
      80,
      90,
      100,
      150,
      200,
      300,
      400,
      500,
      600,
      700,
      800,
      900,
      1000,
      1000000
    ];
    var count = controller.dailyWantCount.value;
    var index = countList.indexOf(count);
    if (index == -1) {
      index = countList.length - 1;
    }
    BottomPicker(
      dismissable: true,
      selectedItemIndex: index,
      title: "请选择每日词汇量(个)",
      onSubmit: (index) {
        controller.dailyWantCount.value = countList[index];
      },
      items: [
        for (var value in countList)
          Text("${value == -1 || value > 1000 ? "无限" : value}")
      ],
      buttonText: "            确定            ",
      displayButtonIcon: false,
      displaySubmitButton: true,
      buttonSingleColor: Colors.deepPurple,
      buttonTextStyle: TextStyle(
        color: Colors.white,
      ),
      pickerTextStyle: TextStyle(
        height: 1.4,
        fontSize: 24,
        color: Colors.black,
      ),
      bottomPickerTheme: BottomPickerTheme.blue,
      titleStyle: TextStyle(
        height: 1.5,
        fontSize: 16,
      ),
      displayCloseIcon: false,
      itemExtent: 32,
      height: 400,
    ).show(context);
    // ScrollView
  }

  void showThinkTimePicker(BuildContext context) {
    BottomPicker(
      dismissable: true,
      selectedItemIndex: controller.thinkWaitTime.value,
      onSubmit: (index) {
        controller.thinkWaitTime.value = index;
      },
      title: "请选择思考等待(秒)",
      items: [
        for (var i = 0; i < 21; i++) Text("${i}"),
      ],
      buttonText: "            确定            ",
      displayButtonIcon: false,
      displaySubmitButton: true,
      buttonSingleColor: Colors.deepPurple,
      buttonTextStyle: TextStyle(
        color: Colors.white,
      ),
      pickerTextStyle: TextStyle(
        height: 1.4,
        fontSize: 24,
        color: Colors.black,
      ),
      bottomPickerTheme: BottomPickerTheme.blue,
      titleStyle: TextStyle(
        height: 1.5,
        fontSize: 16,
      ),
      displayCloseIcon: false,
      itemExtent: 32,
      height: 400,
    ).show(context);
  }

  void showStudyTimePicker(BuildContext context) {
    controller.dailyStudyCount;
    BottomPicker(
      dismissable: true,
      selectedItemIndex: controller.readWaitTime.value - 1,
      onSubmit: (index) {
        controller.readWaitTime.value = index + 1;
      },
      title: "请选择单词阅读等待(秒)",
      items: [
        for (var i = 0; i < 20; i++) Text("${i + 1}"),
      ],
      buttonText: "            确定            ",
      displayButtonIcon: false,
      displaySubmitButton: true,
      buttonSingleColor: Colors.deepPurple,
      buttonTextStyle: TextStyle(
        color: Colors.white,
      ),
      pickerTextStyle: TextStyle(
        height: 1.4,
        fontSize: 24,
        color: Colors.black,
      ),
      bottomPickerTheme: BottomPickerTheme.blue,
      titleStyle: TextStyle(
        height: 1.5,
        fontSize: 16,
      ),
      displayCloseIcon: false,
      itemExtent: 32,
      height: 400,
    ).show(context);
  }

  void showQueueCountPicker(BuildContext context) {
    BottomPicker(
      dismissable: true,
      selectedItemIndex: controller.queueCount.value - 1,
      onSubmit: (index) {
        controller.queueCount.value = index + 1;
      },
      title: "请选择单词循环队列词数(个)",
      items: [
        for (var i = 0; i < 20; i++) Text("${i + 1}"),
      ],
      buttonText: "            确定            ",
      displayButtonIcon: false,
      displaySubmitButton: true,
      buttonSingleColor: Colors.deepPurple,
      buttonTextStyle: TextStyle(
        color: Colors.white,
      ),
      pickerTextStyle: TextStyle(
        height: 1.4,
        fontSize: 24,
        color: Colors.black,
      ),
      bottomPickerTheme: BottomPickerTheme.blue,
      titleStyle: TextStyle(
        height: 1.5,
        fontSize: 16,
      ),
      displayCloseIcon: false,
      itemExtent: 32,
      height: 400,
    ).show(context);
  }

  void showAutoPassPicker(BuildContext context) {
    BottomPicker(
      dismissable: true,
      selectedItemIndex: controller.autoPass.value ? 0 : 1,
      onSubmit: (index) {
        controller.autoPass.value = index == 0;
      },
      title: "请选择是否自动PASS",
      items: [
        Text("是"),
        Text("否"),
      ],
      buttonText: "            确定            ",
      displayButtonIcon: false,
      displaySubmitButton: true,
      buttonSingleColor: Colors.deepPurple,
      buttonTextStyle: TextStyle(
        color: Colors.white,
      ),
      pickerTextStyle: TextStyle(
        height: 1.4,
        fontSize: 24,
        color: Colors.black,
      ),
      bottomPickerTheme: BottomPickerTheme.blue,
      titleStyle: TextStyle(
        height: 1.5,
        fontSize: 16,
      ),
      displayCloseIcon: false,
      itemExtent: 32,
      height: 400,
    ).show(context);
  }

  /// 下方弹出单词列表
  Future<void> showWordListBottomSheet(BuildContext context) async {
    var playing = controller.playing.value;
    if (playing) {
      controller.stopPlay();
    }
    Get.put(WordListController());
    await showMaterialModalBottomSheet(
        context: context,
        expand: true,
        bounce: false,
        closeProgressThreshold: 0.95,
        useRootNavigator: true,
        backgroundColor: Colors.transparent,
        duration: const Duration(
          milliseconds: 300,
        ),
        builder: (context) {
          return buildWordListView(context);
        });

    Get.delete<WordListController>();

    if (playing) {
      controller.startPlay();
    }
  }

  Widget buildWordListView(BuildContext context) {
    return WordListView();
  }
}

class WordListView extends GetView<WordListController> {
  WordListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: Container(
            height: MediaQuery.of(context).size.height / 5,
          ),
          onTap: () {
            Get.back();
          },
        ),
        Expanded(
          child: Material(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: Column(
              children: [
                Container(
                  height: 50,
                  child: Stack(
                    children: [
                      Align(
                          alignment: Alignment.center,
                          child: Obx(() => Center(
                                child: Text(
                                  controller.title.value,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ))),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          child: IconButton(
                            onPressed: () {
                              Get.back();
                            },
                            icon: const Icon(Icons.close),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      PageView.builder(
                          itemCount: 4,
                          controller: controller.pageController,
                          onPageChanged: (index) {
                            controller.onPageChanged(index);
                          },
                          itemBuilder: (context, index) {
                            //1.播放列表
                            //2.已学习
                            //3.熟词(已删除)
                            //4.全部
                            if (index == 0) {
                              return buildPlayList(context);
                            }
                            if (index == 1) {
                              return buildPassList(context);
                            }
                            if (index == 2) {
                              return buildDeleteList(context);
                            }
                            if (index == 3) {
                              return buildAllList(context);
                            }
                            return ListView.builder(
                              itemCount: 100,
                              shrinkWrap: true,
                              padding: const EdgeInsets.only(bottom: 50),
                              itemBuilder: (ctx, index) {
                                return const ListTile(
                                  title: Text("bug"),
                                );
                              },
                              physics: const BouncingScrollPhysics(),
                            );
                          }),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Obx(
                          () => Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              for (var i = 0; i < 4; i++)
                                Container(
                                  width: 10,
                                  height: 10,
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 5,
                                    vertical: 30,
                                  ),
                                  decoration: controller.pageIndex.value == i
                                      ? BoxDecoration(
                                          color: Colors.grey.withOpacity(0.8),
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        )
                                      : BoxDecoration(
                                          border: Border.all(
                                              color:
                                                  Colors.grey.withOpacity(0.8)),
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  late RxList<WordVO> playingWords;

  Widget buildPlayList(BuildContext context) {
    StudyController studyController = Get.find();
    playingWords = studyController.playingWords.obs;
    return Obx(() {
      return ListView.builder(
        itemCount: playingWords.length,
        shrinkWrap: true,
        padding: const EdgeInsets.only(bottom: 50),
        itemBuilder: (ctx, index) {
          var word = playingWords[index];
          return buildWordTile(context, word,
              wordStatusUpdateCallback: () async {
            reFetchWordList(word: word);
          });
        },
        physics: const BouncingScrollPhysics(),
      );
    });
  }

  Widget buildPassList(BuildContext context) {
    return Obx(() {
      return ListView.builder(
        itemCount: controller.passList.value.length,
        shrinkWrap: true,
        padding: EdgeInsets.only(bottom: 50),
        itemBuilder: (ctx, index) {
          var word = controller.getWordVO(controller.passList.value[index]);
          return buildWordTile(context, word, wordStatusUpdateCallback: () {
            reFetchWordList(word: word);
          });
        },
        physics: BouncingScrollPhysics(),
      );
    });
  }

  Widget buildDeleteList(BuildContext context) {
    return Obx(() {
      return ListView.builder(
        itemCount: controller.deleteList.value.length,
        shrinkWrap: true,
        padding: const EdgeInsets.only(bottom: 50),
        itemBuilder: (ctx, index) {
          var word = controller.getWordVO(controller.deleteList.value[index]);
          return buildWordTile(context, word, wordStatusUpdateCallback: () {
            reFetchWordList(word: word);
          });
        },
        physics: const BouncingScrollPhysics(),
      );
    });
  }

  Widget buildWordTile(BuildContext context, WordVO? word,
      {VoidCallback? wordStatusUpdateCallback}) {
    return ListTile(
      title: Text(word?.word ?? ""),
      subtitle: Text(
        word?.means?.map((e) => e.toString()).join("\n") ?? "",
        style: const TextStyle(
          color: Colors.black54,
        ),
      ),
      trailing: IconButton(
          onPressed: () async {
            //显示bottom菜单：删除/恢复
            if (word == null) return;
            //读取单词状态：熟词？
            await controller.getDeleteStatus(word);
            var isDelete = word.isDelete.obs;
            await showModalBottomSheet(
                context: context,
                // barrierColor: Colors.black.withOpacity(0.1),
                backgroundColor: Colors.transparent,
                builder: (context) {
                  return Container(
                      height: MediaQuery.of(context).size.height * 4 / 5,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 50,
                            decoration: const BoxDecoration(
                                // border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                                ),
                            child: Stack(
                              children: [
                                const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 20.0),
                                      child: Text(
                                        "单词详情",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    )),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    margin: EdgeInsets.only(right: 10),
                                    child: IconButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      icon: Icon(Icons.close),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                              child: SingleChildScrollView(
                                  child: WordView(
                            word: word,
                          ))),
                          //删除恢复按钮
                          Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                            child: Obx(() {
                              return Row(
                                children: [
                                  Expanded(
                                    child: TextButton(
                                      onPressed: isDelete.value == true
                                          ? () async {
                                              //重新学习：从删除数据库恢复单词
                                              await controller
                                                  .restoreWord(word);
                                              isDelete.value =
                                                  word.isDelete ?? false;
                                            }
                                          : null,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Icon(Icons
                                              .settings_backup_restore_outlined),
                                          Text("重新学习"),
                                        ],
                                      ),
                                      style: ButtonStyle(
                                        foregroundColor:
                                            MaterialStateProperty.all(
                                                isDelete.value == false ||
                                                        isDelete.value == null
                                                    ? Colors.grey
                                                    : Colors.black),
                                        padding: MaterialStateProperty.all(
                                            const EdgeInsets.symmetric(
                                          vertical: 10,
                                          horizontal: 20,
                                        )),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: TextButton(
                                      onPressed: isDelete.value == true
                                          ? null
                                          : () async {
                                              //删除单词：设为熟词
                                              await controller.deleteWord(word);
                                              isDelete.value =
                                                  word.isDelete ?? false;
                                            },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Icon(Icons.delete_outlined),
                                          Text("设为熟词"),
                                        ],
                                      ),
                                      style: ButtonStyle(
                                        foregroundColor:
                                            MaterialStateProperty.all(
                                                isDelete.value == true
                                                    ? Colors.grey
                                                    : Colors.red.shade400),
                                        padding: MaterialStateProperty.all(
                                            const EdgeInsets.symmetric(
                                          vertical: 10,
                                          horizontal: 20,
                                        )),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ),
                        ],
                      ));
                });
            //刷新列表
            wordStatusUpdateCallback?.call();
          },
          icon: const Icon(
            Icons.more_horiz_outlined,
          )),
    );
  }

  Widget buildAllList(BuildContext context) {
    return Obx(() {
      var wordFilterList = controller.allList.value
          .where((element) => element
              .toLowerCase()
              .contains(controller.wordSearchText.toLowerCase()))
          .toList();
      return Column(
        children: [
          TextField(
            onChanged: (text) {
              controller.wordSearchText.value = text;
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: wordFilterList.length,
              shrinkWrap: true,
              padding: const EdgeInsets.only(bottom: 50),
              itemBuilder: (ctx, index) {
                /// 1、点击单词显示详情：对话框？下拉？
                /// 2、点击菜单按钮，显示下拉删除单词、恢复单词按钮
                /// 3、单词释义显示
                var word = controller.getWordVO(wordFilterList[index]);
                return buildWordTile(context, word,
                    wordStatusUpdateCallback: () {
                  reFetchWordList(word: word);
                });
              },
              physics: const BouncingScrollPhysics(),
            ),
          ),
        ],
      );
    });
  }

  void reFetchWordList({
    WordVO? word,
  }) async {
    await controller.fetchBookPassWordList();
    await controller.fetchBookDeleteWordList();
    if (word != null && word.isDelete == true) {
      StudyController studyController = Get.find();
      await studyController.deleteByWord(word.word);
      playingWords.value = studyController.playingWords;
    }
  }
}
