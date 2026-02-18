import 'dart:io';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class FeedEditorImage extends StatefulWidget {
  const FeedEditorImage({
    super.key,
    required this.imageLocalPath,
    required this.onChanged,
    this.onError,
  });

  final String? imageLocalPath;
  final ValueChanged<String?> onChanged;
  final ValueChanged<String>? onError;

  @override
  State<FeedEditorImage> createState() => _FeedEditorImageState();
}

class _FeedEditorImageState extends State<FeedEditorImage> {
  final ImagePicker _picker = ImagePicker();
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final path = widget.imageLocalPath?.trim();
    final hasImage = path != null && path.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Image', style: context.textTheme.titleMedium),
        const SizedBox(height: 8),
        _ImagePreview(
          path: path,
          hasImage: hasImage,
          isProcessing: _isProcessing,
          onTap: _isProcessing ? null : _pickAndStoreImage,
          onRemove: hasImage && !_isProcessing
              ? () => widget.onChanged(null)
              : null,
        ),
      ],
    );
  }

  Future<void> _pickAndStoreImage() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      final picked = await _picker.pickImage(source: ImageSource.gallery);
      if (picked == null) {
        return;
      }

      final savedPath = await _compressAndStore(sourcePath: picked.path);
      if (!mounted) return;

      if (savedPath == null || savedPath.isEmpty) {
        widget.onError?.call('Failed to process the image.');
        return;
      }

      widget.onChanged(savedPath);
    } catch (e, st) {
      debugPrint('FeedEditorImage error: $e');
      debugPrintStack(stackTrace: st);
      if (!mounted) return;
      widget.onError?.call(_toReadableError(e));
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Future<String?> _compressAndStore({required String sourcePath}) async {
    final directory = await getApplicationDocumentsDirectory();
    final imageDirectory = Directory('${directory.path}/feed_images');
    if (!await imageDirectory.exists()) {
      await imageDirectory.create(recursive: true);
    }

    final targetPath =
        '${imageDirectory.path}/feed_${DateTime.now().millisecondsSinceEpoch}.jpg';

    final compressed = await FlutterImageCompress.compressAndGetFile(
      sourcePath,
      targetPath,
      format: CompressFormat.jpeg,
      quality: 78,
      minWidth: 1440,
      minHeight: 1440,
    );

    return compressed?.path;
  }

  String _toReadableError(Object error) {
    if (error is MissingPluginException) {
      return 'Image plugin is not initialized. Please fully restart the app.';
    }

    if (error is PlatformException) {
      final code = error.code.toLowerCase();
      final message = error.message;
      if (code.contains('denied') || code.contains('permission')) {
        return 'Photo permission is required. Please allow access in settings.';
      }
      if (message != null && message.isNotEmpty) {
        return 'Image picker error: $message';
      }
      return 'Image picker error: ${error.code}';
    }

    return 'An error occurred while selecting an image.';
  }
}

class _ImagePreview extends StatelessWidget {
  const _ImagePreview({
    required this.path,
    required this.hasImage,
    required this.isProcessing,
    required this.onTap,
    this.onRemove,
  });

  final String? path;
  final bool hasImage;
  final bool isProcessing;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: context.colorScheme.surfaceContainerHighest.withAlpha(70),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: context.colorScheme.outlineVariant),
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOut,
            height: hasImage ? 172 : 96,
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: hasImage
                        ? _ImageContent(path: path!)
                        : const _ImagePlaceholder(),
                  ),
                ),
                if (isProcessing)
                  const Positioned.fill(
                    child: ColoredBox(
                      color: Color(0x55000000),
                      child: Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  ),
                Positioned(
                  left: 8,
                  bottom: 8,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: context.colorScheme.surface.withAlpha(210),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: Text(
                        hasImage ? 'Tap to replace' : 'Tap to upload',
                        style: context.textTheme.labelSmall?.copyWith(
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ),
                if (onRemove != null)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: IconButton(
                      onPressed: onRemove,
                      visualDensity: VisualDensity.compact,
                      splashRadius: 16,
                      tooltip: 'Remove image',
                      icon: Icon(
                        Icons.close_rounded,
                        size: 16,
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: context.colorScheme.surface.withAlpha(
                          220,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ImageContent extends StatelessWidget {
  const _ImageContent({required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    final file = File(path);
    if (!file.existsSync()) {
      return const _ImagePlaceholder(message: 'Saved image not found.');
    }

    return Image.file(
      file,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => const _ImagePlaceholder(),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder({this.message = 'No image selected'});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.image_outlined,
            size: 22,
            color: context.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 6),
          Text(
            message,
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
