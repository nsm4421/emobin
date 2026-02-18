part of 'pg_edit_emotion.dart';

class _EditEmotion extends StatelessWidget {
  const _EditEmotion();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('EMOTION SETTINGS')),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _EmotionIntro(),
              SizedBox(height: 16),
              _EmotionInput(),
              SizedBox(height: 16),
              Expanded(child: _EmotionList()),
            ],
          ),
        ),
      ),
    );
  }
}
