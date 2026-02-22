part of 'pg_create_feed.dart';

class _SubmitButtons extends StatelessWidget {
  const _SubmitButtons();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateFeedCubit, CreateFeedState>(
      builder: (context, state) {
        final tappable = state.isEditing;
        return Row(
          children: [
            // 임시저장
            Expanded(
              child: AppOutlinedButton(
                label: context.l10n.saveDraft,
                fullWidth: true,
                onPressed: tappable
                    ? () async {
                        FocusScope.of(context).unfocus();
                        await context.read<CreateFeedCubit>().saveDraft();
                      }
                    : null,
              ),
            ),
            const SizedBox(width: 10),
            // 저장
            Expanded(
              child: AppPrimaryButton(
                label: context.l10n.postEntry,
                fullWidth: true,
                onPressed: tappable
                    ? () async {
                        FocusScope.of(context).unfocus();
                        await context.read<CreateFeedCubit>().saveEntry();
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
