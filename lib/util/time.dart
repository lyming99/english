int getDayStartTime() {
  var now = DateTime.now();
  return DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
}
