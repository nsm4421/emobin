part of 'pg_create_feed.dart';

class _CreateFeed extends StatelessWidget {
  const _CreateFeed();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Create Feed'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          children: [
            const _CreateFeedIntro(),
            const SizedBox(height: 16),
            _CreateFeedNote(),
            const SizedBox(height: 10),
            _CreateFeedImage(),
            const SizedBox(height: 10),
            _CreateFeedHashtag(),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: _SubmitButtons(),
      ),
    );
  }
}
