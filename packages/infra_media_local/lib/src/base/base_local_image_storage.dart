import 'dart:io';

import 'package:feature_feed/feature_feed.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

abstract class BaseLocalImageStorage {
  String get folderName;

  Future<String> saveFromSourcePath(
    String sourcePath, {
    int quality = 80,
    int minWidth = 1440,
    int minHeight = 1440,
  }) async {
    final targetPath = await _buildTargetImagePath();
    final savedPath = await FlutterImageCompress.compressAndGetFile(
      sourcePath,
      targetPath,
      format: CompressFormat.jpeg,
      quality: quality,
      minWidth: minWidth,
      minHeight: minHeight,
    ).then((compressed) => compressed?.path);

    if (savedPath == null || savedPath.trim().isEmpty) {
      throw const FeedException.storageFailure();
    }
    return savedPath;
  }

  Future<void> deleteByPath(String localPath) async {
    final normalizedPath = localPath.trim();
    if (normalizedPath.isEmpty) return;

    final file = File(normalizedPath);
    if (!await file.exists()) return;

    await file.delete();
  }

  Future<String> _buildTargetImagePath() async {
    final appDirectory = await getApplicationDocumentsDirectory();
    final imageDirectory = Directory('${appDirectory.path}/$folderName');
    if (!await imageDirectory.exists()) {
      await imageDirectory.create(recursive: true);
    }
    final filename = Uuid().v4();
    return '${imageDirectory.path}/$filename.jpg';
  }
}
