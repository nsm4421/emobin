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
  final DateTime? lastSyncedAt;
  @override
  final bool isDraft;
  @override
  final FeedSyncStatus syncStatus;

  FeedEntry({
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
    this.lastSyncedAt,
    this.isDraft = false,
    this.syncStatus = FeedSyncStatus.localOnly,
  });
}
