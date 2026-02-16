part of 'feed_entry_page.dart';

class _FeedEntryScreen extends StatelessWidget {
  const _FeedEntryScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FEED')),
      body: const SafeArea(child: _FeedEntryListSection()),
    );
  }
}
