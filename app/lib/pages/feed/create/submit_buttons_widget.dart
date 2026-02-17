part of 'create_feed_page.dart';

class _SubmitButtonsWidget extends StatelessWidget {
  const _SubmitButtonsWidget();

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
                label: 'Save Draft',
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
                label: 'Post Entry',
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
