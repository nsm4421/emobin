import 'package:flutter/foundation.dart';

import 'package:feature_feed/src/core/constants/feed_sync_status.dart';
import 'package:feature_feed/src/data/model/feed_profile_model.dart';

@immutable
class FeedEntryModel {
  final String id;
  final String? serverId;
  final String emotion;
  final String? note;
  final String? imageLocalPath;
  final String? imageRemotePath;
  final String? imageRemoteUrl;
  final int? intensity;
  final String createdBy;
  final FeedProfileModel? profile;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? resolvedAt;
  final DateTime? deletedAt;
  final FeedSyncStatus syncStatus;
  final DateTime? lastSyncedAt;

  const FeedEntryModel({
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

  FeedEntryModel copyWith({
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
    return FeedEntryModel(
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
      profile: profile == _unset ? this.profile : profile as FeedProfileModel?,
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

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'server_id': serverId,
      'emotion': emotion,
      'note': note,
      'image_local_path': imageLocalPath,
      'image_remote_path': imageRemotePath,
      'image_remote_url': imageRemoteUrl,
      'intensity': intensity,
      'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'resolved_at': resolvedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'sync_status': syncStatus.value,
      'last_synced_at': lastSyncedAt?.toIso8601String(),
    };
  }

  factory FeedEntryModel.fromMap(Map<String, dynamic> map) {
    final profilePayload = map['profile'] ?? map['profiles'];
    FeedProfileModel? profile;
    if (profilePayload is Map<String, dynamic>) {
      profile = FeedProfileModel.fromMap(profilePayload);
    }

    DateTime _parseRequiredDate(dynamic value) {
      if (value is DateTime) return value;
      return DateTime.parse(value as String);
    }

    DateTime? _parseOptionalDate(dynamic value) {
      if (value == null) return null;
      if (value is DateTime) return value;
      final raw = value as String;
      if (raw.isEmpty) return null;
      return DateTime.tryParse(raw);
    }

    final createdAtValue = map['created_at'] ?? map['createdAt'];
    final updatedAtValue = map['updated_at'] ?? map['updatedAt'];
    final resolvedAtValue = map['resolved_at'] ?? map['resolvedAt'];
    final deletedAtValue = map['deleted_at'] ?? map['deletedAt'];
    final lastSyncedAtValue = map['last_synced_at'] ?? map['lastSyncedAt'];
    final syncStatusValue = map['sync_status'] ?? map['syncStatus'];

    return FeedEntryModel(
      id: map['id'] as String,
      serverId: map['server_id'] as String? ?? map['serverId'] as String?,
      emotion: map['emotion'] as String? ?? '',
      note: map['note'] as String?,
      imageLocalPath:
          map['image_local_path'] as String? ??
          map['imageLocalPath'] as String?,
      imageRemotePath:
          map['image_remote_path'] as String? ??
          map['imageRemotePath'] as String?,
      imageRemoteUrl:
          map['image_remote_url'] as String? ??
          map['imageRemoteUrl'] as String?,
      intensity: map['intensity'] as int?,
      createdBy:
          map['created_by'] as String? ?? map['createdBy'] as String? ?? '',
      profile: profile,
      createdAt: _parseRequiredDate(createdAtValue),
      updatedAt: _parseOptionalDate(updatedAtValue),
      resolvedAt: _parseOptionalDate(resolvedAtValue),
      deletedAt: _parseOptionalDate(deletedAtValue),
      syncStatus: syncStatusValue is FeedSyncStatus
          ? syncStatusValue
          : FeedSyncStatus.fromString(syncStatusValue as String?),
      lastSyncedAt: _parseOptionalDate(lastSyncedAtValue),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FeedEntryModel &&
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
