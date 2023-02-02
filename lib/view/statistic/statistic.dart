import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:dotted_line/dotted_line.dart';

import '../../controller/statistic/statistic.dart';

class StatisticPage extends GetView<StatisticController> {
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
          "学习统计(正在开发中。。。)",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.transparent,
        ),
        backgroundColor: Colors.white,
        shadowColor: Colors.grey.shade50,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.help_outline,
              )),
        ],
      ),
      body: SingleChildScrollView(
        child: Obx(() {
          return Column(
            children: [
              //数量总览
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                child: Text(
                  "数据总览",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),

              /// todo 需要通过宫格视图自动换行
              Row(
                children: [
                  //总耗时
                  Expanded(
                    child: Container(
                      child: Obx(() {
                        return buildCountWidget(
                          name: "总耗时",
                          value: "9999",
                          checked: controller.selectItem.value ==
                              StatisticItem.useTime,
                          clickCallback: () {
                            controller.selectItem.value = StatisticItem.useTime;
                          },
                        );
                      }),
                    ),
                  ),

                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: Obx(() {
                        return buildCountWidget(
                          name: "PASS",
                          value: "9999",
                          checked: controller.selectItem.value ==
                              StatisticItem.passCount,
                          clickCallback: () {
                            controller.selectItem.value =
                                StatisticItem.passCount;
                          },
                        );
                      }),
                    ),
                  ),

                  Expanded(
                    child: Container(
                      child: Obx(() {
                        return buildCountWidget(
                          name: "复习",
                          value: "9999",
                          checked: controller.selectItem.value ==
                              StatisticItem.reviewCount,
                          clickCallback: () {
                            controller.selectItem.value =
                                StatisticItem.reviewCount;
                          },
                        );
                      }),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  //总耗时
                  Expanded(
                    child: Container(
                      child: Obx(() {
                        return buildCountWidget(
                          name: "学习速度",
                          value: "9999",
                          checked: controller.selectItem.value ==
                              StatisticItem.studySpeed,
                          clickCallback: () {
                            controller.selectItem.value =
                                StatisticItem.studySpeed;
                          },
                        );
                      }),
                    ),
                  ),
                  //总学习
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 10,
                      ),
                      child: Obx(() {
                        return buildCountWidget(
                          name: "平均耗时",
                          value: "9999",
                          checked: controller.selectItem.value ==
                              StatisticItem.useTimeAvg,
                          clickCallback: () {
                            controller.selectItem.value =
                                StatisticItem.useTimeAvg;
                          },
                        );
                      }),
                    ),
                  ),
                  //占位符¬
                  Expanded(
                    child: Container(),
                  ),
                ],
              ),
              //每日总耗时统计图
              if (controller.selectItem.value == StatisticItem.useTime)
                buildUseTimeStatisticView(context),
              //每日学习统计图
              if (controller.selectItem.value == StatisticItem.passCount)
                buildPassStatisticView(context),
              //每日复习统计图
              if (controller.selectItem.value == StatisticItem.reviewCount)
                buildReviewStatisticView(context),
              //每日学习速度统计图
              if (controller.selectItem.value == StatisticItem.studySpeed)
                buildStudySpeedStatisticView(context),
              //每日平均耗时(每个单词耗时)统计图
              if (controller.selectItem.value == StatisticItem.useTimeAvg)
                buildUseTimeAvgStatisticView(context),
            ],
          );
        }),
      ),
    );
  }

  Widget buildCountWidget(
      {String? name,
      String? value,
      bool? checked,
      VoidCallback? clickCallback}) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: SizedBox(
            width: 100,
            child: Material(
              color:
                  checked == true ? Colors.red.shade50.withOpacity(0.2) : null,
              borderRadius: BorderRadius.circular(4),
              child: InkWell(
                onTap: () {
                  clickCallback?.call();
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 8),
                      width: 80,
                      height: 4,
                      color: checked == true ? Colors.red.shade400 : null,
                    ),
                    Container(
                      height: 30,
                      alignment: Alignment.center,
                      child: Text(
                        "$name",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Container(
                      height: 40,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        "$value",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 总耗时/每日耗时统计图，单位：分钟
  /// 柱状图实现难点：1、左侧y轴数值动态分布
  Widget buildUseTimeStatisticView(BuildContext context) {
    // 2种实现方式：1、直接用Widget 2、通过CustomerPainter（复杂）
    var pillarWith = 10.0;
    var maxPillarViewHeight = 200.0;
    var layerHeight = maxPillarViewHeight / 5;
    var days = 7;
    var yXisTextHeight = 20.0;
    var yXisTextWidth = 60.0;
    //y axis：数值
    return Container(
      height: 300,
      // color: Colors.blue,
      child: Column(
        children: [
          Row(
            children: [
              //y轴
              SizedBox(
                width: yXisTextWidth,
                height: maxPillarViewHeight + yXisTextHeight,
                child: Stack(
                  children: [
                    for (var i = 0; i < 6; i++)
                      Positioned(
                        top: i * layerHeight,
                        right: 0,
                        child: Container(
                          height: layerHeight,
                          alignment: Alignment.topCenter,
                          margin: const EdgeInsets.only(right: 8),
                          child: Container(
                            height: yXisTextHeight,
                            alignment: Alignment.center,
                            child: Text(
                              "${(5 - i) * layerHeight}",
                              style: TextStyle(
                                  color: Colors.black.withOpacity(
                                    0.5,
                                  )),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              //柱子数据
              Expanded(
                child: LayoutBuilder(builder: (context, constraints) {
                  var pillarContainerWidth = constraints.maxWidth / days;
                  return Container(
                    // color: Colors.green,
                    height: maxPillarViewHeight,
                    child: Stack(
                      children: [
                        //虚线
                        for (var i = 0; i < 6; i++)
                          Positioned(
                            top: i * layerHeight,
                            child: Container(
                              height: layerHeight,
                              width: constraints.maxWidth,
                              alignment: Alignment.topCenter,
                              child: DottedLine(
                                dashColor: Colors.grey.withOpacity(0.2),
                              ),
                            ),
                          ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            color: Colors.grey.withOpacity(0.2),
                            height: 1.0,
                          ),
                        ),
                        //柱子
                        Container(
                          height: maxPillarViewHeight,
                          child: Row(
                            children: [
                              //柱子
                              for (var i = 0; i < days; i++)
                                Container(
                                  width: pillarContainerWidth,
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    color: Colors.red,
                                    width: pillarWith,
                                    height: maxPillarViewHeight,
                                  ),
                                )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
          //x轴
          Container(
            padding: EdgeInsets.only(left: yXisTextWidth),
            child: LayoutBuilder(builder: (context, constraints) {
              var pillarContainerWidth = constraints.maxWidth / days;
              return Container(
                child: Row(
                  children: [
                    //柱子
                    for (var i = 0; i < days; i++)
                      Container(
                        width: pillarContainerWidth,
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: yXisTextHeight,
                          child: Text(
                            "7-${i + 1}",
                            style: TextStyle(
                                color: Colors.black.withOpacity(
                              0.5,
                            )),
                          ),
                        ),
                      )
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  /// 学习数量/每日学习数量统计图
  Widget buildPassStatisticView(BuildContext context) {
    return Container(
      child: Text("学习数量"),
    );
  }

  /// 复习数量/每日复习数量统计图
  Widget buildReviewStatisticView(BuildContext context) {
    return Container(
      child: Text("复习数量"),
    );
  }

  /// 学习速度/每日学习速度统计图，单位：词/分
  Widget buildStudySpeedStatisticView(BuildContext context) {
    return Container(
      child: Text("学习速度"),
    );
  }

  /// 单词平均耗时/每日单词平均耗时统计图，单位：秒
  Widget buildUseTimeAvgStatisticView(BuildContext context) {
    return Container(
      child: Text("单词平均耗时"),
    );
  }
}
