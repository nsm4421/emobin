import 'dart:io';

import 'package:core/core.dart';
import 'package:emobin/core/extensions/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class FeedEditorImage extends StatefulWidget {
  const FeedEditorImage({
    super.key,
    required this.imageLocalPath,
    required this.onImageSelected,
    required this.onImageRemoved,
    this.isProcessing = false,
    this.onError,
  });

  final String? imageLocalPath;
  final Future<void> Function(String sourcePath) onImageSelected;
  final Future<void> Function() onImageRemoved;
  final bool isProcessing;
  final ValueChanged<String>? onError;

  @override
  State<FeedEditorImage> createState() => _FeedEditorImageState();
}

class _FeedEditorImageState extends State<FeedEditorImage> {
  final ImagePicker _picker = ImagePicker();
  bool _isPicking = false;

  bool get _isProcessing => _isPicking || widget.isProcessing;

  @override
  Widget build(BuildContext context) {
    final path = widget.imageLocalPath?.trim();
    final hasImage = path != null && path.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.l10n.image, style: context.textTheme.titleMedium),
        const SizedBox(height: 8),
        _ImagePreview(
          path: path,
          hasImage: hasImage,
          isProcessing: _isProcessing,
          onTap: _isProcessing ? null : _pickImage,
          onRemove: hasImage && !_isProcessing ? _removeImage : null,
        ),
      ],
    );
  }

  Future<void> _pickImage() async {
    setState(() {
      _isPicking = true;
    });

    try {
      final picked = await _picker.pickImage(source: ImageSource.gallery);
      if (picked == null) {
        return;
      }
      await widget.onImageSelected(picked.path);
    } catch (e, st) {
      debugPrint('FeedEditorImage error: $e');
      debugPrintStack(stackTrace: st);
      if (!mounted) return;
      widget.onError?.call(_toReadableError(e));
    } finally {
      if (mounted) {
        setState(() {
          _isPicking = false;
        });
      }
    }
  }

  Future<void> _removeImage() async {
    try {
      await widget.onImageRemoved();
    } catch (e, st) {
      debugPrint('FeedEditorImage remove error: $e');
      debugPrintStack(stackTrace: st);
      if (!mounted) return;
      widget.onError?.call(context.l10n.failedProcessImage);
    }
  }

  String _toReadableError(Object error) {
    if (error is MissingPluginException) {
      return context.l10n.imagePluginNotInitialized;
    }

    if (error is PlatformException) {
      final code = error.code.toLowerCase();
      final message = error.message;
      if (code.contains('denied') || code.contains('permission')) {
        return context.l10n.photoPermissionRequired;
      }
      if (message != null && message.isNotEmpty) {
        return context.l10n.imagePickerErrorMessage(message);
      }
      return context.l10n.imagePickerErrorCode(error.code);
    }

    return context.l10n.imageSelectError;
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
                        hasImage
                            ? context.l10n.tapToReplace
                            : context.l10n.tapToUpload,
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
                      tooltip: context.l10n.removeImage,
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
      return _ImagePlaceholder(message: context.l10n.savedImageNotFound);
    }

    return Image.file(
      file,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => const _ImagePlaceholder(),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder({this.message});

  final String? message;

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
            message ?? context.l10n.noImageSelected,
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
