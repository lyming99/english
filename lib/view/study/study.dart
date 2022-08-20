import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:english/controller/study/wordList.dart';
import 'package:english/entity/word/vo/word.dart';
import 'package:english/view/review/list.dart';
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
  Widget buildWordView(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          child: Obx(() {
            return WordView(
              word: controller.word.value,
              showDetail: !controller.thinking.value,
              cycle: controller.wordStatus.value?.studyCycle ?? 0,
            );
          }),
        ),
        //PASS 按钮
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            child: Obx(() {
              return Container(
                margin: const EdgeInsets.only(bottom: 100.0),
                width: 100,
                height: 100,
                child: controller.thinking.value == true ||
                        controller.playing.value == false
                    ? null
                    : Ink(
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
                            onTap: controller.controlEnable.value &&
                                    controller.thinking.value == false
                                ? () {
                                    controller.pass();
                                  }
                                : null,
                            child: Container(
                              decoration: BoxDecoration(),
                              padding: EdgeInsets.all(10),
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
              // print('${controller.word.value}');
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
                            showWordList(context);
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
                                              "${controller.dailyWantCount.value == -1 ? "无限" : controller.dailyWantCount.value}",
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
                                  child: Container(
                                    child: Row(
                                      children: [
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
                                              "${controller.queueCount.value}",
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
                        //复习优先
                        // InkWell(
                        //   onTap: () {},
                        //   child: Container(
                        //     padding: EdgeInsets.only(
                        //       top: 20,
                        //       bottom: 20,
                        //       right: 20,
                        //     ),
                        //     margin: EdgeInsets.only(
                        //       left: 20,
                        //     ),
                        //     decoration: BoxDecoration(
                        //       border: Border(
                        //         bottom: BorderSide(
                        //           color: Colors.grey.withOpacity(0.1),
                        //           width: 1,
                        //         ),
                        //       ),
                        //     ),
                        //     child: Stack(
                        //       alignment: Alignment.center,
                        //       children: [
                        //         Align(
                        //           alignment: Alignment.centerLeft,
                        //           child: Container(
                        //             child: Row(
                        //               children: [
                        //                 Text(
                        //                   "复习优先",
                        //                   style: TextStyle(
                        //                     color: Colors.black,
                        //                     fontSize: 18,
                        //                   ),
                        //                 ),
                        //               ],
                        //             ),
                        //           ),
                        //         ),
                        //         Align(
                        //           alignment: Alignment.centerRight,
                        //           child: Container(
                        //             margin: EdgeInsets.only(
                        //               right: 20,
                        //             ),
                        //             child: Row(
                        //               mainAxisSize: MainAxisSize.min,
                        //               children: [
                        //                 Icon(
                        //                   Icons.check_box_outline_blank_rounded,
                        //                   color: Colors.grey,
                        //                 ),
                        //               ],
                        //             ),
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
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
      -1
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
        for (var value in countList) Text("${value == -1 ? "无限" : value}")
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
      selectedItemIndex: controller.thinkWaitTime.value - 1,
      onSubmit: (index) {
        controller.thinkWaitTime.value = index + 1;
      },
      title: "请选择思考等待(秒)",
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

  Future<void> showWordList(BuildContext context) async {
    var playing = controller.playing.value;
    if (playing) {
      controller.stopPlay();
    }
    Get.put(WordListController());
    await showSlidingBottomSheet(context, builder: (context) {
      return SlidingSheetDialog(
          elevation: 8,
          cornerRadius: 16,
          duration: Duration(milliseconds: 300),
          snapSpec: const SnapSpec(
            snap: true,
            snappings: [ 0.5, 1.0],
            positioning: SnapPositioning.relativeToSheetHeight,
          ),
          headerBuilder: (context,state){
            return Container(child: Text("header "),);
          },
          builder: (context, state) {
            var size = MediaQuery.of(context).size;
            var top = MediaQuery.of(context).padding.top + kToolbarHeight;

            return Container(
              height: size.height - top,
              width: size.width,
              child: buildWordListView(context),
            );
          });
    });
    // await showMaterialModalBottomSheet(
    //     context: context,
    //     expand: true,
    //     bounce: false,
    //     useRootNavigator: true,
    //     duration: const Duration(
    //       milliseconds: 300,
    //     ),
    //     builder: (context) {
    //       return buildWordListView(context);
    //     });

    Get.delete<WordListController>();

    // await const Duration(milliseconds: 310).delay();
    // setStatusBar(Get.context!);
    if (playing) {
      controller.startPlay();
    }
  }

  Widget buildWordListView(BuildContext context) {
    return const WordListView();
  }
}

class WordListView extends GetView<WordListController> {
  const WordListView({Key? key}) : super(key: key);

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
              Icons.keyboard_arrow_down_outlined,
              size: 32,
            )),
        title: Obx(
          () => Text(
            controller.title.value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: Colors.transparent),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          PageView.builder(
              itemCount: 3,
              controller: controller.pageController,
              onPageChanged: (index) {
                controller.onPageChanged(index);
              },
              itemBuilder: (context, index) {
                //1.播放列表
                //2.已学习
                //3.熟词(已删除)
                return ListView.builder(
                  itemCount: 100,
                  shrinkWrap: true,
                  padding: EdgeInsets.only(bottom: 50),
                  itemBuilder: (ctx, index) {
                    return ListTile(
                      title: Text("hello"),
                    );
                  },
                  physics: const NeverScrollableScrollPhysics(),
                );
              }),
          Align(
            alignment: Alignment.bottomCenter,
            child: Obx(
              () => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < 3; i++)
                    Container(
                      width: 10,
                      height: 10,
                      margin: EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 10,
                      ),
                      decoration: controller.pageIndex.value == i
                          ? BoxDecoration(
                              color: Colors.purple.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(100),
                            )
                          : BoxDecoration(
                              border: Border.all(
                                  color: Colors.purple.withOpacity(0.8)),
                              borderRadius: BorderRadius.circular(100),
                            ),
                    )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
