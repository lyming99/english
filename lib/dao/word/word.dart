import 'package:english/entity/word/po/word.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart';

import '../../util/time.dart';

@dao
abstract class WordDao {
  DatabaseExecutor get database;

  QueryAdapter get queryAdapter {
    return QueryAdapter(database);
  }

  @insert
  Future<int?> addWord(WordPO wordPO);

  @Query('''
  select word.* from  word_status status left join word word on word.word = status.word
   where status.status = 0 
   group by word.word
   limit :count
  ''')
  Future<List<WordPO>> queryStudyingWords(int count);

  // @Query('''
  // select word.* from  word word left join word_status status on word.word = status.word
  //  where word.book=:book and status.id is null
  //  group by word.word
  //  order by word.id
  //  limit :count
  // ''')
  @Query('''
  select word.* from  word word left join word_status status on word.word = status.word
   where word.book=:book and status.id is null
   group by word.word
   order by random()
   limit :count
  ''')
  Future<List<WordPO>> queryNotStudyWords(int book, int count);

  @Query('''
  select word.* from  word word left join  word_status status  on word.word = status.word
   where status.status = 1 
    and nextReviewTime<CAST((julianday('now') - 2440587.5)*86400000 AS INTEGER)
   group by word.word
   limit :count
  ''')
  Future<List<WordPO>> queryNeedReviewWords(int count);

  @insert
  Future<int> createWordStatus(WordStatusPO status);

  @Query('''
  select * from word_status where word=:word
  ''')
  Future<WordStatusPO?> queryWordStatus(String word);

  @update
  Future<int> updateStatus(WordStatusPO status);

  @Query('''
  select * from word_status 
  ''')
  Future<List<WordStatusPO>> queryWordStatusList();

  Future<int?> queryWordCount(int wordBook) async {
    var count = await queryAdapter.query(
        'select count(0) as count from word where book=?1',
        mapper: (Map<String, Object?> row) => row['count'] as int?,
        arguments: [wordBook]);
    return count;
  }

  ///查询学习进度数量，包含删除的数量
  Future<int?> queryProgressWordCount(int wordBook) async {
    var count = await queryAdapter.query(
        '''select count(0) as count from  word_status status
        left join  word word  on status.word = word.word
         where word.book=?1 and (status.status=1 or (status.studyCycle>0) or status.status=-1)
        ''',
        mapper: (Map<String, Object?> row) => row['count'] as int?,
        arguments: [wordBook]);
    return count;
  }

  ///查询日常学习数量（进入周期一以上的单词，周期0删除不算，周期0删除代表本来就会的单词）
  Future<int?> queryDailyBookPassWordCount(int wordBook) async {
    var count = await queryAdapter.query(
        '''select count(0) as count from  word_status status
        left join  word word  on status.word = word.word
         where word.book=?1 and (status.status=1 or status.studyCycle>0)
         and createTime > ${getDayStartTime()}
        ''',
        mapper: (Map<String, Object?> row) => row['count'] as int?,
        arguments: [wordBook]);
    return count;
  }
  Future<List<String>> queryBookPassWord(int wordBook) async {
    var wordList = await queryAdapter.queryList(
        '''select word.word as word from  word_status status
        left join  word word  on status.word = word.word
         where word.book=?1 and (status.status=1 or status.studyCycle>0)
        ''',
        mapper: (Map<String, Object?> row) => row['word'] as String,
        arguments: [wordBook]);
    return wordList;
  }
  Future<List<String>> queryBookDeleteWord(int wordBook) async {
    var wordList = await queryAdapter.queryList(
        '''select word.word as word from  word_status status
        left join  word word  on status.word = word.word
         where word.book=?1 and status.status=-1
        ''',
        mapper: (Map<String, Object?> row) => row['word'] as String,
        arguments: [wordBook]);
    return wordList;
  }
  Future<List<String>> queryBookNotDeleteWord(int wordBook) async {
    var wordList = await queryAdapter.queryList(
        '''select word.word as word from  word_status status
        left join  word word  on status.word = word.word
         where word.book=?1 and status.status!=-1 or status.status is null
        ''',
        mapper: (Map<String, Object?> row) => row['word'] as String,
        arguments: [wordBook]);
    return wordList;
  }

  Future<int?> queryDailyPassWordCount() async {
    var count = await queryAdapter.query(
        '''select count(distinct word.word) as count from  word_status status
        left join  word word  on status.word = word.word
         where (status.status=1 or (status.studyCycle>0 and status.status!=-1))
         and createTime > ${getDayStartTime()}
        ''',
        mapper: (Map<String, Object?> row) => row['count'] as int?,);
    return count;
  }

  ///查询今日学习的数量，包括没有pass的，但不包括删除的
  Future<int?> queryDailyStudyCount(int wordBook) async {
    var count = await queryAdapter.query(
        '''select count(0) as count from  word_status status
        left join  word word  on status.word = word.word
         where word.book=?1 and createTime > ${getDayStartTime()} and status.status!=-1 and status.status is not null
        ''',
        mapper: (Map<String, Object?> row) => row['count'] as int?,
        arguments: [wordBook]);
    return count;
  }

  Future<int?> queryReviewWordCount() async {
    var count = await queryAdapter.query(
        '''
          select count(0) as count from word_status  
           where studyCycle>0 and nextReviewTime < ${DateTime.now().millisecondsSinceEpoch} and status!=-1
        ''',
        mapper: (Map<String, Object?> row) => row['count'] as int?,
        arguments: []);
    return count;
  }

  @insert
  Future<int> addStudyTimeRecord(StudyTimeCountPO po);

  @insert
  Future<int> addWordStudyTimeRecord(WordStudyTimeCountPO po);

  Future<int?> queryStudyTime() async {
    var count = await queryAdapter.query(
        '''
          select sum(endTime-startTime) as time from word_study_time_count  
           where startTime > ${getDayStartTime()}
        ''',
        mapper: (Map<String, Object?> row) => row['time'] as int?,
        arguments: []);
    return count;
  }

  Future<void> clearWord() async {
    return await queryAdapter.queryNoReturn("delete from word");
  }

  Future<void> addWords(List<WordPO> words) async {
    var batch = database.batch();
    for (var word in words) {
      batch.insert("word", {
        "word": word.word,
        "book": word.book,
      });
    }
    await batch.commit();
  }
}
