import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:feature_feed/feature_feed.dart'
    show FeedEntryModel, FeedSyncStatus;

import '../core/database/drift_database.dart';

mixin DriftFeedEntryMapper {
  List<FeedEntryModel> mapRows(List<FeedEntryRow> rows) {
    return rows.map(mapRow).toList(growable: false);
  }

  FeedEntryModel mapRow(FeedEntryRow row) {
    return FeedEntryModel(
      id: row.id,
      serverId: row.serverId,
      note: row.note ?? '',
      hashtags: _decodeHashtags(row.hashtags),
      imageLocalPath: row.imageLocalPath,
      imageRemotePath: row.imageRemotePath,
      imageRemoteUrl: row.imageRemoteUrl,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      deletedAt: row.deletedAt,
      isDraft: row.isDraft,
      syncStatus: FeedSyncStatus.fromString(row.syncStatus),
      lastSyncedAt: row.lastSyncedAt,
    );
  }

  FeedEntriesCompanion toCompanion(FeedEntryModel entry) {
    return FeedEntriesCompanion(
      id: Value(entry.id),
      serverId: Value(entry.serverId),
      note: Value(entry.note),
      hashtags: Value(_encodeHashtags(entry.hashtags)),
      imageLocalPath: Value(entry.imageLocalPath),
      imageRemotePath: Value(entry.imageRemotePath),
      imageRemoteUrl: Value(entry.imageRemoteUrl),
      createdAt: Value(entry.createdAt),
      updatedAt: Value(entry.updatedAt),
      deletedAt: Value(entry.deletedAt),
      isDraft: Value(entry.isDraft),
      syncStatus: Value(entry.syncStatus.value),
      lastSyncedAt: Value(entry.lastSyncedAt),
    );
  }

  List<String> _decodeHashtags(String? raw) {
    if (raw == null || raw.trim().isEmpty) return const <String>[];

    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        return decoded
            .map((item) => item.toString().trim())
            .where((item) => item.isNotEmpty)
            .toSet()
            .toList(growable: false);
      }
    } catch (_) {
      // Falls back to comma-separated parsing.
    }

    return raw
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toSet()
        .toList(growable: false);
  }

  String? _encodeHashtags(List<String> hashtags) {
    final normalized = hashtags
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toSet()
        .toList(growable: false);
    if (normalized.isEmpty) return null;
    return jsonEncode(normalized);
  }
}
