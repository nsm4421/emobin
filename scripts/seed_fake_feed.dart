// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';

class _SeedDatabase extends GeneratedDatabase {
  _SeedDatabase(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  Iterable<TableInfo<Table, Object?>> get allTables => const [];
}

class _SeedOptions {
  const _SeedOptions({
    required this.dbPath,
    required this.androidPackage,
    required this.adbPath,
    required this.count,
    required this.createdBy,
    required this.days,
    required this.clearExisting,
    required this.randomSeed,
  }) : help = false;

  const _SeedOptions.help()
    : dbPath = 'emobin.sqlite',
      androidPackage = null,
      adbPath = null,
      count = 30,
      createdBy = 'seed_bot',
      days = 14,
      clearExisting = false,
      randomSeed = null,
      help = true;

  final String dbPath;
  final String? androidPackage;
  final String? adbPath;
  final int count;
  final String createdBy;
  final int days;
  final bool clearExisting;
  final int? randomSeed;
  final bool help;
}

class _ResolvedSeedTarget {
  const _ResolvedSeedTarget({required this.file, this.temporaryDirectory});

  final File file;
  final Directory? temporaryDirectory;
}

Future<void> main(List<String> args) async {
  final options = _parseArgs(args);
  if (options.help) {
    stdout.writeln(_usage);
    return;
  }

  final adbExecutable = _resolveAdbExecutable(
    requestedPath: options.adbPath,
    requiresAdb: options.androidPackage != null,
  );

  final target = await _resolveSeedTarget(
    options,
    adbExecutable: adbExecutable,
  );
  final file = target.file;

  final db = _SeedDatabase(NativeDatabase(file));
  final random = Random(options.randomSeed);
  var inserted = 0;
  Object? total;

  try {
    try {
      await _ensureTable(db);
      await _ensureColumns(db);

      if (options.clearExisting) {
        await db.customStatement('DELETE FROM feed_entries;');
      }

      final now = DateTime.now().toUtc();

      await db.transaction(() async {
        for (var i = 0; i < options.count; i++) {
          final entry = _buildEntryPayload(
            random: random,
            now: now,
            index: i,
            createdBy: options.createdBy,
            days: options.days,
          );

          await db.customInsert(
            '''
INSERT INTO feed_entries (
  id,
  server_id,
  emotion,
  emotion_id,
  note,
  intensity,
  created_by,
  created_at,
  updated_at,
  deleted_at,
  is_draft,
  sync_status,
  last_synced_at
) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
''',
            variables: [
              Variable<String>(entry.id),
              Variable<String>(entry.serverId),
              Variable<String>(entry.emotion),
              Variable<String>(entry.emotionId),
              Variable<String>(entry.note),
              Variable<int>(entry.intensity),
              Variable<String>(entry.createdBy),
              Variable<DateTime>(entry.createdAt),
              Variable<DateTime>(entry.updatedAt),
              Variable<DateTime>(entry.deletedAt),
              Variable<bool>(entry.isDraft),
              Variable<String>(entry.syncStatus),
              Variable<DateTime>(entry.lastSyncedAt),
            ],
          );
          inserted += 1;
        }
      });

      final countRow = await db
          .customSelect('SELECT COUNT(*) AS count FROM feed_entries;')
          .getSingle();
      total = countRow.data['count'];
    } finally {
      await db.close();
    }

    if (options.androidPackage != null) {
      await _pushSeededDatabaseToAndroidApp(
        adbPath: adbExecutable!,
        packageName: options.androidPackage!,
        localDatabaseFile: file,
      );
    }

    stdout.writeln('Seed completed');
    if (options.androidPackage != null) {
      stdout.writeln('- target app: ${options.androidPackage}');
      stdout.writeln('- adb: $adbExecutable');
    }
    stdout.writeln('- local db: ${file.absolute.path}');
    stdout.writeln('- inserted: $inserted');
    stdout.writeln('- total rows: $total');
    if (options.androidPackage != null) {
      stdout.writeln('- synced to app DB: app_flutter/emobin.sqlite');
    }
  } finally {
    final tempDirectory = target.temporaryDirectory;
    if (tempDirectory != null && tempDirectory.existsSync()) {
      await tempDirectory.delete(recursive: true);
    }
  }
}

Future<_ResolvedSeedTarget> _resolveSeedTarget(
  _SeedOptions options, {
  required String? adbExecutable,
}) async {
  final packageName = options.androidPackage;
  if (packageName == null) {
    final file = File(options.dbPath);
    file.parent.createSync(recursive: true);
    return _ResolvedSeedTarget(file: file);
  }

  final tempDirectory = await Directory.systemTemp.createTemp('emobin_seed_');
  final file = File(
    '${tempDirectory.path}${Platform.pathSeparator}emobin.sqlite',
  );
  await _copyAndroidAppDatabaseIfExists(
    adbPath: adbExecutable!,
    packageName: packageName,
    destinationFile: file,
  );
  return _ResolvedSeedTarget(file: file, temporaryDirectory: tempDirectory);
}

Future<void> _copyAndroidAppDatabaseIfExists({
  required String adbPath,
  required String packageName,
  required File destinationFile,
}) async {
  final result = await Process.run(
    adbPath,
    ['exec-out', 'run-as', packageName, 'cat', 'app_flutter/emobin.sqlite'],
    stdoutEncoding: null,
    stderrEncoding: utf8,
  );

  final stderrText = (result.stderr as String).trim();
  final stdoutBytes = result.stdout is List<int>
      ? result.stdout as List<int>
      : const <int>[];

  if (result.exitCode == 0) {
    if (stdoutBytes.isNotEmpty) {
      await destinationFile.writeAsBytes(stdoutBytes, flush: true);
    }
    return;
  }

  if (_isMissingFileError(stderrText)) {
    return;
  }

  stderr.writeln('Failed to access app DB via adb.');
  stderr.writeln('- adb: $adbPath');
  stderr.writeln('- package: $packageName');
  if (stderrText.isNotEmpty) {
    stderr.writeln('- stderr: $stderrText');
  }
  final stdoutText = _decodeProcessStdout(result.stdout).trim();
  if (stdoutText.isNotEmpty) {
    stderr.writeln('- stdout: $stdoutText');
  }
  exit(2);
}

Future<void> _pushSeededDatabaseToAndroidApp({
  required String adbPath,
  required String packageName,
  required File localDatabaseFile,
}) async {
  await Process.run(adbPath, [
    'shell',
    'am',
    'force-stop',
    packageName,
  ], stderrEncoding: utf8);

  final remoteTempPath = '/data/local/tmp/emobin_seed.sqlite';
  final pushResult = await Process.run(adbPath, [
    'push',
    localDatabaseFile.path,
    remoteTempPath,
  ], stderrEncoding: utf8);
  if (pushResult.exitCode != 0) {
    stderr.writeln('Failed to push seeded DB to device temporary path.');
    stderr.writeln('- adb: $adbPath');
    stderr.writeln('- package: $packageName');
    final stderrText = (pushResult.stderr as String).trim();
    if (stderrText.isNotEmpty) {
      stderr.writeln('- stderr: $stderrText');
    }
    exit(2);
  }

  final copyResult = await Process.run(adbPath, [
    'shell',
    'run-as',
    packageName,
    'cp',
    remoteTempPath,
    'app_flutter/emobin.sqlite',
  ], stderrEncoding: utf8);
  await Process.run(adbPath, [
    'shell',
    'rm',
    '-f',
    remoteTempPath,
  ], stderrEncoding: utf8);
  if (copyResult.exitCode != 0) {
    stderr.writeln('Failed to move seeded DB into app storage.');
    stderr.writeln('- adb: $adbPath');
    stderr.writeln('- package: $packageName');
    final stderrText = (copyResult.stderr as String).trim();
    if (stderrText.isNotEmpty) {
      stderr.writeln('- stderr: $stderrText');
    }
    exit(2);
  }

  await Process.run(adbPath, [
    'shell',
    'run-as',
    packageName,
    'rm',
    '-f',
    'app_flutter/emobin.sqlite-wal',
    'app_flutter/emobin.sqlite-shm',
  ], stderrEncoding: utf8);
}

String _decodeProcessStdout(Object? value) {
  if (value == null) return '';
  if (value is String) return value;
  if (value is List<int>) {
    return utf8.decode(value, allowMalformed: true);
  }
  return value.toString();
}

bool _isMissingFileError(String message) {
  return message.contains('No such file') ||
      message.contains('No such file or directory');
}

String? _resolveAdbExecutable({
  required String? requestedPath,
  required bool requiresAdb,
}) {
  if (!requiresAdb) {
    return requestedPath;
  }

  if (requestedPath != null) {
    final trimmed = requestedPath.trim();
    if (trimmed.isEmpty) {
      stderr.writeln('--adb-path must not be empty.');
      exit(64);
    }
    if (_isExecutableAvailable(trimmed)) {
      return trimmed;
    }
    stderr.writeln('adb executable not found at: $trimmed');
    stderr.writeln(
      'Provide a valid path via --adb-path '
      '(example: /Users/<you>/Library/Android/sdk/platform-tools/adb).',
    );
    exit(2);
  }

  final envAdb = _lookupInPath('adb');
  if (envAdb != null) {
    return envAdb;
  }

  final sdkFromEnv = <String>[
    if (Platform.environment['ANDROID_HOME'] case final androidHome?)
      '$androidHome/platform-tools/adb',
    if (Platform.environment['ANDROID_SDK_ROOT'] case final androidSdkRoot?)
      '$androidSdkRoot/platform-tools/adb',
  ];
  for (final candidate in sdkFromEnv) {
    if (_isExecutableAvailable(candidate)) {
      return candidate;
    }
  }

  final home = Platform.environment['HOME'];
  if (home != null && home.isNotEmpty) {
    final macDefault = '$home/Library/Android/sdk/platform-tools/adb';
    if (_isExecutableAvailable(macDefault)) {
      return macDefault;
    }
  }

  stderr.writeln('adb executable not found.');
  stderr.writeln('Either:');
  stderr.writeln('- add adb to PATH, or');
  stderr.writeln(
    '- pass --adb-path /Users/<you>/Library/Android/sdk/platform-tools/adb',
  );
  exit(2);
}

bool _isExecutableAvailable(String path) {
  final file = File(path);
  if (!file.existsSync()) {
    return false;
  }
  try {
    return file.statSync().type == FileSystemEntityType.file;
  } catch (_) {
    return false;
  }
}

String? _lookupInPath(String command) {
  final result = Process.runSync(
    'which',
    [command],
    stdoutEncoding: utf8,
    stderrEncoding: utf8,
  );
  if (result.exitCode != 0) {
    return null;
  }
  final path = (result.stdout as String).trim();
  if (path.isEmpty) {
    return null;
  }
  return path;
}

Future<void> _ensureTable(_SeedDatabase db) {
  return db.customStatement('''
CREATE TABLE IF NOT EXISTS feed_entries (
  id TEXT NOT NULL PRIMARY KEY,
  server_id TEXT NULL,
  emotion TEXT NOT NULL,
  emotion_id TEXT NULL,
  note TEXT NULL,
  intensity INTEGER NULL,
  created_by TEXT NOT NULL,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NULL,
  deleted_at INTEGER NULL,
  is_draft INTEGER NOT NULL DEFAULT 0,
  sync_status TEXT NOT NULL,
  last_synced_at INTEGER NULL
);
''');
}

Future<void> _ensureColumns(_SeedDatabase db) async {
  final rows = await db.customSelect('PRAGMA table_info(feed_entries);').get();
  final columns = rows
      .map((row) => row.data['name'])
      .whereType<String>()
      .toSet();

  if (!columns.contains('emotion_id')) {
    await db.customStatement(
      'ALTER TABLE feed_entries ADD COLUMN emotion_id TEXT NULL;',
    );
  }

  if (!columns.contains('is_draft')) {
    await db.customStatement(
      'ALTER TABLE feed_entries '
      'ADD COLUMN is_draft INTEGER NOT NULL DEFAULT 0;',
    );
  }
}

_FakeEntryPayload _buildEntryPayload({
  required Random random,
  required DateTime now,
  required int index,
  required String createdBy,
  required int days,
}) {
  const emotions = <String>['화남', '불안', '슬픔', '기쁨', '짜증', '두려움', '피곤', '무기력'];

  const notes = <String>[
    '오늘은 감정이 요동쳤다.',
    '짧게 산책하고 조금 나아졌다.',
    '일정이 꼬여서 집중이 안 된다.',
    '생각보다 차분하게 하루를 마무리했다.',
    '대화 하나로 기분이 크게 달라졌다.',
    '쉬는 시간을 더 챙겨야겠다.',
    '작은 성취가 있어서 기분이 괜찮다.',
    '계획했던 일을 절반만 끝냈다.',
    '머리가 복잡해서 정리가 필요하다.',
    '잠을 제대로 못 자서 예민하다.',
  ];

  final spreadMinutes = max(1, days * 24 * 60);
  final createdAt = now.subtract(
    Duration(
      minutes: random.nextInt(spreadMinutes) + (index * 13),
      seconds: random.nextInt(60),
    ),
  );

  final updatedAt = random.nextBool()
      ? createdAt.add(Duration(minutes: random.nextInt(240)))
      : null;

  final isSynced = random.nextInt(100) < 18;
  final syncStatus = switch (random.nextInt(100)) {
    < 60 => 'local_only',
    < 82 => 'pending_upload',
    < 96 => 'synced',
    _ => 'conflict',
  };

  final safeCreatedBy = createdBy.trim().isEmpty ? 'seed_bot' : createdBy;
  final idSuffix = random.nextInt(0x7fffffff).toRadixString(16);
  final id = 'fake_${now.millisecondsSinceEpoch}_$index$idSuffix';
  final emotion = emotions[random.nextInt(emotions.length)];

  return _FakeEntryPayload(
    id: id,
    serverId: isSynced ? 'server_$idSuffix' : null,
    emotion: emotion,
    emotionId: emotion.trim().toLowerCase(),
    note: random.nextInt(100) < 18 ? null : notes[random.nextInt(notes.length)],
    intensity: random.nextInt(100) < 15 ? null : 1 + random.nextInt(5),
    createdBy: safeCreatedBy,
    createdAt: createdAt,
    updatedAt: updatedAt,
    deletedAt: null,
    isDraft: false,
    syncStatus: syncStatus,
    lastSyncedAt: syncStatus == 'synced'
        ? (updatedAt ?? createdAt).add(Duration(minutes: random.nextInt(180)))
        : null,
  );
}

_SeedOptions _parseArgs(List<String> args) {
  if (args.contains('--help') || args.contains('-h')) {
    return const _SeedOptions.help();
  }

  var dbPath = 'emobin.sqlite';
  String? androidPackage;
  String? adbPath;
  var count = 30;
  var createdBy = 'seed_bot';
  var days = 14;
  var clearExisting = false;
  int? randomSeed;

  for (var i = 0; i < args.length; i++) {
    final arg = args[i];
    if (arg == '--clear') {
      clearExisting = true;
      continue;
    }

    if (arg.startsWith('--db-path=')) {
      dbPath = arg.substring('--db-path='.length);
      continue;
    }
    if (arg.startsWith('--android-package=')) {
      androidPackage = _parseNonEmptyString(
        arg.substring('--android-package='.length),
        '--android-package',
      );
      continue;
    }
    if (arg.startsWith('--adb-path=')) {
      adbPath = _parseNonEmptyString(
        arg.substring('--adb-path='.length),
        '--adb-path',
      );
      continue;
    }
    if (arg.startsWith('--count=')) {
      count = _parsePositiveInt(arg.substring('--count='.length), '--count');
      continue;
    }
    if (arg.startsWith('--created-by=')) {
      createdBy = arg.substring('--created-by='.length);
      continue;
    }
    if (arg.startsWith('--days=')) {
      days = _parsePositiveInt(arg.substring('--days='.length), '--days');
      continue;
    }
    if (arg.startsWith('--seed=')) {
      randomSeed = _parsePositiveInt(arg.substring('--seed='.length), '--seed');
      continue;
    }

    if (arg == '--db-path' ||
        arg == '--android-package' ||
        arg == '--adb-path' ||
        arg == '--count' ||
        arg == '--created-by' ||
        arg == '--days' ||
        arg == '--seed') {
      if (i + 1 >= args.length) {
        stderr.writeln('Missing value for $arg');
        stderr.writeln(_usage);
        exit(64);
      }
      final value = args[++i];
      if (arg == '--db-path') {
        dbPath = value;
      } else if (arg == '--android-package') {
        androidPackage = _parseNonEmptyString(value, '--android-package');
      } else if (arg == '--adb-path') {
        adbPath = _parseNonEmptyString(value, '--adb-path');
      } else if (arg == '--count') {
        count = _parsePositiveInt(value, '--count');
      } else if (arg == '--created-by') {
        createdBy = value;
      } else if (arg == '--days') {
        days = _parsePositiveInt(value, '--days');
      } else if (arg == '--seed') {
        randomSeed = _parsePositiveInt(value, '--seed');
      }
      continue;
    }

    stderr.writeln('Unknown option: $arg');
    stderr.writeln(_usage);
    exit(64);
  }

  return _SeedOptions(
    dbPath: dbPath,
    androidPackage: androidPackage,
    adbPath: adbPath,
    count: count,
    createdBy: createdBy,
    days: days,
    clearExisting: clearExisting,
    randomSeed: randomSeed,
  );
}

int _parsePositiveInt(String raw, String option) {
  final value = int.tryParse(raw);
  if (value == null || value <= 0) {
    stderr.writeln('$option must be a positive integer. Received: $raw');
    exit(64);
  }
  return value;
}

String _parseNonEmptyString(String raw, String option) {
  final value = raw.trim();
  if (value.isEmpty) {
    stderr.writeln('$option must not be empty.');
    exit(64);
  }
  return value;
}

class _FakeEntryPayload {
  const _FakeEntryPayload({
    required this.id,
    required this.serverId,
    required this.emotion,
    required this.emotionId,
    required this.note,
    required this.intensity,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.isDraft,
    required this.syncStatus,
    required this.lastSyncedAt,
  });

  final String id;
  final String? serverId;
  final String emotion;
  final String emotionId;
  final String? note;
  final int? intensity;
  final String createdBy;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final bool isDraft;
  final String syncStatus;
  final DateTime? lastSyncedAt;
}

const String _usage = '''
Usage:
  dart run scripts/seed_fake_feed.dart [options]

Options:
  --db-path <path>       SQLite file path (default: emobin.sqlite)
  --android-package <p>  Seed app DB on Android via adb run-as
  --adb-path <path>      adb command path (default: auto-detect)
  --count <n>            Number of rows to insert (default: 30)
  --created-by <value>   created_by value (default: seed_bot)
  --days <n>             Time range for created_at in days (default: 14)
  --seed <n>             Fixed random seed for reproducible data
  --clear                Delete existing rows before insert
  -h, --help             Show help
''';
