import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const entries = <DiaryEntry>[
      DiaryEntry(
        title: '고요한 아침, 생각 정리',
        snippet:
            '햇살이 들어오는 창가에 앉아 오늘 해야 할 일을 차분히 적었다. 생각이 정리되니 마음도 가벼워졌다.',
        dateLabel: '2월 8일 · 일요일',
        moodIcon: Icons.wb_sunny_outlined,
        tagLabels: ['루틴', '집중', '계획'],
      ),
      DiaryEntry(
        title: '점심 산책과 짧은 휴식',
        snippet:
            '회사 근처 공원을 한 바퀴 돌고, 벤치에 앉아 커피를 마셨다. 바람이 차지만 상쾌했다.',
        dateLabel: '2월 7일 · 토요일',
        moodIcon: Icons.park_outlined,
        tagLabels: ['산책', '휴식', '커피'],
      ),
      DiaryEntry(
        title: '작은 성취의 기록',
        snippet:
            '미뤄두었던 사이드 프로젝트의 첫 화면을 완성했다. 작지만 중요한 한 걸음을 찍은 느낌.',
        dateLabel: '2월 6일 · 금요일',
        moodIcon: Icons.auto_awesome_outlined,
        tagLabels: ['개발', '성취', '몰입'],
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF6F2ED),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F2ED),
        elevation: 0,
        title: const Text(
          '오늘의 기록',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Color(0xFFE7DDD2),
              child: Icon(Icons.person_outline, color: Color(0xFF3B2F2F)),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFEFE3D5), Color(0xFFF7EFE7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF3B2F2F).withOpacity(0.08),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B2F2F),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.edit_outlined,
                      color: Color(0xFFF7EFE7),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '오늘은 어떤 하루였나요?',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '한 문장으로도 좋아요. 지금의 감정을 남겨보세요.',
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.4,
                            color: Color(0xFF6E6156),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '피드',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '이번 주 3개',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF6E6156),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...entries.map(
              (entry) => DiaryEntryCard(entry: entry),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF3B2F2F),
        unselectedItemColor: const Color(0xFF9C8F83),
        backgroundColor: const Color(0xFFF6F2ED),
        onTap: (_) {},
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            label: '인사이트',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_note_outlined),
            label: '작성',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: '프로필',
          ),
        ],
      ),
    );
  }
}

class DiaryEntry {
  const DiaryEntry({
    required this.title,
    required this.snippet,
    required this.dateLabel,
    required this.moodIcon,
    required this.tagLabels,
  });

  final String title;
  final String snippet;
  final String dateLabel;
  final IconData moodIcon;
  final List<String> tagLabels;
}

class DiaryEntryCard extends StatelessWidget {
  const DiaryEntryCard({super.key, required this.entry});

  final DiaryEntry entry;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFCFAF7),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE8DED3)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B2F2F).withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFEDE3D7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(entry.moodIcon, color: const Color(0xFF3B2F2F)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      entry.dateLabel,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF8B7D70),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.more_horiz, color: Color(0xFF8B7D70)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            entry.snippet,
            style: const TextStyle(
              fontSize: 13,
              height: 1.5,
              color: Color(0xFF4B3E35),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: entry.tagLabels
                .map(
                  (tag) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1E7DD),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      '#$tag',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6E6156),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
