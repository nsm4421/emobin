part of 'pg_create_feed.dart';

class _CreateFeedNote extends StatelessWidget {
  const _CreateFeedNote();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateFeedCubit, CreateFeedState>(
      builder: (context, state) {
        return FeedEditorNote(
          note: state.data.note,
          onChanged: (value) {
            context.read<CreateFeedCubit>().updateNote(value);
          },
        );
      },
    );
  }
}
