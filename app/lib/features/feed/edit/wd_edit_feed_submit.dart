part of 'pg_edit_feed.dart';

class _EditFeedSubmit extends StatelessWidget {
  const _EditFeedSubmit();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditFeedCubit, EditFeedState>(
      builder: (context, state) {
        final tappable = state.isEditing;
        return AppPrimaryButton(
          label: 'Update Entry',
          fullWidth: true,
          onPressed: tappable
              ? () async {
                  FocusScope.of(context).unfocus();
                  await context.read<EditFeedCubit>().saveEntry();
                }
              : null,
        );
      },
    );
  }
}
