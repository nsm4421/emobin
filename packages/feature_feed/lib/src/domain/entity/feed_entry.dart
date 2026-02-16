import 'package:flutter/foundation.dart';

import 'package:feature_feed/src/core/constants/feed_sync_status.dart';
import 'package:feature_feed/src/domain/entity/feed_profile.dart';

@immutable
class FeedEntry {
  final String id;
  final String? serverId;
  final String emotion;
  final String? note;
  final String? imageLocalPath;
  final String? imageRemotePath;
  final String? imageRemoteUrl;
  final int? intensity;
  final String createdBy;
  final FeedProfile? profile;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? resolvedAt;
  final DateTime? deletedAt;
  final FeedSyncStatus syncStatus;
  final DateTime? lastSyncedAt;

  const FeedEntry({
    required this.id,
    this.serverId,
    required this.emotion,
    this.note,
    this.imageLocalPath,
    this.imageRemotePath,
    this.imageRemoteUrl,
    this.intensity,
    required this.createdBy,
    this.profile,
    required this.createdAt,
    this.updatedAt,
    this.resolvedAt,
    this.deletedAt,
    this.syncStatus = FeedSyncStatus.localOnly,
    this.lastSyncedAt,
  });

  static const Object _unset = Object();

  FeedEntry copyWith({
    String? id,
    Object? serverId = _unset,
    String? emotion,
    Object? note = _unset,
    Object? imageLocalPath = _unset,
    Object? imageRemotePath = _unset,
    Object? imageRemoteUrl = _unset,
    Object? intensity = _unset,
    String? createdBy,
    Object? profile = _unset,
    DateTime? createdAt,
    Object? updatedAt = _unset,
    Object? resolvedAt = _unset,
    Object? deletedAt = _unset,
    FeedSyncStatus? syncStatus,
    Object? lastSyncedAt = _unset,
  }) {
    return FeedEntry(
      id: id ?? this.id,
      serverId: serverId == _unset ? this.serverId : serverId as String?,
      emotion: emotion ?? this.emotion,
      note: note == _unset ? this.note : note as String?,
      imageLocalPath: imageLocalPath == _unset
          ? this.imageLocalPath
          : imageLocalPath as String?,
      imageRemotePath: imageRemotePath == _unset
          ? this.imageRemotePath
          : imageRemotePath as String?,
      imageRemoteUrl: imageRemoteUrl == _unset
          ? this.imageRemoteUrl
          : imageRemoteUrl as String?,
      intensity: intensity == _unset ? this.intensity : intensity as int?,
      createdBy: createdBy ?? this.createdBy,
      profile: profile == _unset ? this.profile : profile as FeedProfile?,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt == _unset ? this.updatedAt : updatedAt as DateTime?,
      resolvedAt: resolvedAt == _unset
          ? this.resolvedAt
          : resolvedAt as DateTime?,
      deletedAt: deletedAt == _unset ? this.deletedAt : deletedAt as DateTime?,
      syncStatus: syncStatus ?? this.syncStatus,
      lastSyncedAt: lastSyncedAt == _unset
          ? this.lastSyncedAt
          : lastSyncedAt as DateTime?,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FeedEntry &&
        other.id == id &&
        other.serverId == serverId &&
        other.emotion == emotion &&
        other.note == note &&
        other.imageLocalPath == imageLocalPath &&
        other.imageRemotePath == imageRemotePath &&
        other.imageRemoteUrl == imageRemoteUrl &&
        other.intensity == intensity &&
        other.createdBy == createdBy &&
        other.profile == profile &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.resolvedAt == resolvedAt &&
        other.deletedAt == deletedAt &&
        other.syncStatus == syncStatus &&
        other.lastSyncedAt == lastSyncedAt;
  }

  @override
  int get hashCode => Object.hash(
    id,
    serverId,
    emotion,
    note,
    imageLocalPath,
    imageRemotePath,
    imageRemoteUrl,
    intensity,
    createdBy,
    profile,
    createdAt,
    updatedAt,
    resolvedAt,
    deletedAt,
    syncStatus,
    lastSyncedAt,
  );
}
