part of 'pg_edit_feed.dart';

class _EditFeedImage extends StatelessWidget {
  const _EditFeedImage();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditFeedCubit, EditFeedState>(
      builder: (context, state) {
        return FeedEditorImage(
          imageLocalPath: state.data.imageLocalPath,
          onChanged: (path) {
            context.read<EditFeedCubit>().setImageLocalPath(path);
          },
          onError: ToastHelper.error,
        );
      },
    );
  }
}
