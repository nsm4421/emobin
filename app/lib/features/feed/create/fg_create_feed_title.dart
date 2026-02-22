part of 'pg_create_feed.dart';

class _CreateFeedTitle extends StatelessWidget {
  const _CreateFeedTitle();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateFeedCubit, CreateFeedState>(
      builder: (context, state) {
        return FeedEditorTitle(
          title: state.data.title,
          onChanged: (value) {
            context.read<CreateFeedCubit>().updateTitle(value);
          },
        );
      },
    );
  }
}
