import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../schema/feed_entry.dart';

part 'drift_database.g.dart';

@LazySingleton()
@DriftDatabase(tables: [FeedEntries])
class EmobinDatabase extends _$EmobinDatabase {
  EmobinDatabase() : super(_openConnection());

  EmobinDatabase._withExecutor(super.executor);

  factory EmobinDatabase.forTesting(QueryExecutor executor) {
    return EmobinDatabase._withExecutor(executor);
  }

  @override
  int get schemaVersion => 10;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await customStatement(
          'ALTER TABLE feed_entries ADD COLUMN emotion_id TEXT NULL;',
        );
      }

      if (from < 4) {
        await customStatement('''
          CREATE TABLE feed_entries_new (
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
            sync_status TEXT NOT NULL,
            last_synced_at INTEGER NULL
          );
        ''');

        await customStatement('''
          INSERT INTO feed_entries_new (
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
            sync_status,
            last_synced_at
          )
          SELECT
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
            sync_status,
            last_synced_at
          FROM feed_entries;
        ''');

        await customStatement('DROP TABLE feed_entries;');
        await customStatement(
          'ALTER TABLE feed_entries_new RENAME TO feed_entries;',
        );
      }

      if (from < 5) {
        await customStatement('''
          CREATE TABLE feed_entries_new (
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

        await customStatement('''
          INSERT INTO feed_entries_new (
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
          )
          SELECT
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
            0 AS is_draft,
            sync_status,
            last_synced_at
          FROM feed_entries;
        ''');

        await customStatement('DROP TABLE feed_entries;');
        await customStatement(
          'ALTER TABLE feed_entries_new RENAME TO feed_entries;',
        );
      }

      if (from < 6) {
        await customStatement('DROP TABLE IF EXISTS emotions;');

        await customStatement('''
          CREATE TABLE feed_entries_new (
            id TEXT NOT NULL PRIMARY KEY,
            server_id TEXT NULL,
            emotion TEXT NOT NULL,
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

        await customStatement('''
          INSERT INTO feed_entries_new (
            id,
            server_id,
            emotion,
            note,
            intensity,
            created_by,
            created_at,
            updated_at,
            deleted_at,
            is_draft,
            sync_status,
            last_synced_at
          )
          SELECT
            id,
            server_id,
            emotion,
            note,
            intensity,
            created_by,
            created_at,
            updated_at,
            deleted_at,
            is_draft,
            sync_status,
            last_synced_at
          FROM feed_entries;
        ''');

        await customStatement('DROP TABLE feed_entries;');
        await customStatement(
          'ALTER TABLE feed_entries_new RENAME TO feed_entries;',
        );
      }

      if (from < 7) {
        await customStatement('''
          CREATE TABLE feed_entries_new (
            id TEXT NOT NULL PRIMARY KEY,
            server_id TEXT NULL,
            emotion TEXT NOT NULL,
            note TEXT NULL,
            intensity INTEGER NULL,
            created_at INTEGER NOT NULL,
            updated_at INTEGER NULL,
            deleted_at INTEGER NULL,
            is_draft INTEGER NOT NULL DEFAULT 0,
            sync_status TEXT NOT NULL,
            last_synced_at INTEGER NULL
          );
        ''');

        await customStatement('''
          INSERT INTO feed_entries_new (
            id,
            server_id,
            emotion,
            note,
            intensity,
            created_at,
            updated_at,
            deleted_at,
            is_draft,
            sync_status,
            last_synced_at
          )
          SELECT
            id,
            server_id,
            emotion,
            note,
            intensity,
            created_at,
            updated_at,
            deleted_at,
            is_draft,
            sync_status,
            last_synced_at
          FROM feed_entries;
        ''');

        await customStatement('DROP TABLE feed_entries;');
        await customStatement(
          'ALTER TABLE feed_entries_new RENAME TO feed_entries;',
        );
      }

      if (from < 8) {
        await customStatement('''
          CREATE TABLE feed_entries_new (
            id TEXT NOT NULL PRIMARY KEY,
            server_id TEXT NULL,
            emotion TEXT NULL,
            note TEXT NULL,
            intensity INTEGER NULL,
            created_at INTEGER NOT NULL,
            updated_at INTEGER NULL,
            deleted_at INTEGER NULL,
            is_draft INTEGER NOT NULL DEFAULT 0,
            sync_status TEXT NOT NULL,
            last_synced_at INTEGER NULL
          );
        ''');

        await customStatement('''
          INSERT INTO feed_entries_new (
            id,
            server_id,
            emotion,
            note,
            intensity,
            created_at,
            updated_at,
            deleted_at,
            is_draft,
            sync_status,
            last_synced_at
          )
          SELECT
            id,
            server_id,
            emotion,
            note,
            intensity,
            created_at,
            updated_at,
            deleted_at,
            is_draft,
            sync_status,
            last_synced_at
          FROM feed_entries;
        ''');

        await customStatement('DROP TABLE feed_entries;');
        await customStatement(
          'ALTER TABLE feed_entries_new RENAME TO feed_entries;',
        );
      }

      if (from < 9) {
        await customStatement('''
          CREATE TABLE feed_entries_new (
            id TEXT NOT NULL PRIMARY KEY,
            server_id TEXT NULL,
            note TEXT NULL,
            hashtags TEXT NULL,
            image_local_path TEXT NULL,
            image_remote_path TEXT NULL,
            image_remote_url TEXT NULL,
            created_at INTEGER NOT NULL,
            updated_at INTEGER NULL,
            deleted_at INTEGER NULL,
            is_draft INTEGER NOT NULL DEFAULT 0,
            sync_status TEXT NOT NULL,
            last_synced_at INTEGER NULL
          );
        ''');

        await customStatement('''
          INSERT INTO feed_entries_new (
            id,
            server_id,
            note,
            hashtags,
            image_local_path,
            image_remote_path,
            image_remote_url,
            created_at,
            updated_at,
            deleted_at,
            is_draft,
            sync_status,
            last_synced_at
          )
          SELECT
            id,
            server_id,
            note,
            NULL AS hashtags,
            NULL AS image_local_path,
            NULL AS image_remote_path,
            NULL AS image_remote_url,
            created_at,
            updated_at,
            deleted_at,
            is_draft,
            sync_status,
            last_synced_at
          FROM feed_entries;
        ''');

        await customStatement('DROP TABLE feed_entries;');
        await customStatement(
          'ALTER TABLE feed_entries_new RENAME TO feed_entries;',
        );
      }

      if (from < 10) {
        await customStatement('''
          CREATE TABLE feed_entries_new (
            id TEXT NOT NULL PRIMARY KEY,
            server_id TEXT NULL,
            title TEXT NULL,
            note TEXT NULL,
            hashtags TEXT NULL,
            image_local_path TEXT NULL,
            image_remote_path TEXT NULL,
            image_remote_url TEXT NULL,
            created_at INTEGER NOT NULL,
            updated_at INTEGER NULL,
            deleted_at INTEGER NULL,
            is_draft INTEGER NOT NULL DEFAULT 0,
            sync_status TEXT NOT NULL,
            last_synced_at INTEGER NULL
          );
        ''');

        await customStatement('''
          INSERT INTO feed_entries_new (
            id,
            server_id,
            title,
            note,
            hashtags,
            image_local_path,
            image_remote_path,
            image_remote_url,
            created_at,
            updated_at,
            deleted_at,
            is_draft,
            sync_status,
            last_synced_at
          )
          SELECT
            id,
            server_id,
            NULL AS title,
            note,
            hashtags,
            image_local_path,
            image_remote_path,
            image_remote_url,
            created_at,
            updated_at,
            deleted_at,
            is_draft,
            sync_status,
            last_synced_at
          FROM feed_entries;
        ''');

        await customStatement('DROP TABLE feed_entries;');
        await customStatement(
          'ALTER TABLE feed_entries_new RENAME TO feed_entries;',
        );
      }
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File(p.join(directory.path, 'emobin.sqlite'));
    return NativeDatabase(file);
  });
}
