part of 'pg_create_feed.dart';

class _CreateFeedImage extends StatelessWidget {
  const _CreateFeedImage();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateFeedCubit, CreateFeedState>(
      builder: (context, state) {
        return FeedEditorImage(
          imageLocalPath: state.data.imageLocalPath,
          isProcessing: state.isLoading,
          onImageSelected: (sourcePath) async {
            await context.read<CreateFeedCubit>().saveImageFromSourcePath(
              sourcePath,
            );
          },
          onImageRemoved: () async {
            await context.read<CreateFeedCubit>().removeImage();
          },
          onError: ToastHelper.error,
        );
      },
    );
  }
}
