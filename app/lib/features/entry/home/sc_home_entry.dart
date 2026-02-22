part of 'pg_home_entry.dart';

class _HomeEntry extends StatelessWidget {
  const _HomeEntry();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.homeTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          children: const [
            _HomeFeedStatus(),
            SizedBox(height: 16),
            _HomeWriteEntry(),
            SizedBox(height: 16),
            _HomeSyncBackup(),
          ],
        ),
      ),
    );
  }
}
