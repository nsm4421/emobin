part of 'pg_edit_hashtag.dart';

class _EditHashtag extends StatelessWidget {
  const _EditHashtag();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '#',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            SizedBox(width: 8),
            Text('Hashtag Preset'),
          ],
        ),
      ),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HashtagIntro(),
              SizedBox(height: 16),
              _HashtagInput(),
              SizedBox(height: 16),
              Expanded(child: _HashtagList()),
            ],
          ),
        ),
      ),
    );
  }
}
