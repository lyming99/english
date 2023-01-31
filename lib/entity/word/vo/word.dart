class WordVO {
  String? wordId;

  //单词
  String? word;

  //美国发音
  String? usaVoice;

  //英国发音
  String? ukVoice;

  //翻译
  List<dynamic>? means;

  //例句
  String? sentence;

  //例句来源
  String? sentenceOrigin;

  //例句翻译
  String? sentenceMeans;

  String? helper;

  ///熟词(删除)
  bool? isDelete;

  WordVO({
    this.wordId,
    this.word,
    this.usaVoice,
    this.ukVoice,
    this.means,
    this.sentence,
    this.sentenceOrigin,
    this.sentenceMeans,
    this.helper,
  });
}
