part of 'pg_edit_feed.dart';

class _EditFeedImage extends StatelessWidget {
  const _EditFeedImage();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditFeedCubit, EditFeedState>(
      builder: (context, state) {
        return FeedEditorImage(
          imageLocalPath: state.data.imageLocalPath,
          isProcessing: state.isLoading,
          onImageSelected: (sourcePath) async {
            await context.read<EditFeedCubit>().saveImageFromSourcePath(
              sourcePath,
            );
          },
          onImageRemoved: () async {
            await context.read<EditFeedCubit>().removeImage();
          },
          onError: ToastHelper.error,
        );
      },
    );
  }
}
