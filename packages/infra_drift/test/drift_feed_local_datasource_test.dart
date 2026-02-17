import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:feature_feed/src/core/constants/feed_sync_status.dart';
import 'package:feature_feed/src/core/errors/feed_error.dart';
import 'package:feature_feed/src/core/errors/feed_exception.dart';
import 'package:feature_feed/src/data/model/feed_entry_model.dart';
import 'package:infra_drift/src/core/database/drift_database.dart';
import 'package:infra_drift/src/feed/drift_feed_local_datasource.dart';

void main() {
  late EmobinDatabase database;
  late DriftFeedLocalDataSource dataSource;

  FeedEntryModel buildEntry({
    required String id,
    DateTime? createdAt,
    String emotion = 'happy',
    FeedSyncStatus syncStatus = FeedSyncStatus.localOnly,
    String note = '',
  }) {
    final resolvedCreatedAt = createdAt ?? DateTime.now();
    return FeedEntryModel(
      id: id,
      emotion: emotion,
      note: note,
      createdAt: resolvedCreatedAt,
      updatedAt: resolvedCreatedAt,
      syncStatus: syncStatus,
    );
  }

  setUp(() {
    database = EmobinDatabase.forTesting(NativeDatabase.memory());
    dataSource = DriftFeedLocalDataSource(database);
  });

  tearDown(() async {
    await database.close();
  });

  test('addEntry and fetchEntries returns sorted by createdAt desc', () async {
    final older = buildEntry(id: 'older', createdAt: DateTime(2024, 1, 1));
    final newer = buildEntry(id: 'newer', createdAt: DateTime(2024, 1, 2));

    await dataSource.addEntry(older);
    await dataSource.addEntry(newer);

    final entries = await dataSource.fetchEntries();
    expect(entries.map((entry) => entry.id).toList(), ['newer', 'older']);
  });

  test('updateEntry replaces existing row', () async {
    final entry = buildEntry(id: 'entry');
    await dataSource.addEntry(entry);

    final updated = entry.copyWith(note: 'updated');
    await dataSource.updateEntry(updated);

    final stored = await dataSource.fetchEntry('entry');
    expect(stored?.note, 'updated');
  });

  test('updateEntry throws when entry does not exist', () async {
    final entry = buildEntry(id: 'missing');

    expect(
      () => dataSource.updateEntry(entry),
      throwsA(
        isA<FeedException>().having(
          (exception) => exception.error,
          'error',
          FeedError.entryNotFound,
        ),
      ),
    );
  });

  test('deleteEntry throws when entry does not exist', () async {
    expect(
      () => dataSource.deleteEntry('missing'),
      throwsA(
        isA<FeedException>().having(
          (exception) => exception.error,
          'error',
          FeedError.entryNotFound,
        ),
      ),
    );
  });

  test('fetchEntriesBySyncStatus filters by status', () async {
    final pending = buildEntry(
      id: 'pending',
      syncStatus: FeedSyncStatus.pendingUpload,
    );
    final synced = buildEntry(id: 'synced', syncStatus: FeedSyncStatus.synced);

    await dataSource.addEntry(pending);
    await dataSource.addEntry(synced);

    final entries = await dataSource.fetchEntriesBySyncStatus({
      FeedSyncStatus.pendingUpload,
    });

    expect(entries.map((entry) => entry.id).toList(), ['pending']);
  });

  test('upsertEntries inserts or replaces rows', () async {
    final original = buildEntry(id: 'entry', note: 'original');
    await dataSource.addEntry(original);

    final updated = original.copyWith(note: 'updated');
    final another = buildEntry(id: 'another');
    await dataSource.upsertEntries([updated, another]);

    final stored = await dataSource.fetchEntry('entry');
    final storedAnother = await dataSource.fetchEntry('another');

    expect(stored?.note, 'updated');
    expect(storedAnother?.id, 'another');
  });

  test('watchEntries emits updates', () async {
    final entry = buildEntry(id: 'watched');
    final expectation = expectLater(
      dataSource.watchEntries(),
      emits(
        predicate<List<FeedEntryModel>>(
          (entries) => entries.length == 1 && entries.first.id == 'watched',
        ),
      ),
    );

    await dataSource.addEntry(entry);
    await expectation;
  });
}
