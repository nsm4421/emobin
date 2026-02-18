part of 'pg_edit_feed.dart';

class _EditFeedNote extends StatelessWidget {
  const _EditFeedNote();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditFeedCubit, EditFeedState>(
      builder: (context, state) {
        return FeedEditorNote(
          note: state.data.note,
          onChanged: (value) {
            context.read<EditFeedCubit>().updateNote(value);
          },
        );
      },
    );
  }
}
