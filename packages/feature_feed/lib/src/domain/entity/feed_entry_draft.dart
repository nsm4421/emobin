import 'package:flutter/foundation.dart';

import 'package:feature_feed/src/domain/entity/feed_profile.dart';

@immutable
class FeedEntryDraft {
  final String emotion;
  final String? note;
  final String? imageLocalPath;
  final String? imageRemotePath;
  final String? imageRemoteUrl;
  final int? intensity;
  final DateTime? createdAt;
  final String createdBy;
  final FeedProfile? profile;

  const FeedEntryDraft({
    required this.emotion,
    this.note,
    this.imageLocalPath,
    this.imageRemotePath,
    this.imageRemoteUrl,
    this.intensity,
    this.createdAt,
    required this.createdBy,
    this.profile,
  });
}
