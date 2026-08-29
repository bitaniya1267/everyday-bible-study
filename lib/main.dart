
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final store = StudyStore();
  await store.load();
  runApp(BitaniyaApp(store: store));
}

// -----------------------------------------------------------------------------
// DESIGN
// -----------------------------------------------------------------------------

class AppColors {
  static const forest = Color(0xFF23463A);
  static const forestLight = Color(0xFF3E6B59);
  static const sage = Color(0xFFDCE8DF);
  static const cream = Color(0xFFF7F5EF);
  static const paper = Color(0xFFFFFEFA);
  static const gold = Color(0xFFC9A45D);
  static const ink = Color(0xFF24312C);
  static const muted = Color(0xFF6C7771);
  static const dark = Color(0xFF101715);
  static const darkCard = Color(0xFF1A2420);
}

ThemeData buildLightTheme() {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.cream,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.forest,
      brightness: Brightness.light,
      surface: AppColors.cream,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.cream,
      foregroundColor: AppColors.ink,
      elevation: 0,
      centerTitle: false,
    ),
    cardTheme: CardThemeData(
      color: AppColors.paper,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.paper,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: AppColors.forest,
          width: 1.2,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
    ),
  );
}

ThemeData buildDarkTheme() {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.forestLight,
      brightness: Brightness.dark,
      surface: AppColors.dark,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.dark,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      color: AppColors.darkCard,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
    ),
  );
}

// -----------------------------------------------------------------------------
// CONSTANTS / HELPERS
// -----------------------------------------------------------------------------

const Map<String, int> bibleBooks = {
  'Matthew': 28,
  'Mark': 16,
  'Luke': 24,
  'John': 21,
  'Acts': 28,
  'Romans': 16,
  '1 Corinthians': 16,
  '2 Corinthians': 13,
  'Galatians': 6,
  'Ephesians': 6,
  'Philippians': 4,
  'Colossians': 4,
  '1 Thessalonians': 5,
  '2 Thessalonians': 3,
  '1 Timothy': 6,
  '2 Timothy': 4,
  'Titus': 3,
  'Philemon': 1,
  'Hebrews': 13,
  'James': 5,
  '1 Peter': 5,
  '2 Peter': 3,
  '1 John': 5,
  '2 John': 1,
  '3 John': 1,
  'Jude': 1,
  'Revelation': 22,
};

int get totalNtChapters =>
    bibleBooks.values.fold<int>(0, (sum, value) => sum + value);

String dateKey(DateTime date) {
  return '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}

DateTime dayOnly(DateTime d) => DateTime(d.year, d.month, d.day);

String formatDate(DateTime d) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${months[d.month - 1]} ${d.day}, ${d.year}';
}

String monthName(int month) {
  const names = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  return names[month - 1];
}

String plainToDelta(String text) {
  if (text.isEmpty) {
    return jsonEncode([
      {'insert': '\n'}
    ]);
  }
  return jsonEncode([
    {'insert': '$text\n'}
  ]);
}

String deltaToPlain(String? value) {
  if (value == null || value.trim().isEmpty) return '';
  try {
    final raw = jsonDecode(value);
    final document = Document.fromJson(raw);
    return document.toPlainText().trim();
  } catch (_) {
    return value;
  }
}

// -----------------------------------------------------------------------------
// MODELS
// -----------------------------------------------------------------------------

class StudyChapter {
  String reference;

  String keyVerse;
  String summary;
  String observation;
  String interpretation;
  String lessons;
  String application;
  String questions;
  String prayer;
  String character;
  String characterLessons;

  bool favorite;
  bool bookmark;

  StudyChapter({
    this.reference = '',
    this.keyVerse = '',
    this.summary = '',
    this.observation = '',
    this.interpretation = '',
    this.lessons = '',
    this.application = '',
    this.questions = '',
    this.prayer = '',
    this.character = '',
    this.characterLessons = '',
    this.favorite = false,
    this.bookmark = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'reference': reference,
      'keyVerse': keyVerse,
      'summary': summary,
      'observation': observation,
      'interpretation': interpretation,
      'lessons': lessons,
      'application': application,
      'questions': questions,
      'prayer': prayer,
      'character': character,
      'characterLessons': characterLessons,
      'favorite': favorite,
      'bookmark': bookmark,
    };
  }

  factory StudyChapter.fromJson(Map<String, dynamic> json) {
    return StudyChapter(
      reference: json['reference'] ?? '',
      keyVerse: json['keyVerse'] ?? '',
      summary: json['summary'] ?? '',
      observation: json['observation'] ?? '',
      interpretation: json['interpretation'] ?? '',
      lessons: json['lessons'] ?? '',
      application: json['application'] ?? '',
      questions: json['questions'] ?? '',
      prayer: json['prayer'] ?? '',
      character: json['character'] ?? '',
      characterLessons: json['characterLessons'] ?? '',
      favorite: json['favorite'] == true,
      bookmark: json['bookmark'] == true,
    );
  }
}

class StudyDay {
  DateTime date;
  List<StudyChapter> chapters;

  StudyDay({
    required this.date,
    required this.chapters,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'chapters': chapters.map((e) => e.toJson()).toList(),
    };
  }

  factory StudyDay.fromJson(Map<String, dynamic> json) {
    return StudyDay(
      date: DateTime.parse(json['date']),
      chapters: (json['chapters'] as List? ?? [])
          .map(
            (e) => StudyChapter.fromJson(
              Map<String, dynamic>.from(e),
            ),
          )
          .toList(),
    );
  }
}

// -----------------------------------------------------------------------------
// STORAGE
// -----------------------------------------------------------------------------

class StudyStore extends ChangeNotifier {
  static const String studiesKey = 'bitaniya_studies_v2';
  static const String readingKey = 'bitaniya_reading_v2';
  static const String darkKey = 'bitaniya_dark_v2';

  final Map<String, StudyDay> studies = {};
  final Map<String, Set<int>> reading = {};

  bool darkMode = false;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();

    final studiesRaw = prefs.getString(studiesKey);
    if (studiesRaw != null) {
      try {
        final list = jsonDecode(studiesRaw) as List;
        for (final item in list) {
          final day = StudyDay.fromJson(
            Map<String, dynamic>.from(item),
          );
          studies[dateKey(day.date)] = day;
        }
      } catch (_) {}
    }

    final readingRaw = prefs.getString(readingKey);
    if (readingRaw != null) {
      try {
        final map = Map<String, dynamic>.from(
          jsonDecode(readingRaw),
        );
        for (final entry in map.entries) {
          reading[entry.key] = Set<int>.from(
            (entry.value as List).map((e) => e as int),
          );
        }
      } catch (_) {}
    }

    darkMode = prefs.getBool(darkKey) ?? false;
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      studiesKey,
      jsonEncode(
        studies.values.map((e) => e.toJson()).toList(),
      ),
    );

    await prefs.setString(
      readingKey,
      jsonEncode(
        reading.map(
          (key, value) => MapEntry(key, value.toList()),
        ),
      ),
    );

    await prefs.setBool(darkKey, darkMode);
    notifyListeners();
  }

  StudyDay getOrCreateDay(DateTime date) {
    final normalized = dayOnly(date);

    return studies.putIfAbsent(
      dateKey(normalized),
      () => StudyDay(
        date: normalized,
        chapters: [StudyChapter()],
      ),
    );
  }

  int get studyDays => studies.length;

  int get chaptersStudied => studies.values.fold(
        0,
        (sum, day) => sum + day.chapters.length,
      );

  int get readChapters => reading.values.fold(
        0,
        (sum, chapters) => sum + chapters.length,
      );

  int get streak {
    if (studies.isEmpty) return 0;

    DateTime cursor = dayOnly(DateTime.now());
    int count = 0;

    while (studies.containsKey(dateKey(cursor))) {
      count++;
      cursor = cursor.subtract(const Duration(days: 1));
    }

    return count;
  }

  int get completedBooks {
    int count = 0;
    for (final entry in bibleBooks.entries) {
      if ((reading[entry.key]?.length ?? 0) >= entry.value) {
        count++;
      }
    }
    return count;
  }

  bool isRead(String book, int chapter) {
    return reading[book]?.contains(chapter) ?? false;
  }

  Future<void> toggleChapter(String book, int chapter) async {
    final set = reading.putIfAbsent(book, () => <int>{});

    if (set.contains(chapter)) {
      set.remove(chapter);
    } else {
      set.add(chapter);
    }

    await save();
  }

  Future<void> setDarkMode(bool value) async {
    darkMode = value;
    await save();
  }

  Future<String> createBackup() async {
    return jsonEncode({
      'format': 'Bitaniya Bible Study Backup',
      'version': 2,
      'createdAt': DateTime.now().toIso8601String(),
      'studies': studies.values.map((e) => e.toJson()).toList(),
      'reading': reading.map(
        (key, value) => MapEntry(key, value.toList()),
      ),
    });
  }

  Future<void> restoreBackup(String text) async {
    final decoded = Map<String, dynamic>.from(
      jsonDecode(text),
    );

    studies.clear();
    reading.clear();

    for (final item in (decoded['studies'] as List? ?? [])) {
      final day = StudyDay.fromJson(
        Map<String, dynamic>.from(item),
      );
      studies[dateKey(day.date)] = day;
    }

    final rawReading = Map<String, dynamic>.from(
      decoded['reading'] ?? {},
    );

    for (final entry in rawReading.entries) {
      reading[entry.key] = Set<int>.from(
        (entry.value as List).map((e) => e as int),
      );
    }

    await save();
  }
}

// -----------------------------------------------------------------------------
// APP
// -----------------------------------------------------------------------------

class BitaniyaApp extends StatelessWidget {
  final StudyStore store;

  const BitaniyaApp({
    super.key,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Bitaniya Bible Study',
          theme: buildLightTheme(),
          darkTheme: buildDarkTheme(),
          themeMode:
              store.darkMode ? ThemeMode.dark : ThemeMode.light,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            FlutterQuillLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
          ],
          home: AppShell(store: store),
        );
      },
    );
  }
}

// -----------------------------------------------------------------------------
// SHELL / NAVIGATION
// -----------------------------------------------------------------------------

class AppShell extends StatefulWidget {
  final StudyStore store;

  const AppShell({
    super.key,
    required this.store,
  });

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int index = 0;

  void goTo(int value) {
    setState(() => index = value);
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(
        store: widget.store,
        onStudy: () => goTo(1),
      ),
      DailyStudyScreen(store: widget.store),
      CalendarScreen(store: widget.store),
      StatsScreen(store: widget.store),
      BackupScreen(store: widget.store),
    ];

    return Scaffold(
      body: SafeArea(child: pages[index]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: goTo,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Study',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Calendar',
          ),
          NavigationDestination(
            icon: Icon(Icons.insights_outlined),
            selectedIcon: Icon(Icons.insights),
            label: 'Stats',
          ),
          NavigationDestination(
            icon: Icon(Icons.cloud_outlined),
            selectedIcon: Icon(Icons.cloud),
            label: 'Backup',
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// HOME
// -----------------------------------------------------------------------------

class HomeScreen extends StatelessWidget {
  final StudyStore store;
  final VoidCallback onStudy;

  const HomeScreen({
    super.key,
    required this.store,
    required this.onStudy,
  });

  void openMore(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(8, 8, 8, 10),
                child: Text(
                  'More',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              _MoreItem(
                icon: Icons.search,
                title: 'Search studies',
                onTap: () {
                  Navigator.pop(sheetContext);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SearchScreen(store: store),
                    ),
                  );
                },
              ),
              _MoreItem(
                icon: Icons.bookmark_outline,
                title: 'Bookmarks',
                onTap: () {
                  Navigator.pop(sheetContext);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LibraryScreen(
                        store: store,
                        favoritesOnly: false,
                      ),
                    ),
                  );
                },
              ),
              _MoreItem(
                icon: Icons.star_outline,
                title: 'Favorites',
                onTap: () {
                  Navigator.pop(sheetContext);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LibraryScreen(
                        store: store,
                        favoritesOnly: true,
                      ),
                    ),
                  );
                },
              ),
              _MoreItem(
                icon: Icons.person_outline,
                title: 'Character library',
                onTap: () {
                  Navigator.pop(sheetContext);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CharacterLibraryScreen(
                        store: store,
                      ),
                    ),
                  );
                },
              ),
              _MoreItem(
                icon: Icons.auto_stories_outlined,
                title: 'New Testament tracker',
                onTap: () {
                  Navigator.pop(sheetContext);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TrackerScreen(store: store),
                    ),
                  );
                },
              ),
              _MoreItem(
                icon: Icons.settings_outlined,
                title: 'Settings',
                onTap: () {
                  Navigator.pop(sheetContext);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SettingsScreen(store: store),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = totalNtChapters == 0
        ? 0.0
        : store.readChapters / totalNtChapters;

    final recent = store.studies.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Bitaniya Bible Study',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -.4,
                ),
              ),
            ),
            IconButton(
              tooltip: 'More',
              onPressed: () => openMore(context),
              icon: const Icon(Icons.more_vert),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'A quiet place to meet God in Scripture.',
          style: TextStyle(
            color: Theme.of(context)
                .colorScheme
                .onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 20),
        _TodayStudyCard(onTap: onStudy),
        const SizedBox(height: 28),
        const _SectionLabel('YOUR PROGRESS'),
        const SizedBox(height: 10),
        _ProgressCard(store: store),
        const SizedBox(height: 24),
        const _SectionLabel('NEW TESTAMENT'),
        const SizedBox(height: 10),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Reading progress',
                        style: TextStyle(
                          fontWeight: FontWeight.w750,
                        ),
                      ),
                    ),
                    Text(
                      '${store.readChapters} of $totalNtChapters',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${(progress * 100).round()}% complete',
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              TrackerScreen(store: store),
                        ),
                      );
                    },
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Open tracker'),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        const _SectionLabel('RECENT STUDIES'),
        const SizedBox(height: 8),
        if (recent.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Icon(
                    Icons.menu_book_outlined,
                    size: 34,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'No studies yet',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Start today’s study to build your journal.',
                    style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ...recent.take(5).map(
                (day) => _RecentStudyTile(
                  day: day,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DailyStudyScreen(
                          store: store,
                          initialDate: day.date,
                        ),
                      ),
                    );
                  },
                ),
              ),
      ],
    );
  }
}

class _TodayStudyCard extends StatelessWidget {
  final VoidCallback onTap;

  const _TodayStudyCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.forest,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .10),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.menu_book_rounded,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.arrow_forward,
                    color: Colors.white70,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "TODAY'S STUDY",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Ready to study?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Open your study journal and spend time in the Word.',
                style: TextStyle(
                  color: Colors.white70,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text(
                    "Start today's study",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 18,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final StudyStore store;

  const _ProgressCard({required this.store});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Row(
          children: [
            _ProgressStat(
              value: '${store.studyDays}',
              label: 'Study days',
            ),
            const _VerticalDivider(),
            _ProgressStat(
              value: '${store.chaptersStudied}',
              label: 'Chapters',
            ),
            const _VerticalDivider(),
            _ProgressStat(
              value: '🔥 ${store.streak}',
              label: 'Streak',
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressStat extends StatelessWidget {
  final String value;
  final String label;

  const _ProgressStat({
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context)
                  .colorScheme
                  .onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 38,
      color: Theme.of(context).dividerColor,
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;

  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.25,
        color: Theme.of(context)
            .colorScheme
            .onSurfaceVariant,
      ),
    );
  }
}

class _RecentStudyTile extends StatelessWidget {
  final StudyDay day;
  final VoidCallback onTap;

  const _RecentStudyTile({
    required this.day,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final refs = day.chapters
        .map((e) => e.reference.trim())
        .where((e) => e.isNotEmpty)
        .join(' • ');

    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(vertical: 1),
      title: Text(
        refs.isEmpty ? 'Untitled study' : refs,
        style: const TextStyle(
          fontWeight: FontWeight.w750,
        ),
      ),
      subtitle: Text(formatDate(day.date)),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 14,
      ),
      onTap: onTap,
    );
  }
}

class _MoreItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _MoreItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

// -----------------------------------------------------------------------------
// DAILY STUDY
// -----------------------------------------------------------------------------

class DailyStudyScreen extends StatefulWidget {
  final StudyStore store;
  final DateTime? initialDate;

  const DailyStudyScreen({
    super.key,
    required this.store,
    this.initialDate,
  });

  @override
  State<DailyStudyScreen> createState() =>
      _DailyStudyScreenState();
}

class _DailyStudyScreenState
    extends State<DailyStudyScreen> {
  late DateTime selectedDate;
  late StudyDay day;

  @override
  void initState() {
    super.initState();
    selectedDate =
        dayOnly(widget.initialDate ?? DateTime.now());
    day = widget.store.getOrCreateDay(selectedDate);
  }

  void changeDate(DateTime date) {
    setState(() {
      selectedDate = dayOnly(date);
      day = widget.store.getOrCreateDay(selectedDate);
    });
  }

  Future<void> saveStudy() async {
    widget.store.studies[dateKey(day.date)] = day;
    await widget.store.save();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Study saved'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void addChapter() {
    setState(() {
      day.chapters.add(StudyChapter());
    });
  }

  void removeChapter(int index) {
    if (day.chapters.length == 1) return;
    setState(() {
      day.chapters.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Study',
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            IconButton(
              tooltip: 'Save',
              onPressed: saveStudy,
              icon: const Icon(
                Icons.check_circle_outline,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              formatDate(selectedDate),
              style: TextStyle(
                color: Theme.of(context)
                    .colorScheme
                    .onSurfaceVariant,
              ),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                  initialDate: selectedDate,
                );

                if (picked != null) {
                  changeDate(picked);
                }
              },
              icon: const Icon(
                Icons.calendar_today_outlined,
                size: 17,
              ),
              label: const Text('Change date'),
            ),
          ],
        ),
        const SizedBox(height: 18),
        ...List.generate(
          day.chapters.length,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: ChapterEditor(
              key: ValueKey(
                '${dateKey(day.date)}-$index',
              ),
              chapter: day.chapters[index],
              index: index,
              onChanged: () => setState(() {}),
              onRemove: day.chapters.length == 1
                  ? null
                  : () => removeChapter(index),
            ),
          ),
        ),
        OutlinedButton.icon(
          onPressed: addChapter,
          icon: const Icon(Icons.add),
          label: const Text('Add another chapter'),
        ),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: saveStudy,
          icon: const Icon(Icons.save_outlined),
          label: const Text("SAVE TODAY'S STUDY"),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// CHAPTER EDITOR / RICH TEXT
// -----------------------------------------------------------------------------

class ChapterEditor extends StatefulWidget {
  final StudyChapter chapter;
  final int index;
  final VoidCallback onChanged;
  final VoidCallback? onRemove;

  const ChapterEditor({
    super.key,
    required this.chapter,
    required this.index,
    required this.onChanged,
    required this.onRemove,
  });

  @override
  State<ChapterEditor> createState() =>
      _ChapterEditorState();
}

class _ChapterEditorState extends State<ChapterEditor> {
  late final TextEditingController reference;

  late final Map<String, String> fieldTitles = {
    'keyVerse': 'Key Verse',
    'summary': 'Summary',
    'observation': 'Observe',
    'interpretation': 'Understand',
    'lessons': 'Lessons',
    'application': 'Apply',
    'questions': 'Questions',
    'prayer': 'Prayer',
    'character': 'Character Study',
    'characterLessons': 'Character Lessons',
  };

  final Map<String, String> values = {};

  @override
  void initState() {
    super.initState();

    reference = TextEditingController(
      text: widget.chapter.reference,
    );

    values.addAll({
      'keyVerse': widget.chapter.keyVerse,
      'summary': widget.chapter.summary,
      'observation': widget.chapter.observation,
      'interpretation': widget.chapter.interpretation,
      'lessons': widget.chapter.lessons,
      'application': widget.chapter.application,
      'questions': widget.chapter.questions,
      'prayer': widget.chapter.prayer,
      'character': widget.chapter.character,
      'characterLessons': widget.chapter.characterLessons,
    });

    reference.addListener(() {
      widget.chapter.reference = reference.text;
      widget.onChanged();
    });
  }

  void updateValue(String key, String value) {
    values[key] = value;

    switch (key) {
      case 'keyVerse':
        widget.chapter.keyVerse = value;
      case 'summary':
        widget.chapter.summary = value;
      case 'observation':
        widget.chapter.observation = value;
      case 'interpretation':
        widget.chapter.interpretation = value;
      case 'lessons':
        widget.chapter.lessons = value;
      case 'application':
        widget.chapter.application = value;
      case 'questions':
        widget.chapter.questions = value;
      case 'prayer':
        widget.chapter.prayer = value;
      case 'character':
        widget.chapter.character = value;
      case 'characterLessons':
        widget.chapter.characterLessons = value;
    }

    widget.onChanged();
  }

  @override
  void dispose() {
    reference.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Chapter ${widget.index + 1}',
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                if (widget.onRemove != null)
                  IconButton(
                    tooltip: 'Remove chapter',
                    onPressed: widget.onRemove,
                    icon: const Icon(Icons.close),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: reference,
              decoration: const InputDecoration(
                labelText: 'Bible reference',
                hintText: 'Matthew 5',
                prefixIcon:
                    Icon(Icons.menu_book_outlined),
              ),
            ),
            const SizedBox(height: 20),
            ...fieldTitles.entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 18),
                child: RichStudyField(
                  title: entry.value,
                  initialDelta: values[entry.key] ?? '',
                  onChanged: (value) =>
                      updateValue(entry.key, value),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilterChip(
                  selected: widget.chapter.bookmark,
                  label: const Text('Bookmark'),
                  avatar: const Icon(
                    Icons.bookmark_outline,
                    size: 17,
                  ),
                  onSelected: (value) {
                    setState(() {
                      widget.chapter.bookmark = value;
                    });
                    widget.onChanged();
                  },
                ),
                FilterChip(
                  selected: widget.chapter.favorite,
                  label: const Text('Favorite'),
                  avatar: const Icon(
                    Icons.star_outline,
                    size: 17,
                  ),
                  onSelected: (value) {
                    setState(() {
                      widget.chapter.favorite = value;
                    });
                    widget.onChanged();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RichStudyField extends StatefulWidget {
  final String title;
  final String initialDelta;
  final ValueChanged<String> onChanged;

  const RichStudyField({
    super.key,
    required this.title,
    required this.initialDelta,
    required this.onChanged,
  });

  @override
  State<RichStudyField> createState() =>
      _RichStudyFieldState();
}

class _RichStudyFieldState
    extends State<RichStudyField> {
  late final QuillController controller;
  late final FocusNode focusNode;
  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();

    focusNode = FocusNode();
    scrollController = ScrollController();

    controller = QuillController.basic();

    if (widget.initialDelta.trim().isNotEmpty) {
      try {
        controller.document = Document.fromJson(
          jsonDecode(widget.initialDelta),
        );
      } catch (_) {
        final plain = widget.initialDelta;
        controller.document = Document.fromJson(
          jsonDecode(plainToDelta(plain)),
        );
      }
    }

    controller.addListener(_changed);
  }

  void _changed() {
    widget.onChanged(
      jsonEncode(
        controller.document.toDelta().toJson(),
      ),
    );
  }

  @override
  void dispose() {
    controller.removeListener(_changed);
    controller.dispose();
    focusNode.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPrayer = widget.title == 'Prayer';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title.toUpperCase(),
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.05,
            color: Theme.of(context)
                .colorScheme
                .onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 7),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Theme.of(context).dividerColor,
            ),
          ),
          child: Column(
            children: [
              Material(
                color: Theme.of(context)
                    .colorScheme
                    .surfaceContainerHighest,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(18),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 3,
                  ),
                  child: QuillSimpleToolbar(
                    controller: controller,
                    config: const QuillSimpleToolbarConfig(
                      multiRowsDisplay: false,
                      toolbarSize: 42,
                      showFontFamily: false,
                      showFontSize: false,
                      showColorButton: true,
                      showBackgroundColorButton: true,
                      showAlignmentButtons: false,
                      showHeaderStyle: false,
                      showListNumbers: true,
                      showListBullets: true,
                      showListCheck: false,
                      showCodeBlock: false,
                      showQuote: false,
                      showIndent: false,
                      showLink: false,
                      showSearchButton: false,
                      showSubscript: false,
                      showSuperscript: false,
                      showClipboardCut: false,
                      showClipboardCopy: false,
                      showClipboardPaste: false,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: isPrayer ? 150 : 125,
                child: QuillEditor.basic(
                  controller: controller,
                  config: const QuillEditorConfig(
                    padding: EdgeInsets.fromLTRB(
                      14,
                      12,
                      14,
                      12,
                    ),
                    autoFocus: false,
                    expands: false,
                    scrollable: true,
                    showCursor: true,
                    enableInteractiveSelection: true,
                    enableSelectionToolbar: true,
                    placeholder: 'Write your thoughts...',
                    textInputAction:
                        TextInputAction.newline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// CALENDAR
// -----------------------------------------------------------------------------

class CalendarScreen extends StatefulWidget {
  final StudyStore store;

  const CalendarScreen({
    super.key,
    required this.store,
  });

  @override
  State<CalendarScreen> createState() =>
      _CalendarScreenState();
}

class _CalendarScreenState
    extends State<CalendarScreen> {
  DateTime month = DateTime(
    DateTime.now().year,
    DateTime.now().month,
  );

  @override
  Widget build(BuildContext context) {
    final first = DateTime(
      month.year,
      month.month,
      1,
    );

    final daysInMonth = DateTime(
      month.year,
      month.month + 1,
      0,
    ).day;

    final offset = first.weekday - 1;

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        20,
        18,
        20,
        30,
      ),
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Calendar',
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  month = DateTime(
                    month.year,
                    month.month - 1,
                  );
                });
              },
              icon: const Icon(Icons.chevron_left),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  month = DateTime(
                    month.year,
                    month.month + 1,
                  );
                });
              },
              icon: const Icon(Icons.chevron_right),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          '${monthName(month.month)} ${month.year}',
          style: TextStyle(
            color: Theme.of(context)
                .colorScheme
                .onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 18),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: GridView.count(
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(),
              crossAxisCount: 7,
              mainAxisSpacing: 7,
              crossAxisSpacing: 5,
              children: [
                for (final label in [
                  'M',
                  'T',
                  'W',
                  'T',
                  'F',
                  'S',
                  'S',
                ])
                  Center(
                    child: Text(
                      label,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                for (int i = 0; i < offset; i++)
                  const SizedBox(),
                for (int dayNumber = 1;
                    dayNumber <= daysInMonth;
                    dayNumber++)
                  _CalendarDay(
                    date: DateTime(
                      month.year,
                      month.month,
                      dayNumber,
                    ),
                    studied: widget.store.studies
                        .containsKey(
                      dateKey(
                        DateTime(
                          month.year,
                          month.month,
                          dayNumber,
                        ),
                      ),
                    ),
                    onTap: () {
                      final date = DateTime(
                        month.year,
                        month.month,
                        dayNumber,
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              DailyStudyScreen(
                            store: widget.store,
                            initialDate: date,
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CalendarDay extends StatelessWidget {
  final DateTime date;
  final bool studied;
  final VoidCallback onTap;

  const _CalendarDay({
    required this.date,
    required this.studied,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final today =
        dateKey(date) == dateKey(DateTime.now());

    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: onTap,
      child: Center(
        child: Container(
          width: 38,
          height: 38,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: studied
                ? AppColors.sage
                : today
                    ? Theme.of(context)
                        .colorScheme
                        .surfaceContainerHighest
                    : null,
            border: today
                ? Border.all(
                    color: AppColors.forest,
                    width: 1.5,
                  )
                : null,
          ),
          child: Text(
            '${date.day}',
            style: TextStyle(
              fontWeight:
                  studied || today
                      ? FontWeight.w800
                      : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// STATS
// -----------------------------------------------------------------------------

class StatsScreen extends StatelessWidget {
  final StudyStore store;

  const StatsScreen({
    super.key,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    final ntPercent = totalNtChapters == 0
        ? 0.0
        : store.readChapters / totalNtChapters;

    final mostStudiedBooks =
        <String, int>{};

    for (final day in store.studies.values) {
      for (final chapter in day.chapters) {
        final reference =
            chapter.reference.trim();

        if (reference.isEmpty) continue;

        final book = bibleBooks.keys.firstWhere(
          (b) => reference.startsWith(b),
          orElse: () => '',
        );

        if (book.isNotEmpty) {
          mostStudiedBooks[book] =
              (mostStudiedBooks[book] ?? 0) + 1;
        }
      }
    }

    final sorted =
        mostStudiedBooks.entries.toList()
          ..sort(
            (a, b) =>
                b.value.compareTo(a.value),
          );

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        20,
        18,
        20,
        30,
      ),
      children: [
        const Text(
          'Your Stats',
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 18),
        GridView.count(
          shrinkWrap: true,
          physics:
              const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.45,
          children: [
            _StatCard(
              icon: Icons.calendar_today_outlined,
              value: '${store.studyDays}',
              label: 'Study days',
            ),
            _StatCard(
              icon: Icons.menu_book_outlined,
              value: '${store.chaptersStudied}',
              label: 'Chapters studied',
            ),
            _StatCard(
              icon: Icons.local_fire_department_outlined,
              value: '${store.streak}',
              label: 'Current streak',
            ),
            _StatCard(
              icon: Icons.auto_stories_outlined,
              value: '${store.completedBooks}',
              label: 'Books completed',
            ),
          ],
        ),
        const SizedBox(height: 22),
        const _SectionLabel('NEW TESTAMENT'),
        const SizedBox(height: 10),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  '${store.readChapters} / $totalNtChapters chapters',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: ntPercent,
                  minHeight: 8,
                ),
                const SizedBox(height: 7),
                Text(
                  '${(ntPercent * 100).round()}% complete',
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 22),
        const _SectionLabel('MOST STUDIED'),
        const SizedBox(height: 8),
        if (sorted.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(18),
              child: Text(
                'Your most studied books will appear here.',
              ),
            ),
          )
        else
          ...sorted.take(8).map(
                (e) => ListTile(
                  title: Text(
                    e.key,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  trailing: Text(
                    '${e.value}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.forestLight),
            const Spacer(),
            Text(
              value,
              style: const TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context)
                    .colorScheme
                    .onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// TRACKER
// -----------------------------------------------------------------------------

class TrackerScreen extends StatefulWidget {
  final StudyStore store;

  const TrackerScreen({
    super.key,
    required this.store,
  });

  @override
  State<TrackerScreen> createState() =>
      _TrackerScreenState();
}

class _TrackerScreenState
    extends State<TrackerScreen> {
  String search = '';

  @override
  Widget build(BuildContext context) {
    final filtered = bibleBooks.entries
        .where(
          (e) => e.key
              .toLowerCase()
              .contains(search.toLowerCase()),
        )
        .toList();

    final percent = totalNtChapters == 0
        ? 0.0
        : widget.store.readChapters /
            totalNtChapters;

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Testament Tracker'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          18,
          8,
          18,
          30,
        ),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Reading progress',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    '${widget.store.readChapters} of $totalNtChapters chapters',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: percent,
                    minHeight: 8,
                  ),
                  const SizedBox(height: 7),
                  Text(
                    '${(percent * 100).round()}% complete',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            onChanged: (value) =>
                setState(() => search = value),
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Find a book...',
            ),
          ),
          const SizedBox(height: 12),
          ...filtered.map(
            (entry) => Card(
              child: ExpansionTile(
                title: Text(
                  entry.key,
                  style: const TextStyle(
                    fontWeight: FontWeight.w750,
                  ),
                ),
                subtitle: Text(
                  '${widget.store.reading[entry.key]?.length ?? 0} / ${entry.value} chapters',
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      16,
                      0,
                      16,
                      18,
                    ),
                    child: Wrap(
                      spacing: 7,
                      runSpacing: 7,
                      children: List.generate(
                        entry.value,
                        (index) {
                          final chapter = index + 1;
                          final selected =
                              widget.store.isRead(
                            entry.key,
                            chapter,
                          );

                          return FilterChip(
                            selected: selected,
                            label: Text('$chapter'),
                            onSelected: (_) async {
                              await widget.store
                                  .toggleChapter(
                                entry.key,
                                chapter,
                              );
                              setState(() {});
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// SEARCH
// -----------------------------------------------------------------------------

class SearchScreen extends StatefulWidget {
  final StudyStore store;

  const SearchScreen({
    super.key,
    required this.store,
  });

  @override
  State<SearchScreen> createState() =>
      _SearchScreenState();
}

class _SearchScreenState
    extends State<SearchScreen> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    final results = widget.store.studies.values
        .where((day) {
          if (query.trim().isEmpty) return true;

          final blob = jsonEncode(day.toJson())
              .toLowerCase();

          return blob.contains(
            query.toLowerCase(),
          );
        })
        .toList()
      ..sort(
        (a, b) => b.date.compareTo(a.date),
      );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Studies'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              16,
              4,
              16,
              12,
            ),
            child: TextField(
              autofocus: true,
              onChanged: (value) =>
                  setState(() => query = value),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText:
                    'Search verses, notes, people...',
              ),
            ),
          ),
          Expanded(
            child: results.isEmpty
                ? const Center(
                    child: Text(
                      'No matching studies.',
                    ),
                  )
                : ListView(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    children: results
                        .map(
                          (day) => _RecentStudyTile(
                            day: day,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      DailyStudyScreen(
                                    store: widget.store,
                                    initialDate:
                                        day.date,
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// BOOKMARKS / FAVORITES
// -----------------------------------------------------------------------------

class LibraryScreen extends StatelessWidget {
  final StudyStore store;
  final bool favoritesOnly;

  const LibraryScreen({
    super.key,
    required this.store,
    required this.favoritesOnly,
  });

  @override
  Widget build(BuildContext context) {
    final matching = <StudyDay>[];

    for (final day in store.studies.values) {
      if (day.chapters.any(
        (chapter) => favoritesOnly
            ? chapter.favorite
            : chapter.bookmark,
      )) {
        matching.add(day);
      }
    }

    matching.sort(
      (a, b) => b.date.compareTo(a.date),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          favoritesOnly
              ? 'Favorites'
              : 'Bookmarks',
        ),
      ),
      body: matching.isEmpty
          ? Center(
              child: Text(
                favoritesOnly
                    ? 'No favorite studies yet.'
                    : 'No bookmarked studies yet.',
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: matching
                  .map(
                    (day) => _RecentStudyTile(
                      day: day,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                DailyStudyScreen(
                              store: store,
                              initialDate:
                                  day.date,
                            ),
                          ),
                        );
                      },
                    ),
                  )
                  .toList(),
            ),
    );
  }
}

// -----------------------------------------------------------------------------
// CHARACTER LIBRARY
// -----------------------------------------------------------------------------

class CharacterLibraryScreen
    extends StatelessWidget {
  final StudyStore store;

  const CharacterLibraryScreen({
    super.key,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    final map =
        <String, int>{};

    for (final day in store.studies.values) {
      for (final chapter in day.chapters) {
        final plain =
            deltaToPlain(chapter.character);

        for (final name
            in plain.split(RegExp(r'[,;\n]'))) {
          final clean = name.trim();
          if (clean.isEmpty) continue;
          map[clean] =
              (map[clean] ?? 0) + 1;
        }
      }
    }

    final names = map.keys.toList()..sort();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Character Library'),
      ),
      body: names.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Characters added in Character Study will appear here.',
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: names
                  .map(
                    (name) => Card(
                      child: ListTile(
                        leading:
                            const CircleAvatar(
                          child: Icon(
                            Icons.person_outline,
                          ),
                        ),
                        title: Text(
                          name,
                          style:
                              const TextStyle(
                            fontWeight:
                                FontWeight.w750,
                          ),
                        ),
                        subtitle: Text(
                          '${map[name]} study entries',
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
    );
  }
}

// -----------------------------------------------------------------------------
// SETTINGS
// -----------------------------------------------------------------------------

class SettingsScreen extends StatelessWidget {
  final StudyStore store;

  const SettingsScreen({
    super.key,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: SwitchListTile(
              value: store.darkMode,
              onChanged: store.setDarkMode,
              secondary: const Icon(
                Icons.dark_mode_outlined,
              ),
              title: const Text(
                'Dark mode',
                style: TextStyle(
                  fontWeight: FontWeight.w750,
                ),
              ),
              subtitle: const Text(
                'Use the darker theme for evening study.',
              ),
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: ListTile(
              leading:
                  const Icon(Icons.info_outline),
              title: const Text(
                'Bitaniya Bible Study',
                style: TextStyle(
                  fontWeight: FontWeight.w750,
                ),
              ),
              subtitle:
                  const Text('Version 2.0'),
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// BACKUP
// -----------------------------------------------------------------------------

class BackupScreen extends StatefulWidget {
  final StudyStore store;

  const BackupScreen({
    super.key,
    required this.store,
  });

  @override
  State<BackupScreen> createState() =>
      _BackupScreenState();
}

class _BackupScreenState
    extends State<BackupScreen> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> create() async {
    controller.text =
        await widget.store.createBackup();
    setState(() {});
  }

  Future<void> restore() async {
    try {
      await widget.store.restoreBackup(
        controller.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Backup restored successfully.',
          ),
        ),
      );
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'This backup could not be read.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        20,
        18,
        20,
        30,
      ),
      children: [
        const Text(
          'Backup & Restore',
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Protect your studies and reading progress.',
          style: TextStyle(
            color: Theme.of(context)
                .colorScheme
                .onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 20),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const _SectionLabel(
                  'CREATE BACKUP',
                ),
                const SizedBox(height: 8),
                const Text(
                  'Create a portable JSON copy of your studies, bookmarks, favorites and tracker.',
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: create,
                  icon: const Icon(
                    Icons.download_outlined,
                  ),
                  label:
                      const Text('Create backup'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const _SectionLabel(
                  'BACKUP DATA',
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: controller,
                  minLines: 8,
                  maxLines: 14,
                  decoration:
                      const InputDecoration(
                    hintText:
                        'Backup JSON appears here. Paste backup JSON here when restoring.',
                  ),
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: restore,
                  icon:
                      const Icon(Icons.restore),
                  label:
                      const Text('Restore backup'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
