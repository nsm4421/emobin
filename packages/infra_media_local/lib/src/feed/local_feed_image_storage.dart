import 'package:feature_feed/feature_feed.dart';
import 'package:injectable/injectable.dart';

import '../base/base_local_image_storage.dart';

@LazySingleton(as: FeedImageStorage)
class LocalFeedImageStorage extends BaseLocalImageStorage
    implements FeedImageStorage {
  @override
  String get folderName => 'feed_images';
}
