import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BitaniyaBibleStudyApp());
}

// -----------------------------------------------------------------------------
// THEME & MODELS
// -----------------------------------------------------------------------------

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF6A1B9A),
      primary: const Color(0xFF6A1B9A),
      secondary: const Color(0xFFAB47BC),
      surface: const Color(0xFFF9F6F0),
    ),
    scaffoldBackgroundColor: const Color(0xFFF4F0EA),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFF9F6F0),
      foregroundColor: Color(0xFF3E2723),
      elevation: 0,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFBA68C8),
      brightness: Brightness.dark,
      primary: const Color(0xFFBA68C8),
      secondary: const Color(0xFFCE93D8),
      surface: const Color(0xFF121212),
    ),
    scaffoldBackgroundColor: const Color(0xFF181818),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF121212),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
  );
}

class ChapterEntry {
  String chapter;
  
  // Study fields
  String keyVerse;
  String summary;
  String observations;
  String meaning;
  String lessons;
  String application;
  String questions;
  String prayer;

  // Rich text counterparts (Delta JSON strings)
  String summaryRich;
  String observationsRich;
  String meaningRich;
  String lessonsRich;
  String applicationRich;
  String questionsRich;
  String prayerRich;

  // Character study fields
  String characterName;
  String characterWho;
  String characterTraits;
  String characterActions;
  String characterLessons;

  bool bookmarked;
  bool favorite;

  ChapterEntry({
    required this.chapter,
    this.keyVerse = '',
    this.summary = '',
    this.observations = '',
    this.meaning = '',
    this.lessons = '',
    this.application = '',
    this.questions = '',
    this.prayer = '',
    this.summaryRich = '',
    this.observationsRich = '',
    this.meaningRich = '',
    this.lessonsRich = '',
    this.applicationRich = '',
    this.questionsRich = '',
    this.prayerRich = '',
    this.characterName = '',
    this.characterWho = '',
    this.characterTraits = '',
    this.characterActions = '',
    this.characterLessons = '',
    this.bookmarked = false,
    this.favorite = false,
  });

  Map<String, dynamic> toJson() => {
    'chapter': chapter,
    'keyVerse': keyVerse,
    'summary': summary,
    'observations': observations,
    'meaning': meaning,
    'lessons': lessons,
    'application': application,
    'questions': questions,
    'prayer': prayer,
    'summaryRich': summaryRich,
    'observationsRich': observationsRich,
    'meaningRich': meaningRich,
    'lessonsRich': lessonsRich,
    'applicationRich': applicationRich,
    'questionsRich': questionsRich,
    'prayerRich': prayerRich,
    'characterName': characterName,
    'characterWho': characterWho,
    'characterTraits': characterTraits,
    'characterActions': characterActions,
    'characterLessons': characterLessons,
    'bookmarked': bookmarked,
    'favorite': favorite,
  };

  factory ChapterEntry.fromJson(Map<String, dynamic> json) => ChapterEntry(
    chapter: json['chapter'] ?? '',
    keyVerse: json['keyVerse'] ?? '',
    summary: json['summary'] ?? '',
    observations: json['observations'] ?? '',
    meaning: json['meaning'] ?? '',
    lessons: json['lessons'] ?? '',
    application: json['application'] ?? '',
    questions: json['questions'] ?? '',
    prayer: json['prayer'] ?? '',
    summaryRich: json['summaryRich'] ?? '',
    observationsRich: json['observationsRich'] ?? '',
    meaningRich: json['meaningRich'] ?? '',
    lessonsRich: json['lessonsRich'] ?? '',
    applicationRich: json['applicationRich'] ?? '',
    questionsRich: json['questionsRich'] ?? '',
    prayerRich: json['prayerRich'] ?? '',
    characterName: json['characterName'] ?? '',
    characterWho: json['characterWho'] ?? '',
    characterTraits: json['characterTraits'] ?? '',
    characterActions: json['characterActions'] ?? '',
    characterLessons: json['characterLessons'] ?? '',
    bookmarked: json['bookmarked'] ?? false,
    favorite: json['favorite'] ?? false,
  );
}

class StudyDay {
  String dateKey; // Format: YYYY-MM-DD
  List<ChapterEntry> chapters;

  StudyDay({required this.dateKey, required this.chapters});

  Map<String, dynamic> toJson() => {
    'dateKey': dateKey,
    'chapters': chapters.map((c) => c.toJson()).toList(),
  };

  factory StudyDay.fromJson(Map<String, dynamic> json) => StudyDay(
    dateKey: json['dateKey'] ?? '',
    chapters: (json['chapters'] as List<dynamic>? ?? [])
        .map((c) => ChapterEntry.fromJson(c))
        .toList(),
  );
}

// -----------------------------------------------------------------------------
// STORAGE UTILITIES
// -----------------------------------------------------------------------------

class StudyStorage {
  static const String _storageKey = 'bitaniya_bible_study_days_v2';

  static Future<List<StudyDay>> loadStudies() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_storageKey);
    if (data == null) return [];
    try {
      final List<dynamic> decoded = jsonDecode(data);
      return decoded.map((item) => StudyDay.fromJson(item)).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> saveStudies(List<StudyDay> studies) async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(studies.map((s) => s.toJson()).toList());
    await prefs.setString(_storageKey, encoded);
  }
}

class ReadingStorage {
  static const String _readingKey = 'bitaniya_reading_tracker_v1';

  static Future<Map<String, List<String>>> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_readingKey);
    if (data == null) return {};
    try {
      final Map<String, dynamic> decoded = jsonDecode(data);
      return decoded.map((key, value) => MapEntry(key, List<String>.from(value)));
    } catch (_) {
      return {};
    }
  }

  static Future<void> saveProgress(Map<String, List<String>> progress) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_readingKey, jsonEncode(progress));
  }
}

// -----------------------------------------------------------------------------
// APP ROOT & SHELL
// -----------------------------------------------------------------------------

class BitaniyaBibleStudyApp extends StatefulWidget {
  const BitaniyaBibleStudyApp({super.key});

  @override
  State<BitaniyaBibleStudyApp> createState() => _BitaniyaBibleStudyAppState();

  static _BitaniyaBibleStudyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_BitaniyaBibleStudyAppState>()!;
}

class _BitaniyaBibleStudyAppState extends State<BitaniyaBibleStudyApp> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('is_dark_mode') ?? false;
    });
  }

  void toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = !_isDarkMode;
      prefs.setBool('is_dark_mode', _isDarkMode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bitaniya Bible Study',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const AppShell(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => AppShellState();
}

class AppShellState extends State<AppShell> {
  int _currentIndex = 0;
  List<StudyDay> _studies = [];
  Map<String, List<String>> _readingProgress = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() => _isLoading = true);
    final loadedStudies = await StudyStorage.loadStudies();
    final loadedProgress = await ReadingStorage.loadProgress();
    setState(() {
      _studies = loadedStudies;
      _readingProgress = loadedProgress;
      _isLoading = false;
    });
  }

  Future<void> refreshData() async {
    await loadData();
  }

  void navigateToTab(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final screens = [
      HomeScreen(
        studies: _studies,
        readingProgress: _readingProgress,
        onDataChanged: loadData,
        onNavigateTab: navigateToTab,
      ),
      StudyManagementScreen(
        studies: _studies,
        onDataChanged: loadData,
      ),
      BackupSettingsScreen(
        studies: _studies,
        onDataChanged: loadData,
      ),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Study',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// HOME SCREEN (DASHBOARD)
// -----------------------------------------------------------------------------

class HomeScreen extends StatelessWidget {
  final List<StudyDay> studies;
  final Map<String, List<String>> readingProgress;
  final VoidCallback onDataChanged;
  final Function(int) onNavigateTab;

  const HomeScreen({
    super.key,
    required this.studies,
    required this.readingProgress,
    required this.onDataChanged,
    required this.onNavigateTab,
  });

  int get totalChaptersStudied {
    int count = 0;
    for (var day in studies) {
      count += day.chapters.length;
    }
    return count;
  }

  int get totalStudyDays => studies.length;

  int get totalNotesCount {
    int count = 0;
    for (var day in studies) {
      for (var c in day.chapters) {
        if (c.summary.isNotEmpty || c.observations.isNotEmpty || c.meaning.isNotEmpty ||
            c.lessons.isNotEmpty || c.application.isNotEmpty || c.questions.isNotEmpty || c.prayer.isNotEmpty) {
          count++;
        }
      }
    }
    return count;
  }

  int get totalFavorites {
    int count = 0;
    for (var day in studies) {
      for (var c in day.chapters) {
        if (c.favorite) count++;
      }
    }
    return count;
  }

  int get currentStreak {
    if (studies.isEmpty) return 0;
    final sortedDays = studies.map((s) => s.dateKey).toList()..sort((a, b) => b.compareTo(a));
    
    int streak = 0;
    DateTime checkDate = DateTime.now();
    String todayKey = "${checkDate.year}-${checkDate.month.toString().padLeft(2, '0')}-${checkDate.day.toString().padLeft(2, '0')}";
    String yesterdayKey = "${checkDate.subtract(const Duration(days: 1)).year}-${checkDate.subtract(const Duration(days: 1)).month.toString().padLeft(2, '0')}-${checkDate.subtract(const Duration(days: 1)).day.toString().padLeft(2, '0')}";

    if (!sortedDays.contains(todayKey) && !sortedDays.contains(yesterdayKey)) {
      return 0;
    }

    DateTime currentDate = sortedDays.contains(todayKey) ? DateTime.parse(todayKey) : DateTime.parse(yesterdayKey);
    
    while (true) {
      String key = "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}";
      if (sortedDays.contains(key)) {
        streak++;
        currentDate = currentDate.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    return streak;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final todayKey = "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bitaniya Bible Study', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(BitaniyaBibleStudyApp.of(context)._isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => BitaniyaBibleStudyApp.of(context).toggleTheme(),
            tooltip: 'Toggle Theme',
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SearchStudiesScreen(studies: studies)),
            ),
            tooltip: 'Search Studies',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Today Card / Continue Study Banner
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: theme.colorScheme.primaryContainer.withOpacity(0.4),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.between,
                    children: [
                      Text('Today', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
                      Row(
                        children: [
                          const Icon(Icons.local_fire_department, color: Colors.orange, size: 20),
                          const SizedBox(width: 4),
                          Text('$currentStreak-day streak', style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text('Continue Your Daily Journey', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  const Text('Study Scripture, record revelations, and draw closer to God today.'),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DailyStudyScreen(dateKey: todayKey, onDataChanged: onDataChanged),
                        ),
                      );
                    },
                    icon: const Icon(Icons.menu_book),
                    label: const Text('Continue Where You Left Off'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Statistics Grid
          const Text('Study Statistics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: [
              _buildStatCard(context, 'Chapters Studied', '$totalChaptersStudied', Icons.menu_book, Colors.blue),
              _buildStatCard(context, 'Study Days', '$totalStudyDays', Icons.calendar_today, Colors.green),
              _buildStatCard(context, 'Study Notes', '$totalNotesCount', Icons.note_alt, Colors.purple),
              _buildStatCard(context, 'Favorites', '$totalFavorites', Icons.star, Colors.amber),
            ],
          ),
          const SizedBox(height: 24),

          // Quick Shortcuts Row
          const Text('Quick Navigation', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildShortcutButton(context, 'Bookmarks', Icons.bookmark, () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => BookmarksScreen(studies: studies, onDataChanged: onDataChanged)));
              }),
              _buildShortcutButton(context, 'Favorites', Icons.star, () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => FavoritesScreen(studies: studies, onDataChanged: onDataChanged)));
              }),
              _buildShortcutButton(context, 'Calendar', Icons.calendar_month, () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => StudyCalendarScreen(studies: studies, onDataChanged: onDataChanged)));
              }),
              _buildShortcutButton(context, 'Characters', Icons.people, () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => CharacterLibraryScreen(studies: studies)));
              }),
            ],
          ),
          const SizedBox(height: 24),

          // Reading Tracker Widget
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.between,
                    children: [
                      const Text('Bible Reading Tracker', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => ReadingTrackerScreen(progress: readingProgress, onDataChanged: onDataChanged)),
                          );
                        },
                        child: const Text('Manage Tracker'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text('Track New Testament chapters completed and overall progress.'),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: _calculateTotalReadingProgress(readingProgress),
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  const SizedBox(height: 8),
                  Text('${(_calculateTotalReadingProgress(readingProgress) * 100).toStringAsFixed(1)}% of New Testament completed',
                      style: TextStyle(color: theme.colorScheme.secondary, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Expanded(child: Text(title, style: const TextStyle(fontSize: 13, color: Colors.grey), overflow: TextOverflow.ellipsis)),
              ],
            ),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildShortcutButton(BuildContext context, String label, IconData icon, VoidCallback onTap) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Icon(icon, color: theme.colorScheme.primary),
            ),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  double _calculateTotalReadingProgress(Map<String, List<String>> progress) {
    const ntBooks = {
      'Matthew': 28, 'Mark': 16, 'Luke': 24, 'John': 21, 'Acts': 28,
      'Romans': 16, '1 Corinthians': 16, '2 Corinthians': 13, 'Galatians': 6,
      'Ephesians': 6, 'Philippians': 4, 'Colossians': 4, '1 Thessalonians': 5,
      '2 Thessalonians': 3, '1 Timothy': 6, '2 Timothy': 4, 'Titus': 3,
      'Philemon': 1, 'Hebrews': 13, 'James': 5, '1 Peter': 5, '2 Peter': 3,
      '1 John': 5, '2 John': 1, '3 John': 1, 'Jude': 1, 'Revelation': 22
    };

    int totalChapters = 0;
    int completedChapters = 0;

    ntBooks.forEach((book, count) {
      totalChapters += count;
      final readList = progress[book] ?? [];
      completedChapters += readList.length;
    });

    if (totalChapters == 0) return 0.0;
    return completedChapters / totalChapters;
  }
}

// -----------------------------------------------------------------------------
// STUDY MANAGEMENT SCREEN (STUDY TAB)
// -----------------------------------------------------------------------------

class StudyManagementScreen extends StatelessWidget {
  final List<StudyDay> studies;
  final VoidCallback onDataChanged;

  const StudyManagementScreen({super.key, required this.studies, required this.onDataChanged});

  @override
  Widget build(BuildContext context) {
    final todayKey = "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bible Studies', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => StudyCalendarScreen(studies: studies, onDataChanged: onDataChanged))),
            tooltip: 'Study Calendar',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => DailyStudyScreen(dateKey: todayKey, onDataChanged: onDataChanged)),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Start / Open Today\'s Study'),
            style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
          ),
          const SizedBox(height: 20),
          const Text('All Recorded Study Days', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          studies.isEmpty
              ? const Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Center(child: Text('No studies recorded yet. Tap above to begin!')),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: studies.length,
                  itemBuilder: (context, index) {
                    final day = studies[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        leading: const CircleAvatar(child: Icon(Icons.menu_book)),
                        title: Text('Date: ${day.dateKey}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Chapters studied: ${day.chapters.map((c) => c.chapter).join(', ')}'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => DailyStudyScreen(dateKey: day.dateKey, onDataChanged: onDataChanged)),
                          );
                        },
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// DAILY STUDY SCREEN (WRITING & STUDYING)
// -----------------------------------------------------------------------------

class DailyStudyScreen extends StatefulWidget {
  final String dateKey;
  final VoidCallback onDataChanged;

  const DailyStudyScreen({super.key, required this.dateKey, required this.onDataChanged});

  @override
  State<DailyStudyScreen> createState() => _DailyStudyScreenState();
}

class _DailyStudyScreenState extends State<DailyStudyScreen> {
  StudyDay? _studyDay;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDayData();
  }

  Future<void> _loadDayData() async {
    final studies = await StudyStorage.loadStudies();
    try {
      final found = studies.firstWhere((s) => s.dateKey == widget.dateKey);
      setState(() {
        _studyDay = found;
        _isLoading = false;
      });
    } catch (_) {
      setState(() {
        _studyDay = StudyDay(dateKey: widget.dateKey, chapters: []);
        _isLoading = false;
      });
    }
  }

  Future<void> _saveDayData() async {
    if (_studyDay == null) return;
    final studies = await StudyStorage.loadStudies();
    studies.removeWhere((s) => s.dateKey == widget.dateKey);
    if (_studyDay!.chapters.isNotEmpty) {
      studies.add(_studyDay!);
    }
    await StudyStorage.saveStudies(studies);
    widget.onDataChanged();
  }

  void _addChapter() {
    showDialog(
      context: builderChapterDialog(context, (chapterName) {
        if (chapterName.isNotEmpty) {
          setState(() {
            _studyDay!.chapters.add(ChapterEntry(chapter: chapterName));
          });
          _saveDayData();
        }
      }),
    );
  }

  Widget builderChapterDialog(BuildContext context, Function(String) onAdded) {
    final controller = TextEditingController();
    return AlertDialog(
      title: const Text('Add Chapter to Study'),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(hintText: 'e.g., John 3 or Romans 8'),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            onAdded(controller.text.trim());
          },
          child: const Text('Add'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Study: ${widget.dateKey}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addChapter,
            tooltip: 'Add Chapter',
          ),
        ],
      ),
      body: _studyDay!.chapters.isEmpty
          .toString() == 'true' && _studyDay!.chapters.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No chapters added for this date yet.'),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _addChapter,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Chapter'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _studyDay!.chapters.length,
              itemBuilder: (context, index) {
                final chapter = _studyDay!.chapters[index];
                return ChapterCard(
                  chapterEntry: chapter,
                  onChanged: () {
                    _saveDayData();
                    setState(() {});
                  },
                  onDelete: () {
                    setState(() {
                      _studyDay!.chapters.removeAt(index);
                    });
                    _saveDayData();
                  },
                );
              },
            ),
    );
  }
}

class ChapterCard extends StatefulWidget {
  final ChapterEntry chapterEntry;
  final VoidCallback onChanged;
  final VoidCallback onDelete;

  const ChapterCard({
    super.key,
    required this.chapterEntry,
    required this.onChanged,
    required this.onDelete,
  });

  @override
  State<ChapterCard> createState() => _ChapterCardState();
}

class _ChapterCardState extends State<ChapterCard> {
  late TextEditingController _keyVerseController;
  
  // Rich Quill controllers
  late quill.QuillController _summaryController;
  late quill.QuillController _observationsController;
  late quill.QuillController _meaningController;
  late quill.QuillController _lessonsController;
  late quill.QuillController _applicationController;
  late quill.QuillController _questionsController;
  late quill.QuillController _prayerController;

  // Character controllers
  late TextEditingController _charNameController;
  late TextEditingController _charWhoController;
  late TextEditingController _charTraitsController;
  late TextEditingController _charActionsController;
  late TextEditingController _charLessonsController;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _keyVerseController = TextEditingController(text: widget.chapterEntry.keyVerse);
    _keyVerseController.addListener(() {
      widget.chapterEntry.keyVerse = _keyVerseController.text;
      widget.onChanged();
    });

    _summaryController = _initQuill(widget.chapterEntry.summaryRich, widget.chapterEntry.summary);
    _observationsController = _initQuill(widget.chapterEntry.observationsRich, widget.chapterEntry.observations);
    _meaningController = _initQuill(widget.chapterEntry.meaningRich, widget.chapterEntry.meaning);
    _lessonsController = _initQuill(widget.chapterEntry.lessonsRich, widget.chapterEntry.lessons);
    _applicationController = _initQuill(widget.chapterEntry.applicationRich, widget.chapterEntry.application);
    _questionsController = _initQuill(widget.chapterEntry.questionsRich, widget.chapterEntry.questions);
    _prayerController = _initQuill(widget.chapterEntry.prayerRich, widget.chapterEntry.prayer);

    _summaryController.addListener(() {
      widget.chapterEntry.summaryRich = jsonEncode(_summaryController.document.toDelta().toJson());
      widget.chapterEntry.summary = _summaryController.document.toPlainText();
      widget.onChanged();
    });
    _observationsController.addListener(() {
      widget.chapterEntry.observationsRich = jsonEncode(_observationsController.document.toDelta().toJson());
      widget.chapterEntry.observations = _observationsController.document.toPlainText();
      widget.onChanged();
    });
    _meaningController.addListener(() {
      widget.chapterEntry.meaningRich = jsonEncode(_meaningController.document.toDelta().toJson());
      widget.chapterEntry.meaning = _meaningController.document.toPlainText();
      widget.onChanged();
    });
    _lessonsController.addListener(() {
      widget.chapterEntry.lessonsRich = jsonEncode(_lessonsController.document.toDelta().toJson());
      widget.chapterEntry.lessons = _lessonsController.document.toPlainText();
      widget.onChanged();
    });
    _applicationController.addListener(() {
      widget.chapterEntry.applicationRich = jsonEncode(_applicationController.document.toDelta().toJson());
      widget.chapterEntry.application = _applicationController.document.toPlainText();
      widget.onChanged();
    });
    _questionsController.addListener(() {
      widget.chapterEntry.questionsRich = jsonEncode(_questionsController.document.toDelta().toJson());
      widget.chapterEntry.questions = _questionsController.document.toPlainText();
      widget.onChanged();
    });
    _prayerController.addListener(() {
      widget.chapterEntry.prayerRich = jsonEncode(_prayerController.document.toDelta().toJson());
      widget.chapterEntry.prayer = _prayerController.document.toPlainText();
      widget.onChanged();
    });

    _charNameController = TextEditingController(text: widget.chapterEntry.characterName);
    _charWhoController = TextEditingController(text: widget.chapterEntry.characterWho);
    _charTraitsController = TextEditingController(text: widget.chapterEntry.characterTraits);
    _charActionsController = TextEditingController(text: widget.chapterEntry.characterActions);
    _charLessonsController = TextEditingController(text: widget.chapterEntry.characterLessons);

    for (var c in [_charNameController, _charWhoController, _charTraitsController, _charActionsController, _charLessonsController]) {
      c.addListener(() {
        widget.chapterEntry.characterName = _charNameController.text;
        widget.chapterEntry.characterWho = _charWhoController.text;
        widget.chapterEntry.characterTraits = _charTraitsController.text;
        widget.chapterEntry.characterActions = _charActionsController.text;
        widget.chapterEntry.characterLessons = _charLessonsController.text;
        widget.onChanged();
      });
    }
  }

  quill.QuillController _initQuill(String richJson, String plainFallback) {
    if (richJson.isNotEmpty) {
      try {
        return quill.QuillController(
          document: quill.Document.fromJson(jsonDecode(richJson)),
          selection: const TextSelection.collapsed(offset: 0),
        );
      } catch (_) {}
    }
    final doc = quill.Document()..insert(0, plainFallback);
    return quill.QuillController(
      document: doc,
      selection: const TextSelection.collapsed(offset: 0),
    );
  }

  @override
  void dispose() {
    _keyVerseController.dispose();
    _summaryController.dispose();
    _observationsController.dispose();
    _meaningController.dispose();
    _lessonsController.dispose();
    _applicationController.dispose();
    _questionsController.dispose();
    _prayerController.dispose();
    _charNameController.dispose();
    _charWhoController.dispose();
    _charTraitsController.dispose();
    _charActionsController.dispose();
    _charLessonsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.chapterEntry.chapter,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
                  ),
                ),
                IconButton(
                  icon: Icon(widget.chapterEntry.bookmarked ? Icons.bookmark : Icons.bookmark_border,
                      color: widget.chapterEntry.bookmarked ? Colors.blue : null),
                  onPressed: () {
                    setState(() {
                      widget.chapterEntry.bookmarked = !widget.chapterEntry.bookmarked;
                    });
                    widget.onChanged();
                  },
                  tooltip: 'Bookmark',
                ),
                IconButton(
                  icon: Icon(widget.chapterEntry.favorite ? Icons.star : Icons.star_border,
                      color: widget.chapterEntry.favorite ? Colors.amber : null),
                  onPressed: () {
                    setState(() {
                      widget.chapterEntry.favorite = !widget.chapterEntry.favorite;
                    });
                    widget.onChanged();
                  },
                  tooltip: 'Favorite',
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: widget.onDelete,
                  tooltip: 'Delete Chapter',
                ),
              ],
            ),
            const Divider(),
            TextField(
              controller: _keyVerseController,
              decoration: const InputDecoration(
                labelText: 'Key Verse / Verse Reference',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ExpansionTile(
              title: Text(_isExpanded ? 'Collapse Full Study Sections' : 'Expand Full Study & Character Sections'),
              initiallyExpanded: _isExpanded,
              onExpansionChanged: (val) => setState(() => _isExpanded = val),
              children: [
                const SizedBox(height: 10),
                _buildRichSection('Summary', _summaryController),
                _buildRichSection('Observations', _observationsController),
                _buildRichSection('Meaning', _meaningController),
                _buildRichSection('Lessons', _lessonsController),
                _buildRichSection('Application', _applicationController),
                _buildRichSection('Questions', _questionsController),
                _buildRichSection('Prayer', _prayerController),
                const Divider(height: 30),
                const Text('Character Study Section', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                TextField(controller: _charNameController, decoration: const InputDecoration(labelText: 'Character Name', border: OutlineInputBorder())),
                const SizedBox(height: 8),
                TextField(controller: _charWhoController, decoration: const InputDecoration(labelText: 'Who were they?', border: OutlineInputBorder())),
                const SizedBox(height: 8),
                TextField(controller: _charTraitsController, decoration: const InputDecoration(labelText: 'Traits', border: OutlineInputBorder())),
                const SizedBox(height: 8),
                TextField(controller: _charActionsController, decoration: const InputDecoration(labelText: 'Actions', border: OutlineInputBorder())),
                const SizedBox(height: 8),
                TextField(controller: _charLessonsController, decoration: const InputDecoration(labelText: 'Lessons Learned', border: OutlineInputBorder())),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRichSection(String title, quill.QuillController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 4),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                quill.QuillSimpleToolbar(
                  controller: controller,
                  configurations: const quill.QuillSimpleToolbarConfigurations(
                    multiRowsDisplay: false,
                    showFontFamily: false,
                    showFontSize: false,
                    showCodeBlock: false,
                    showAlignButton: false,
                    showCenterAlignment: false,
                    showRightAlignment: false,
                    showJustifyAlignment: false,
                    showDirection: false,
                  ),
                ),
                const Divider(height: 1),
                SizedBox(
                  height: 120,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: quill.QuillEditor.basic(
                      controller: controller,
                      configurations: const quill.QuillEditorConfigurations(
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// DEDICATED FEATURE SCREENS (SEARCH, BOOKMARKS, CALENDAR, ETC.)
// -----------------------------------------------------------------------------

class SearchStudiesScreen extends StatefulWidget {
  final List<StudyDay> studies;

  const SearchStudiesScreen({super.key, required this.studies});

  @override
  State<SearchStudiesScreen> createState() => _SearchStudiesScreenState();
}

class _SearchStudiesScreenState extends State<SearchStudiesScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> results = [];
    if (_query.trim().isNotEmpty) {
      final q = _query.toLowerCase();
      for (var day in widget.studies) {
        for (var c in day.chapters) {
          if (c.chapter.toLowerCase().contains(q) ||
              c.keyVerse.toLowerCase().contains(q) ||
              c.summary.toLowerCase().contains(q) ||
              c.observations.toLowerCase().contains(q) ||
              c.meaning.toLowerCase().contains(q) ||
              c.lessons.toLowerCase().contains(q) ||
              c.application.toLowerCase().contains(q) ||
              c.questions.toLowerCase().contains(q) ||
              c.prayer.toLowerCase().contains(q) ||
              c.characterName.toLowerCase().contains(q) ||
              c.characterTraits.toLowerCase().contains(q)) {
            results.add({'day': day.dateKey, 'chapter': c});
          }
        }
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Search Studies')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Search words (faith, prayer, Peter...)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (val) => setState(() => _query = val),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _query.trim().isEmpty
                  ? const Center(child: Text('Type a keyword to search all your studies.'))
                  : results.isEmpty
                      ? const Center(child: Text('No matching studies found.'))
                      : ListView.builder(
                          itemCount: results.length,
                          itemBuilder: (context, index) {
                            final item = results[index];
                            final ChapterEntry c = item['chapter'];
                            final String date = item['day'];
                            return Card(
                              child: ListTile(
                                title: Text('${c.chapter} (Study Date: $date)', style: const TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text('Key Verse: ${c.keyVerse.isEmpty ? 'None' : c.keyVerse}\nSummary: ${c.summary}', maxLines: 2, overflow: TextOverflow.ellipsis),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

class BookmarksScreen extends StatelessWidget {
  final List<StudyDay> studies;
  final VoidCallback onDataChanged;

  const BookmarksScreen({super.key, required this.studies, required this.onDataChanged});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> bookmarks = [];
    for (var day in studies) {
      for (var c in day.chapters) {
        if (c.bookmarked) {
          bookmarks.add({'day': day.dateKey, 'chapter': c});
        }
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Bookmarks')),
      body: bookmarks.isEmpty
          ? const Center(child: Text('No bookmarked chapters or sections yet.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: bookmarks.length,
              itemBuilder: (context, index) {
                final item = bookmarks[index];
                final ChapterEntry c = item['chapter'];
                final String date = item['day'];
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.bookmark, color: Colors.blue),
                    title: Text(c.chapter, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Study Date: $date\nKey Verse: ${c.keyVerse}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        c.bookmarked = false;
                        onDataChanged();
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  final List<StudyDay> studies;
  final VoidCallback onDataChanged;

  const FavoritesScreen({super.key, required this.studies, required this.onDataChanged});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> favorites = [];
    for (var day in studies) {
      for (var c in day.chapters) {
        if (c.favorite) {
          favorites.add({'day': day.dateKey, 'chapter': c});
        }
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: favorites.isEmpty
          ? const Center(child: Text('No favorite studies or chapters marked yet.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final item = favorites[index];
                final ChapterEntry c = item['chapter'];
                final String date = item['day'];
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.star, color: Colors.amber),
                    title: Text(c.chapter, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Study Date: $date\nKey Verse: ${c.keyVerse}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        c.favorite = false;
                        onDataChanged();
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class StudyCalendarScreen extends StatelessWidget {
  final List<StudyDay> studies;
  final VoidCallback onDataChanged;

  const StudyCalendarScreen({super.key, required this.studies, required this.onDataChanged});

  @override
  Widget build(BuildContext context) {
    final studyDates = studies.map((s) => s.dateKey).toSet();

    return Scaffold(
      appBar: AppBar(title: const Text('Study Calendar')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Recorded Study Days:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          studyDates.isEmpty
              ? const Center(child: Padding(padding: EdgeInsets.all(20), child: Text('No study days found.')))
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: studies.length,
                  itemBuilder: (context, index) {
                    final day = studies[index];
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.calendar_today, color: Colors.green),
                        title: Text(day.dateKey, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Chapters: ${day.chapters.map((c) => c.chapter).join(', ')}'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => DailyStudyScreen(dateKey: day.dateKey, onDataChanged: onDataChanged)),
                          );
                        },
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}

class CharacterLibraryScreen extends StatelessWidget {
  final List<StudyDay> studies;

  const CharacterLibraryScreen({super.key, required this.studies});

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> characters = [];
    for (var day in studies) {
      for (var c in day.chapters) {
        if (c.characterName.trim().isNotEmpty) {
          characters.add({
            'name': c.characterName,
            'chapter': c.chapter,
            'who': c.characterWho,
            'traits': c.characterTraits,
            'actions': c.characterActions,
            'lessons': c.characterLessons,
          });
        }
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Character Study Library')),
      body: characters.isEmpty
          ? const Center(child: Text('No character studies recorded yet.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: characters.length,
              itemBuilder: (context, index) {
                final ch = characters[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(ch['name']!, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('Chapter Source: ${ch['chapter']}', style: const TextStyle(color: Colors.grey)),
                        const Divider(),
                        Text('Who: ${ch['who']}'),
                        Text('Traits: ${ch['traits']}'),
                        Text('Actions: ${ch['actions']}'),
                        Text('Lessons: ${ch['lessons']}'),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class ReadingTrackerScreen extends StatefulWidget {
  final Map<String, List<String>> progress;
  final VoidCallback onDataChanged;

  const ReadingTrackerScreen({super.key, required this.progress, required this.onDataChanged});

  @override
  State<ReadingTrackerScreen> createState() => _ReadingTrackerScreenState();
}

class _ReadingTrackerScreenState extends State<ReadingTrackerScreen> {
  final Map<String, int> ntBooks = {
    'Matthew': 28, 'Mark': 16, 'Luke': 24, 'John': 21, 'Acts': 28,
    'Romans': 16, '1 Corinthians': 16, '2 Corinthians': 13, 'Galatians': 6,
    'Ephesians': 6, 'Philippians': 4, 'Colossians': 4, '1 Thessalonians': 5,
    '2 Thessalonians': 3, '1 Timothy': 6, '2 Timothy': 4, 'Titus': 3,
    'Philemon': 1, 'Hebrews': 13, 'James': 5, '1 Peter': 5, '2 Peter': 3,
    '1 John': 5, '2 John': 1, '3 John': 1, 'Jude': 1, 'Revelation': 22
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Testament Reading Tracker')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: ntBooks.keys.length,
        itemBuilder: (context, index) {
          String bookName = ntBooks.keys.elementAt(index);
          int totalChapters = ntBooks[bookName]!;
          List<String> completed = widget.progress[bookName] ?? [];

          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ExpansionTile(
              title: Text(bookName, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${completed.length} / $totalChapters chapters completed'),
              children: [
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: totalChapters,
                  itemBuilder: (context, cIdx) {
                    String chapLabel = '${cIdx + 1}';
                    bool isDone = completed.contains(chapLabel);
                    return InkWell(
                      onTap: () {
                        setState(() {
                          if (isDone) {
                            completed.remove(chapLabel);
                          } else {
                            completed.add(chapLabel);
                          }
                          widget.progress[bookName] = completed;
                        });
                        ReadingStorage.saveProgress(widget.progress);
                        widget.onDataChanged();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isDone ? Colors.green : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          chapLabel,
                          style: TextStyle(
                            color: isDone ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class BackupSettingsScreen extends StatelessWidget {
  final List<StudyDay> studies;
  final VoidCallback onDataChanged;

  const BackupSettingsScreen({super.key, required this.studies, required this.onDataChanged});

  void _exportJson(BuildContext context) {
    final jsonStr = jsonEncode(studies.map((s) => s.toJson()).toList());
    Clipboard.setData(ClipboardData(text: jsonStr));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Study database exported to clipboard as JSON!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings & Backup')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Export & Backup', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () => _exportJson(context),
            icon: const Icon(Icons.copy),
            label: const Text('Export All Studies (JSON to Clipboard)'),
          ),
          const SizedBox(height: 24),
          const Text('Theme Settings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: BitaniyaBibleStudyApp.of(context)._isDarkMode,
            onChanged: (_) => BitaniyaBibleStudyApp.of(context).toggleTheme(),
          ),
        ],
      ),
    );
  }
}
