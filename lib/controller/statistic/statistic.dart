import 'package:get/get.dart';

class StatisticController {
  var studyCount = 99999.obs;

  var selectItem = StatisticItem.useTime.obs;
}

enum StatisticItem {
  /// 总耗时/每日耗时统计图，单位：分钟
  useTime,

  /// 学习数量/每日学习数量统计图
  passCount,

  /// 复习数量/每日复习数量统计图
  reviewCount,

  /// 学习速度/每日学习速度统计图，单位：词/分
  studySpeed,

  /// 单词平均耗时/每日单词平均耗时统计图，单位：秒
  useTimeAvg,
}
