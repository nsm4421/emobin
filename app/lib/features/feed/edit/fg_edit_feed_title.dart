part of 'pg_edit_feed.dart';

class _EditFeedTitle extends StatelessWidget {
  const _EditFeedTitle();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditFeedCubit, EditFeedState>(
      builder: (context, state) {
        return FeedEditorTitle(
          title: state.data.title,
          onChanged: (value) {
            context.read<EditFeedCubit>().updateTitle(value);
          },
        );
      },
    );
  }
}
