import 'package:freezed_annotation/freezed_annotation.dart';

part 'feed_entry_draft.freezed.dart';

@freezed
class FeedEntryDraft with _$FeedEntryDraft {
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
  final DateTime? createdAt;
  @override
  final bool isDraft;

  FeedEntryDraft({
    this.title,
    this.note = '',
    this.hashtags = const <String>[],
    this.imageLocalPath,
    this.imageRemotePath,
    this.imageRemoteUrl,
    this.createdAt,
    this.isDraft = false,
  });
}
