abstract interface class FeedImageStorage {
  Future<String> saveFromSourcePath(String sourcePath);

  Future<void> deleteByPath(String localPath);
}
