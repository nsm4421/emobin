import 'package:drift/drift.dart';

@DataClassName('FeedEntryRow')
class FeedEntries extends Table {
  TextColumn get id => text()();

  TextColumn get serverId => text().nullable()();

  TextColumn get title => text().nullable()();

  TextColumn get note => text().nullable()();

  TextColumn get hashtags => text().nullable()();

  TextColumn get imageLocalPath => text().nullable()();

  TextColumn get imageRemotePath => text().nullable()();

  TextColumn get imageRemoteUrl => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime().nullable()();

  DateTimeColumn get deletedAt => dateTime().nullable()();

  BoolColumn get isDraft => boolean().withDefault(const Constant(false))();

  TextColumn get syncStatus => text()();

  DateTimeColumn get lastSyncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
