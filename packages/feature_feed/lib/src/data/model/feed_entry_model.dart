import 'dart:convert';

import 'package:feature_feed/src/core/constants/feed_sync_status.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'feed_entry_model.freezed.dart';

@freezed
class FeedEntryModel with _$FeedEntryModel {
  @override
  final String id;
  @override
  final String? serverId;
  @override
  final String? title;
  @override
  final String note;
  @override
  final List<String> hashtags;
  @override
  final String? imageLocalPath;
  @override
  final String? imageRemotePath;
  @override
  final String? imageRemoteUrl;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final DateTime? deletedAt;
  @override
  final bool isDraft;
  @override
  final FeedSyncStatus syncStatus;
  @override
  final DateTime? lastSyncedAt;

  FeedEntryModel({
    required this.id,
    this.serverId,
    this.title,
    this.note = '',
    this.hashtags = const <String>[],
    this.imageLocalPath,
    this.imageRemotePath,
    this.imageRemoteUrl,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.isDraft = false,
    this.syncStatus = FeedSyncStatus.localOnly,
    this.lastSyncedAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'server_id': serverId,
      'title': title,
      'note': note,
      'hashtags': hashtags,
      'image_local_path': imageLocalPath,
      'image_remote_path': imageRemotePath,
      'image_remote_url': imageRemoteUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'is_draft': isDraft,
      'sync_status': syncStatus.value,
      'last_synced_at': lastSyncedAt?.toIso8601String(),
    };
  }

  factory FeedEntryModel.fromMap(Map<String, dynamic> map) {
    DateTime parseRequiredDate(dynamic value) {
      if (value is DateTime) return value;
      return DateTime.parse(value as String);
    }

    DateTime? parseOptionalDate(dynamic value) {
      if (value == null) return null;
      if (value is DateTime) return value;
      final raw = value as String;
      if (raw.isEmpty) return null;
      return DateTime.tryParse(raw);
    }

    bool parseBool(dynamic value, {required bool fallback}) {
      if (value == null) return fallback;
      if (value is bool) return value;
      if (value is num) return value != 0;
      final raw = value.toString().trim().toLowerCase();
      if (raw == '1' || raw == 'true') return true;
      if (raw == '0' || raw == 'false') return false;
      return fallback;
    }

    List<String> parseHashtags(dynamic value) {
      if (value == null) return const <String>[];
      if (value is List) {
        return value
            .map((item) => item.toString().trim())
            .where((item) => item.isNotEmpty)
            .toSet()
            .toList(growable: false);
      }

      final raw = value.toString().trim();
      if (raw.isEmpty) return const <String>[];

      if (raw.startsWith('[') && raw.endsWith(']')) {
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
          // Fallback to comma-separated parsing.
        }
      }

      return raw
          .split(',')
          .map((item) => item.trim())
          .where((item) => item.isNotEmpty)
          .toSet()
          .toList(growable: false);
    }

    final createdAtValue = map['created_at'] ?? map['createdAt'];
    final updatedAtValue = map['updated_at'] ?? map['updatedAt'];
    final deletedAtValue = map['deleted_at'] ?? map['deletedAt'];
    final isDraftValue = map['is_draft'] ?? map['isDraft'];
    final lastSyncedAtValue = map['last_synced_at'] ?? map['lastSyncedAt'];
    final syncStatusValue = map['sync_status'] ?? map['syncStatus'];

    return FeedEntryModel(
      id: map['id'] as String,
      serverId: map['server_id'] as String? ?? map['serverId'] as String?,
      title: map['title'] as String?,
      note: map['note'] as String? ?? '',
      hashtags: parseHashtags(map['hashtags']),
      imageLocalPath:
          map['image_local_path'] as String? ??
          map['imageLocalPath'] as String?,
      imageRemotePath:
          map['image_remote_path'] as String? ??
          map['imageRemotePath'] as String?,
      imageRemoteUrl:
          map['image_remote_url'] as String? ??
          map['imageRemoteUrl'] as String?,
      createdAt: parseRequiredDate(createdAtValue),
      updatedAt: parseOptionalDate(updatedAtValue),
      deletedAt: parseOptionalDate(deletedAtValue),
      isDraft: parseBool(isDraftValue, fallback: false),
      syncStatus: syncStatusValue is FeedSyncStatus
          ? syncStatusValue
          : FeedSyncStatus.fromString(syncStatusValue as String?),
      lastSyncedAt: parseOptionalDate(lastSyncedAtValue),
    );
  }
}
