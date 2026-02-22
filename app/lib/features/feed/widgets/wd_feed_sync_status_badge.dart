import 'package:core/core.dart';
import 'package:emobin/core/extensions/l10n_extension.dart';
import 'package:feature_feed/feature_feed.dart';
import 'package:flutter/material.dart';

class FeedSyncStatusBadge extends StatelessWidget {
  const FeedSyncStatusBadge({
    super.key,
    required this.status,
    this.iconSize = 14,
  });

  final FeedSyncStatus status;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: status.label(context),
      triggerMode: TooltipTriggerMode.tap,
      waitDuration: Duration.zero,
      showDuration: const Duration(seconds: 2),
      child: Icon(
        status.icon,
        size: iconSize,
        color: context.colorScheme.onSurfaceVariant,
      ),
    );
  }
}

extension FeedSyncStatusUiX on FeedSyncStatus {
  IconData get icon {
    return switch (this) {
      FeedSyncStatus.localOnly => Icons.save_outlined,
      FeedSyncStatus.pendingUpload => Icons.cloud_upload_outlined,
      FeedSyncStatus.synced => Icons.cloud_done_outlined,
      FeedSyncStatus.conflict => Icons.sync_problem_rounded,
    };
  }

  String label(BuildContext context) {
    final l10n = context.l10n;
    return switch (this) {
      FeedSyncStatus.localOnly => l10n.syncStatusLocalOnlyLabel,
      FeedSyncStatus.pendingUpload => l10n.syncStatusPendingUploadLabel,
      FeedSyncStatus.synced => l10n.syncStatusSyncedLabel,
      FeedSyncStatus.conflict => l10n.syncStatusConflictLabel,
    };
  }
}
