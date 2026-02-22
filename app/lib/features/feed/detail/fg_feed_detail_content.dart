part of 'pg_feed_detail.dart';

class _FeedDetailContent extends StatelessWidget {
  const _FeedDetailContent({required this.entry});

  final FeedEntry entry;

  @override
  Widget build(BuildContext context) {
    final note = entry.note.trim();
    final hashtags = _normalizeHashtags(entry.hashtags);
    final hasMedia = _hasMedia(entry);
    final createdAt = _formatDateTime(entry.createdAt);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                context.colorScheme.surface,
                context.colorScheme.surfaceContainerHighest.withAlpha(110),
              ],
            ),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: context.colorScheme.outlineVariant),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _FeedDetailPill(
                      icon: Icons.calendar_today_rounded,
                      label: createdAt,
                    ),
                    FeedSyncStatusBadge(status: entry.syncStatus),
                    if (entry.isDraft)
                      _FeedDetailPill(
                        icon: Icons.edit_note_rounded,
                        label: context.l10n.draft,
                      ),
                  ],
                ),
                if (hasMedia) ...[
                  const SizedBox(height: 12),
                  _FeedDetailMedia(entry: entry),
                ],
                if (hashtags.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: hashtags
                        .map((tag) => _FeedDetailTagChip(label: '#$tag'))
                        .toList(growable: false),
                  ),
                ],
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: context.colorScheme.surface.withAlpha(170),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: context.colorScheme.outlineVariant.withAlpha(180),
                    ),
                  ),
                  child: Text(
                    note.isEmpty ? context.l10n.noCaptionYet : note,
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: context.colorScheme.onSurface,
                      height: 1.68,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: context.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.colorScheme.outlineVariant),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              tilePadding: EdgeInsets.zero,
              childrenPadding: const EdgeInsets.only(bottom: 8),
              title: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 16,
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    context.l10n.details,
                    style: context.textTheme.titleSmall?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              children: [
                _FeedDetailMetaRow(
                  label: context.l10n.createdAt,
                  value: createdAt,
                ),
                _FeedDetailMetaRow(
                  label: context.l10n.draft,
                  value: entry.isDraft ? context.l10n.yes : context.l10n.no,
                ),
                _FeedDetailMetaRow(
                  label: context.l10n.syncStatus,
                  value: entry.syncStatus.label(context),
                ),
                _FeedDetailMetaRow(
                  label: context.l10n.updatedAt,
                  value: _formatDateTimeOrDash(entry.updatedAt),
                ),
                _FeedDetailMetaRow(
                  label: context.l10n.lastSyncedAt,
                  value: _formatDateTimeOrDash(entry.lastSyncedAt),
                  showDivider: false,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _FeedDetailPill extends StatelessWidget {
  const _FeedDetailPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: context.colorScheme.surface.withAlpha(180),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: context.colorScheme.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: context.colorScheme.onSurfaceVariant),
          const SizedBox(width: 6),
          Text(
            label,
            style: context.textTheme.labelMedium?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeedDetailTagChip extends StatelessWidget {
  const _FeedDetailTagChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: context.colorScheme.primaryContainer.withAlpha(185),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: context.textTheme.labelLarge?.copyWith(
          color: context.colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _FeedDetailMedia extends StatelessWidget {
  const _FeedDetailMedia({required this.entry});

  final FeedEntry entry;

  @override
  Widget build(BuildContext context) {
    final localPath = _normalizeNullableText(entry.imageLocalPath);
    final remoteUrl = _normalizeNullableText(entry.imageRemoteUrl);
    if (localPath == null && remoteUrl == null) {
      return const SizedBox.shrink();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: AspectRatio(
        aspectRatio: 4 / 5,
        child: ColoredBox(
          color: context.colorScheme.surfaceContainerHighest.withAlpha(120),
          child: _buildContent(
            context: context,
            localPath: localPath,
            remoteUrl: remoteUrl,
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
              context.l10n.imageSlot,
              style: context.textTheme.titleSmall?.copyWith(
                color: context.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              context.l10n.addPhotoLater,
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

String? _normalizeNullableText(String? value) {
  final normalized = value?.trim();
  if (normalized == null || normalized.isEmpty) return null;
  return normalized;
}

bool _hasMedia(FeedEntry entry) {
  return _normalizeNullableText(entry.imageLocalPath) != null ||
      _normalizeNullableText(entry.imageRemoteUrl) != null;
}
