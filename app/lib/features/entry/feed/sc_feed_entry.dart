part of 'pg_feed_entry.dart';

class _FeedEntry extends StatelessWidget {
  const _FeedEntry();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FEED')),
      body: const SafeArea(child: _FeedEntryList()),
    );
  }
}
