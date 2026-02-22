import 'package:feature_feed/src/data/model/feed_entry_model.dart';

abstract class FeedRemoteDataSource {
  /// 백업본을 원격에서 복원한다.
  Future<List<FeedEntryModel>> restoreEntries({DateTime? since});

  /// 로컬 엔트리 목록을 원격 백업 저장소로 업로드한다.
  Future<void> backupEntries(List<FeedEntryModel> entries);
}
