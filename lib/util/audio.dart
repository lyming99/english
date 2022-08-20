import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

// FlutterSound _soundPlayer = FlutterSound()..thePlayer.openPlayer();
// AudioPlayer audioPlayer = AudioPlayer();
// void stopPlaySound() {
//   // _soundPlayer.thePlayer.stopPlayer();
//   player.stop();
// }

// Future<Duration?> playWordSound(String? word, int? type,
//     {TWhenFinished? whenFinished}) async {
//   // sound.thePlayer.openPlayer();
//   //https://dict.youdao.com/dictvoice?audio=%27Hello%2C+Paul%2C%27+they+chorused.&le=eng&type=2
//   //https://fanyi.baidu.com/gettts?lan=uk&text=users&spd=3&source=web
//   // _soundPlayer.thePlayer.setLogLevel(Level.nothing);
//   var url =
//       "https://fanyi.baidu.com/gettts?lan=${type == 1 ? "uk" : "en"}&text=$word&spd=3&source=web";
//   var tempDir = await getApplicationSupportDirectory();
//   Directory("${tempDir.path}/wordVoice").createSync();
//   var file = File("${tempDir.path}/wordVoice/$word$type");
//   await Dio().download(url, file.path);
//   if (_soundPlayer.thePlayer.isPlaying) {
//     _soundPlayer.thePlayer.stopPlayer();
//   }
//   return _soundPlayer.thePlayer
//       .startPlayer(fromURI: file.path, whenFinished: whenFinished);
//   // audioPlayer.play(DeviceFileSource(file.path));
// }

//
// Future<Duration?> playSentenceSound(String? sentence,
//     {int type = 2, String le = "eng", TWhenFinished? whenFinished}) async {
//   sentence = sentence ?? "";
//   sentence = Uri.encodeComponent(sentence);
//   // sound.thePlayer.openPlayer();
//   //https://dict.youdao.com/dictvoice?audio=%27Hello%2C+Paul%2C%27+they+chorused.&le=eng&type=2
//   _soundPlayer.thePlayer.setLogLevel(Level.nothing);
//   var url =
//       "https://dict.youdao.com/dictvoice?audio=${sentence}&type=$type&le=$le";
//   var tempDir = await getApplicationSupportDirectory();
//   Directory("${tempDir.path}/sentenceVoice").createSync();
//   var file = File("${tempDir.path}/sentenceVoice/$sentence$type");
//   await Dio().download(url, file.path);
//   await _soundPlayer.thePlayer
//       .startPlayer(fromURI: file.path, whenFinished: whenFinished);
//   // audioPlayer.play(DeviceFileSource(file.path));
// }
var player = AudioPlayer();

Future<Duration?> playWordSound(
  String? word,
  int? type,
) async {
  var url =
      "https://fanyi.baidu.com/gettts?lan=${type == 1 ? "uk" : "en"}&text=$word&spd=3&source=web";
  // var tempDir = await getApplicationSupportDirectory();
  // Directory("${tempDir.path}/wordVoice").createSync();
  // var file = File("${tempDir.path}/wordVoice/$word$type");
  // await Dio().download(url, file.path);
  // audioPlayer.play(DeviceFileSource(file.path));
  // var player = AudioPlayer();
  await player.play(UrlSource(url),volume: 1);
}

Future<Duration?> playSentenceSound(
  String? sentence, {
  int type = 2,
  String le = "eng",
}) async {
  sentence = sentence ?? "";
  sentence = Uri.encodeComponent(sentence);
  var url =
      "https://dict.youdao.com/dictvoice?audio=${sentence}&type=$type&le=$le";
  var tempDir = await getApplicationSupportDirectory();
  Directory("${tempDir.path}/sentenceVoice").createSync();
  var file = File("${tempDir.path}/sentenceVoice/$sentence$type");
  await Dio().download(url, file.path);
  // var player = AudioPlayer();
  player.play(DeviceFileSource(file.path));
}

void stopPlaySound() {
  // var player = AudioPlayer();
  player.stop();
}
