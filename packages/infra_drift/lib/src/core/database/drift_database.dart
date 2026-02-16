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
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    // onUpgrade: (m, from, to) async {
    //   if (from < schemaVersion) {
    //     // Recreate table to recover from legacy/local schema mismatches.
    //     await customStatement('DROP TABLE IF EXISTS feed_entries;');
    //     await m.createTable(feedEntries);
    //   }
    // },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File(p.join(directory.path, 'emobin.sqlite'));
    return NativeDatabase(file);
  });
}
