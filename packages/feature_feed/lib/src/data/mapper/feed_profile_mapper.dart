import 'package:feature_feed/src/data/model/feed_profile_model.dart';
import 'package:feature_feed/src/domain/entity/feed_profile.dart';

extension FeedProfileModelX on FeedProfileModel {
  FeedProfile toEntity() {
    return FeedProfile(id: id, username: username, avatarUrl: avatarUrl);
  }
}

extension FeedProfileX on FeedProfile {
  FeedProfileModel toModel() {
    return FeedProfileModel(id: id, username: username, avatarUrl: avatarUrl);
  }
}
