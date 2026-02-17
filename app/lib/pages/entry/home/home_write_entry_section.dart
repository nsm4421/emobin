part of 'home_screen.dart';

class _HomeWriteEntrySection extends StatelessWidget {
  const _HomeWriteEntrySection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ready to Write?',
            style: context.textTheme.titleLarge?.copyWith(
              color: context.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Start a new entry or continue your draft.',
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () {
                // 피드 작성 페이지로 라우팅
                context.router.push(CreateFeedRoute());
              },
              icon: const Icon(Icons.edit_note_rounded),
              label: const Text('Write Today\'s Entry'),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                // TODO : 임시저장한 일기 수정
              },
              icon: const Icon(Icons.restore_rounded),
              label: const Text('Continue Draft'),
            ),
          ),
        ],
      ),
    );
  }
}
