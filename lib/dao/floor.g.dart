// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'floor.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  WordDao? _wordDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `word` (`id` INTEGER, `book` TEXT, `word` TEXT, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `word_status` (`id` INTEGER, `word` TEXT, `status` INTEGER, `studyCycle` INTEGER, `nextReviewTime` INTEGER, `createTime` INTEGER, `updateTime` INTEGER, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `study_time_count` (`id` INTEGER, `startTime` INTEGER, `endTime` INTEGER, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `word_study_time_count` (`id` INTEGER, `startTime` INTEGER, `endTime` INTEGER, `word` TEXT, `studyCycle` INTEGER, `playComplete` INTEGER, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  WordDao get wordDao {
    return _wordDaoInstance ??= _$WordDao(database, changeListener);
  }
}

class _$WordDao extends WordDao {
  _$WordDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _wordPOInsertionAdapter = InsertionAdapter(
            database,
            'word',
            (WordPO item) => <String, Object?>{
                  'id': item.id,
                  'book': item.book,
                  'word': item.word
                }),
        _wordStatusPOInsertionAdapter = InsertionAdapter(
            database,
            'word_status',
            (WordStatusPO item) => <String, Object?>{
                  'id': item.id,
                  'word': item.word,
                  'status': item.status,
                  'studyCycle': item.studyCycle,
                  'nextReviewTime': item.nextReviewTime,
                  'createTime': item.createTime,
                  'updateTime': item.updateTime
                }),
        _studyTimeCountPOInsertionAdapter = InsertionAdapter(
            database,
            'study_time_count',
            (StudyTimeCountPO item) => <String, Object?>{
                  'id': item.id,
                  'startTime': item.startTime,
                  'endTime': item.endTime
                }),
        _wordStudyTimeCountPOInsertionAdapter = InsertionAdapter(
            database,
            'word_study_time_count',
            (WordStudyTimeCountPO item) => <String, Object?>{
                  'id': item.id,
                  'startTime': item.startTime,
                  'endTime': item.endTime,
                  'word': item.word,
                  'studyCycle': item.studyCycle,
                  'playComplete': item.playComplete
                }),
        _wordStatusPOUpdateAdapter = UpdateAdapter(
            database,
            'word_status',
            ['id'],
            (WordStatusPO item) => <String, Object?>{
                  'id': item.id,
                  'word': item.word,
                  'status': item.status,
                  'studyCycle': item.studyCycle,
                  'nextReviewTime': item.nextReviewTime,
                  'createTime': item.createTime,
                  'updateTime': item.updateTime
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<WordPO> _wordPOInsertionAdapter;

  final InsertionAdapter<WordStatusPO> _wordStatusPOInsertionAdapter;

  final InsertionAdapter<StudyTimeCountPO> _studyTimeCountPOInsertionAdapter;

  final InsertionAdapter<WordStudyTimeCountPO>
      _wordStudyTimeCountPOInsertionAdapter;

  final UpdateAdapter<WordStatusPO> _wordStatusPOUpdateAdapter;

  @override
  Future<List<WordPO>> queryStudyingWords(int count) async {
    return _queryAdapter.queryList(
        'select word.* from  word_status status left join word word on word.word = status.word    where status.status = 0     group by word.word    limit ?1',
        mapper: (Map<String, Object?> row) => WordPO(id: row['id'] as int?, word: row['word'] as String?, book: row['book'] as String?),
        arguments: [count]);
  }

  @override
  Future<List<WordPO>> queryNotStudyWords(int book, int count) async {
    return _queryAdapter.queryList(
        'select word.* from  word word left join word_status status on word.word = status.word    where word.book=?1 and status.id is null    group by word.word    order by random()    limit ?2',
        mapper: (Map<String, Object?> row) => WordPO(id: row['id'] as int?, word: row['word'] as String?, book: row['book'] as String?),
        arguments: [book, count]);
  }

  @override
  Future<List<WordPO>> queryNeedReviewWords(int count) async {
    return _queryAdapter.queryList(
        'select word.* from  word word left join  word_status status  on word.word = status.word    where status.status = 1      and nextReviewTime<CAST((julianday(\'now\') - 2440587.5)*86400000 AS INTEGER)    group by word.word    limit ?1',
        mapper: (Map<String, Object?> row) => WordPO(id: row['id'] as int?, word: row['word'] as String?, book: row['book'] as String?),
        arguments: [count]);
  }

  @override
  Future<WordStatusPO?> queryWordStatus(String word) async {
    return _queryAdapter.query('select * from word_status where word=?1',
        mapper: (Map<String, Object?> row) => WordStatusPO(
            id: row['id'] as int?,
            word: row['word'] as String?,
            status: row['status'] as int?,
            studyCycle: row['studyCycle'] as int?,
            nextReviewTime: row['nextReviewTime'] as int?,
            createTime: row['createTime'] as int?,
            updateTime: row['updateTime'] as int?),
        arguments: [word]);
  }

  @override
  Future<List<WordStatusPO>> queryWordStatusList() async {
    return _queryAdapter.queryList('select * from word_status',
        mapper: (Map<String, Object?> row) => WordStatusPO(
            id: row['id'] as int?,
            word: row['word'] as String?,
            status: row['status'] as int?,
            studyCycle: row['studyCycle'] as int?,
            nextReviewTime: row['nextReviewTime'] as int?,
            createTime: row['createTime'] as int?,
            updateTime: row['updateTime'] as int?));
  }

  @override
  Future<int> addWord(WordPO wordPO) {
    return _wordPOInsertionAdapter.insertAndReturnId(
        wordPO, OnConflictStrategy.abort);
  }

  @override
  Future<int> createWordStatus(WordStatusPO status) {
    return _wordStatusPOInsertionAdapter.insertAndReturnId(
        status, OnConflictStrategy.abort);
  }

  @override
  Future<int> addStudyTimeRecord(StudyTimeCountPO po) {
    return _studyTimeCountPOInsertionAdapter.insertAndReturnId(
        po, OnConflictStrategy.abort);
  }

  @override
  Future<int> addWordStudyTimeRecord(WordStudyTimeCountPO po) {
    return _wordStudyTimeCountPOInsertionAdapter.insertAndReturnId(
        po, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateStatus(WordStatusPO status) {
    return _wordStatusPOUpdateAdapter.updateAndReturnChangedRows(
        status, OnConflictStrategy.abort);
  }
}
