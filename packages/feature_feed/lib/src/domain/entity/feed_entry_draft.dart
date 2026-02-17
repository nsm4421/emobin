import 'package:freezed_annotation/freezed_annotation.dart';

part 'feed_entry_draft.freezed.dart';

@freezed
class FeedEntryDraft with _$FeedEntryDraft {
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
  final DateTime? createdAt;
  @override
  final bool isDraft;

  FeedEntryDraft({
    this.emotion,
    this.note = '',
    this.imageLocalPath,
    this.imageRemotePath,
    this.imageRemoteUrl,
    this.intensity = 0,
    this.createdAt,
    this.isDraft = false,
  });
}
