part of 'pg_edit_feed.dart';

class _EditFeedSubmit extends StatelessWidget {
  const _EditFeedSubmit();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditFeedCubit, EditFeedState>(
      builder: (context, state) {
        final tappable = state.isEditing;
        return Row(
          children: [
            Expanded(
              child: AppOutlinedButton(
                label: context.l10n.cancel,
                fullWidth: true,
                onPressed: tappable && context.router.canPop()
                    ? () => context.router.pop()
                    : null,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: AppPrimaryButton(
                label: context.l10n.updateEntry,
                fullWidth: true,
                onPressed: tappable
                    ? () async {
                        FocusScope.of(context).unfocus();
                        await context.read<EditFeedCubit>().saveEntry();
                      }
                    : null,
              ),
            ),
          ],
        );
      },
    );
  }
}
