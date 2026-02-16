import 'package:drift/drift.dart';

@DataClassName('FeedEntryRow')
class FeedEntries extends Table {
  TextColumn get id => text()();

  TextColumn get serverId => text().nullable()();

  TextColumn get emotion => text()();

  TextColumn get note => text().nullable()();

  IntColumn get intensity => integer().nullable()();

  TextColumn get createdBy => text()();

  TextColumn get profileId => text().nullable()();

  TextColumn get profileUsername => text().nullable()();

  TextColumn get profileAvatarUrl => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime().nullable()();

  DateTimeColumn get resolvedAt => dateTime().nullable()();

  DateTimeColumn get deletedAt => dateTime().nullable()();

  TextColumn get syncStatus => text()();

  DateTimeColumn get lastSyncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
