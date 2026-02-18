part of 'pg_edit_feed.dart';

class _EditFeed extends StatelessWidget {
  const _EditFeed();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Feed')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          children: const [
            _EditFeedIntro(),
            SizedBox(height: 16),
            _EditFeedEmotion(),
            SizedBox(height: 10),
            _EditFeedNote(),
          ],
        ),
      ),
      bottomNavigationBar: const SafeArea(
        minimum: EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: _EditFeedSubmit(),
      ),
    );
  }
}
