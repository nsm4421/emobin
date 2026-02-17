import 'package:feature_feed/src/core/constants/feed_sync_status.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'feed_entry.freezed.dart';

@freezed
class FeedEntry with _$FeedEntry {
  @override
  final String id;
  @override
  final String? serverId;
  @override
  final String? emotion;
  @override
  final String note;
  @override
  final String? imageLocalPath;
  @override
  final String? imageRemotePath;
  @override
  final String? imageRemoteUrl;
  @override
  final int intensity;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final DateTime? deletedAt;
  @override
  final DateTime? lastSyncedAt;
  @override
  final bool isDraft;
  @override
  final FeedSyncStatus syncStatus;

  FeedEntry({
    required this.id,
    this.serverId,
    this.emotion,
    this.note = '',
    this.imageLocalPath,
    this.imageRemotePath,
    this.imageRemoteUrl,
    this.intensity = 0,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.lastSyncedAt,
    this.isDraft = false,
    this.syncStatus = FeedSyncStatus.localOnly,
  });
}
