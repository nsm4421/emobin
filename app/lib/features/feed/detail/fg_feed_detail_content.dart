part of 'pg_feed_detail.dart';

class _FeedDetailContent extends StatelessWidget {
  const _FeedDetailContent({required this.entry});

  final FeedEntry entry;

  @override
  Widget build(BuildContext context) {
    final note = entry.note.trim();
    final hashtags = _normalizeHashtags(entry.hashtags);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      children: [
        Container(
          decoration: BoxDecoration(
            color: context.colorScheme.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: context.colorScheme.outlineVariant),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 6, 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.schedule_outlined,
                      size: 14,
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _formatDateTime(entry.createdAt),
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    PopupMenuButton<_FeedDetailAction>(
                      tooltip: 'Feed actions',
                      onSelected: (action) async {
                        switch (action) {
                          case _FeedDetailAction.edit:
                            await _editEntry(context);
                          case _FeedDetailAction.delete:
                            await _deleteEntry(context);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem<_FeedDetailAction>(
                          value: _FeedDetailAction.edit,
                          child: Text('Edit Feed'),
                        ),
                        PopupMenuItem<_FeedDetailAction>(
                          value: _FeedDetailAction.delete,
                          child: Text(
                            'Delete Feed',
                            style: TextStyle(color: context.colorScheme.error),
                          ),
                        ),
                      ],
                      icon: Icon(
                        Icons.more_vert,
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              _FeedDetailMedia(entry: entry),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (hashtags.isNotEmpty)
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: hashtags
                            .map(
                              (tag) => Text(
                                '#$tag',
                                style: context.textTheme.titleSmall?.copyWith(
                                  color: context.colorScheme.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            )
                            .toList(growable: false),
                      ),
                    if (hashtags.isNotEmpty) const SizedBox(height: 10),
                    Text(
                      note.isEmpty ? 'No caption yet.' : note,
                      style: context.textTheme.bodyLarge?.copyWith(
                        color: context.colorScheme.onSurface,
                        height: 1.65,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: context.colorScheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: context.colorScheme.outlineVariant),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              tilePadding: EdgeInsets.zero,
              childrenPadding: const EdgeInsets.only(bottom: 8),
              title: Text(
                'Details',
                style: context.textTheme.titleSmall?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                ),
              ),
              children: [
                _FeedDetailMetaRow(
                  label: 'Hashtags',
                  value: hashtags.isEmpty
                      ? '-'
                      : hashtags.map((tag) => '#$tag').join(' '),
                ),
                _FeedDetailMetaRow(
                  label: 'Created At',
                  value: _formatDateTime(entry.createdAt),
                ),
                _FeedDetailMetaRow(
                  label: 'Draft',
                  value: entry.isDraft ? 'Yes' : 'No',
                ),
                _FeedDetailMetaRow(
                  label: 'Sync Status',
                  value: entry.syncStatus.name,
                ),
                _FeedDetailMetaRow(
                  label: 'Server ID',
                  value: _displayNullableText(entry.serverId),
                ),
                _FeedDetailMetaRow(
                  label: 'Local Image',
                  value: _displayNullableText(entry.imageLocalPath),
                ),
                _FeedDetailMetaRow(
                  label: 'Remote Image Path',
                  value: _displayNullableText(entry.imageRemotePath),
                ),
                _FeedDetailMetaRow(
                  label: 'Remote Image URL',
                  value: _displayNullableText(entry.imageRemoteUrl),
                ),
                _FeedDetailMetaRow(
                  label: 'Updated At',
                  value: _formatDateTimeOrDash(entry.updatedAt),
                ),
                _FeedDetailMetaRow(
                  label: 'Last Synced At',
                  value: _formatDateTimeOrDash(entry.lastSyncedAt),
                ),
                _FeedDetailMetaRow(
                  label: 'Deleted At',
                  value: _formatDateTimeOrDash(entry.deletedAt),
                  showDivider: false,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _editEntry(BuildContext context) async {
    await context.router.push(EditFeedRoute(feedId: entry.id));
    if (!context.mounted) return;
    context.read<DetailFeedCubit>().load();
  }

  Future<void> _deleteEntry(BuildContext context) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Feed'),
          content: const Text('Do you want to delete this feed?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
    if (shouldDelete != true || !context.mounted) return;

    final result = await GetIt.instance<FeedUseCase>().softDeleteLocalEntry(
      entry.id,
    );
    if (!context.mounted) return;

    result.match(
      (failure) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(failure.message)));
      },
      (_) {
        if (context.router.canPop()) {
          context.router.pop(true);
          return;
        }
        context.read<DetailFeedCubit>().load();
      },
    );
  }
}

enum _FeedDetailAction { edit, delete }

class _FeedDetailMedia extends StatelessWidget {
  const _FeedDetailMedia({required this.entry});

  final FeedEntry entry;

  @override
  Widget build(BuildContext context) {
    final localPath = _displayNullableText(entry.imageLocalPath);
    final remoteUrl = _displayNullableText(entry.imageRemoteUrl);

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: AspectRatio(
        aspectRatio: 4 / 5,
        child: ColoredBox(
          color: context.colorScheme.surfaceContainerHighest.withAlpha(120),
          child: _buildContent(
            context: context,
            localPath: localPath == '-' ? null : localPath,
            remoteUrl: remoteUrl == '-' ? null : remoteUrl,
          ),
        ),
      ),
    );
  }

  Widget _buildContent({
    required BuildContext context,
    required String? localPath,
    required String? remoteUrl,
  }) {
    if (localPath != null) {
      return Image.file(
        File(localPath),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _MediaPlaceholder(),
      );
    }

    if (remoteUrl != null) {
      return Image.network(
        remoteUrl,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(child: CircularProgressIndicator(strokeWidth: 2));
        },
        errorBuilder: (_, __, ___) => _MediaPlaceholder(),
      );
    }

    return _MediaPlaceholder();
  }
}

class _MediaPlaceholder extends StatelessWidget {
  const _MediaPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.colorScheme.primaryContainer.withAlpha(180),
            context.colorScheme.tertiaryContainer.withAlpha(160),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.image_outlined,
              size: 34,
              color: context.colorScheme.onPrimaryContainer,
            ),
            const SizedBox(height: 10),
            Text(
              'Image slot',
              style: context.textTheme.titleSmall?.copyWith(
                color: context.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'You can add photo later.',
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.onPrimaryContainer.withAlpha(220),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<String> _normalizeHashtags(List<String> raw) {
  return raw
      .map((tag) => tag.trim().replaceFirst(RegExp(r'^#+'), ''))
      .where((tag) => tag.isNotEmpty)
      .toSet()
      .toList(growable: false);
}

String _formatDateTimeOrDash(DateTime? dateTime) {
  if (dateTime == null) return '-';
  return _formatDateTime(dateTime);
}

String _formatDateTime(DateTime dateTime) {
  final local = dateTime.toLocal();

  String twoDigits(int value) => value.toString().padLeft(2, '0');

  final date =
      '${local.year}.${twoDigits(local.month)}.${twoDigits(local.day)}';
  final time = '${twoDigits(local.hour)}:${twoDigits(local.minute)}';
  return '$date $time';
}

String _displayNullableText(String? value) {
  final normalized = value?.trim();
  if (normalized == null || normalized.isEmpty) return '-';
  return normalized;
}
