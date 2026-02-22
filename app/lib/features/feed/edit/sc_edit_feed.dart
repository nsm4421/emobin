part of 'pg_edit_feed.dart';

class _EditFeed extends StatelessWidget {
  const _EditFeed();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(context.l10n.editFeedTitle),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          children: const [
            _EditFeedIntro(),
            SizedBox(height: 16),
            _EditFeedTitle(),
            SizedBox(height: 10),
            _EditFeedNote(),
            SizedBox(height: 10),
            _EditFeedImage(),
            SizedBox(height: 10),
            _EditFeedHashtag(),
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
