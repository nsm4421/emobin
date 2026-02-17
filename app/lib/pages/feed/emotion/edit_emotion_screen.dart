part of 'edit_emotion_page.dart';

class _EditEmotionScreen extends StatelessWidget {
  const _EditEmotionScreen();

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
              _EmotionIntroSection(),
              SizedBox(height: 16),
              _EmotionInputSection(),
              SizedBox(height: 16),
              Expanded(child: _EmotionListSection()),
            ],
          ),
        ),
      ),
    );
  }
}
