import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../controller/home/home.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ));
    return Scaffold(
      body: buildStudyPage(context),
    );
  }

  Widget buildStudyPage(BuildContext context) {
    return Stack(
      children: [
        //背景
        Column(
          children: [
            Container(
              height: 300,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.only(bottomLeft: Radius.circular(50)),
                color: Colors.blueAccent,
              ),
              child: Container(
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurple.withOpacity(0.8),
                        blurStyle: BlurStyle.outer,
                        blurRadius: 10,
                      )
                    ],
                    borderRadius:
                        BorderRadius.only(bottomLeft: Radius.circular(50)),
                    gradient: LinearGradient(
                      colors: [
                        Colors.deepPurple.withOpacity(0.5),
                        Colors.deepPurple.withOpacity(1),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.bottomRight,
                    )),
                height: 300,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Image.asset(
                                "assets/img/home/book1.png",
                                width: 24,
                                height: 24,
                              ),
                              ClipRect(
                                child: Align(
                                  heightFactor: 0.9,
                                  alignment: Alignment.topCenter,
                                  child: Image.asset(
                                    "assets/img/home/cup.png",
                                    width: 48,
                                    height: 48,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 100,
                            height: 10,
                            color: Colors.orange,
                            margin: EdgeInsets.only(bottom: 50),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.only(bottom: 50, left: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              "assets/img/home/head.png",
                              width: 48,
                              height: 48,
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "欢迎使用晨晨单词~",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Obx(() {
                                    return Text(
                                      "${controller.username.value}",
                                      style: TextStyle(
                                        color: Colors.orange,
                                        fontSize: 16,
                                        height: 1.5,
                                      ),
                                    );
                                  })
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
            )
          ],
        ),
        //内容
        buildContent(context),
      ],
    );
  }

  Widget buildContent(BuildContext context) {
    return Column(
      children: [
        //书本
        buildBookCard(context),
        buildStatisticCard(context),
      ],
    );
  }

  Widget buildBookCard(BuildContext context) {
    return Container(
      height: 120,
      margin: const EdgeInsets.only(
        top: 250,
        left: 20,
        right: 20,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurple.withOpacity(0.1),
              blurStyle: BlurStyle.outer,
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          children: [
            Obx(() {
              return Container(
                height: 80,
                margin: EdgeInsets.only(left: 20,right: 10),
                child: FittedBox(
                  child: controller.bookIcon.value,
                ),
              );
            }),
            Expanded(
              child: Container(
                height: 80,
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Column(
                  children: [
                    //titile
                    Row(
                      children: [
                        Expanded(
                          child: Obx(() {
                            return Text(
                              controller.wordBook.value,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: Material(
                            borderRadius: BorderRadius.circular(100),
                            clipBehavior: Clip.antiAlias,
                            child: Ink(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: InkWell(
                                onTap: () {
                                  showSelectBookView(context);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 2),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(
                                        color: Colors.grey.withOpacity(0.2),
                                      )),
                                  child: Row(
                                    children: const [
                                      Icon(
                                        Icons.swap_horiz,
                                        size: 14,
                                        color: Colors.grey,
                                      ),
                                      Text(
                                        "切换",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    //进度
                    Container(
                      padding: const EdgeInsets.only(
                        top: 20,
                        right: 20,
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "学习进度",
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.black.withOpacity(0.2)),
                                ),
                              ),
                              Obx(() {
                                return Text(
                                  "${controller.progress.value}",
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.black.withOpacity(0.2)),
                                );
                              }),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            child: Stack(
                              children: [
                                Container(
                                  color: Colors.grey.withOpacity(0.2),
                                  height: 2,
                                ),
                                LayoutBuilder(builder: (context, cons) {
                                  return Obx(() {
                                    return Container(
                                      color: Colors.redAccent,
                                      height: 2,
                                      width: cons.maxWidth *
                                          controller.progressPercent.value,
                                    );
                                  });
                                }),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStatisticCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurple.withOpacity(0.1),
                  blurStyle: BlurStyle.outer,
                  blurRadius: 10,
                ),
              ],
            ),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 20,
                      bottom: 10,
                    ),
                    child: const Text(
                      "今日情况",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  //数据统计
                  Container(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 10,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //今日学习
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "今日PASS",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                                Container(
                                  height: 60,
                                  alignment: Alignment.center,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Obx(() {
                                    return Text(
                                      "${controller.dailyWordCount}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 32,
                                      ),
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                        ),
                        //等待复习
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              //等待复习按钮
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    "等待复习",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Container(
                                    height: 60,
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Obx(() {
                                      return Text(
                                        "${controller.reviewCount.value}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 32,
                                        ),
                                      );
                                    }),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "耗时(分钟)",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                                Container(
                                  height: 60,
                                  alignment: Alignment.center,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Obx(() {
                                    return SizedBox(
                                      child: AutoSizeText(
                                        controller.studyTime.value
                                            .toStringAsFixed(1),
                                        maxLines: 1,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 32,
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //学习按钮
                  Container(
                    margin: const EdgeInsets.only(top: 20, bottom: 20),
                    alignment: Alignment.center,
                    child: LayoutBuilder(builder: (context, cons) {
                      return ElevatedButton(
                        onPressed: () {
                          controller.toStudy();
                        },
                        child: const Text("开始学习"),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Colors.deepPurpleAccent),
                            minimumSize: MaterialStateProperty.all(
                                Size(cons.maxWidth - 40, 48)),
                            textStyle:
                                MaterialStateProperty.all(const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ))),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //切换单词书
  Future<void> showSelectBookView(BuildContext context) async {
    //简单化实现，后期可以修改为id
    var bookName = await Get.toNamed("/selectBook");
    if (bookName != null) {
      controller.selectBook(bookName);
    }
  }
}
