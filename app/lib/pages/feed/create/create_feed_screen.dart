part of 'create_feed_page.dart';

class _CreateFeedScreen extends StatelessWidget {
  const _CreateFeedScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Feed')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          children: [
            const _CreateFeedIntroSection(),
            const SizedBox(height: 16),
            _CreateFeedEmotionSection(),
            const SizedBox(height: 10),
            _CreateFeedNoteSection(),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: _SubmitButtonsWidget(),
      ),
    );
  }
}
