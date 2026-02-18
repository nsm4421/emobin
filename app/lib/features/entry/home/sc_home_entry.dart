part of 'pg_home_entry.dart';

class _HomeEntryScreen extends StatelessWidget {
  const _HomeEntryScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HOME')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          children: const [
            _HomeFeedStatus(),
            SizedBox(height: 16),
            _HomeWriteEntry(),
            SizedBox(height: 16),
            _HomeSyncBackup(),
            SizedBox(height: 16),
            _HomeQuickActions(),
          ],
        ),
      ),
    );
  }
}
