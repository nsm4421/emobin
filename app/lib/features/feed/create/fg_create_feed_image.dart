part of 'pg_create_feed.dart';

class _CreateFeedImage extends StatelessWidget {
  const _CreateFeedImage();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateFeedCubit, CreateFeedState>(
      builder: (context, state) {
        return FeedEditorImage(
          imageLocalPath: state.data.imageLocalPath,
          onChanged: (path) {
            context.read<CreateFeedCubit>().setImageLocalPath(path);
          },
          onError: ToastHelper.error,
        );
      },
    );
  }
}
