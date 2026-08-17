import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BitaniyaBibleStudyApp());
}

class BitaniyaBibleStudyApp extends StatefulWidget {
  const BitaniyaBibleStudyApp({super.key});

  @override
  State<BitaniyaBibleStudyApp> createState() =>
      _BitaniyaBibleStudyAppState();
}

class _BitaniyaBibleStudyAppState extends State<BitaniyaBibleStudyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString('themeMode') ?? 'system';

    setState(() {
      if (value == 'light') {
        _themeMode = ThemeMode.light;
      } else if (value == 'dark') {
        _themeMode = ThemeMode.dark;
      } else {
        _themeMode = ThemeMode.system;
      }
    });
  }

  Future<void> _setTheme(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();

    String value = 'system';

    if (mode == ThemeMode.light) {
      value = 'light';
    } else if (mode == ThemeMode.dark) {
      value = 'dark';
    }

    await prefs.setString('themeMode', value);

    setState(() {
      _themeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bitaniya Bible Study',
      themeMode: _themeMode,
      theme: _lightTheme(),
      darkTheme: _darkTheme(),
      home: HomeScreen(
        themeMode: _themeMode,
        onThemeChanged: _setTheme,
      ),
    );
  }

  ThemeData _lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorSchemeSeed: Colors.deepPurple,
      scaffoldBackgroundColor: const Color(0xFFF7F5FA),
      cardTheme: const CardThemeData(
        elevation: 1,
        margin: EdgeInsets.symmetric(vertical: 6),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(width: 2),
        ),
      ),
    );
  }

  ThemeData _darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorSchemeSeed: Colors.deepPurple,
      scaffoldBackgroundColor: const Color(0xFF121212),
      cardTheme: const CardThemeData(
        elevation: 1,
        margin: EdgeInsets.symmetric(vertical: 6),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(width: 2),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final ThemeMode themeMode;
  final Future<void> Function(ThemeMode) onThemeChanged;

  const HomeScreen({
    super.key,
    required this.themeMode,
    required this.onThemeChanged,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final StudyStorage _storage = StudyStorage();

  @override
  Widget build(BuildContext context) {
    final pages = [
      DailyStudyScreen(storage: _storage),
      TrackerScreen(storage: _storage),
      BackupScreen(storage: _storage),
      SettingsScreen(
        themeMode: widget.themeMode,
        onThemeChanged: widget.onThemeChanged,
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: pages[_currentIndex],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Today',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Tracker',
          ),
          NavigationDestination(
            icon: Icon(Icons.backup_outlined),
            selectedIcon: Icon(Icons.backup),
            label: 'Backup',
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

// ============================================================
// STORAGE
// ============================================================

class StudyStorage {
  static const String _studiesKey = 'bbitaniya_studies';

  Future<List<StudyDay>> loadStudies() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_studiesKey);

    if (raw == null || raw.isEmpty) {
      return [];
    }

    try {
      final decoded = jsonDecode(raw);

      if (decoded is! List) {
        return [];
      }

      return decoded
          .map((item) => StudyDay.fromJson(item))
          .toList()
          .cast<StudyDay>();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveStudies(List<StudyDay> studies) async {
    final prefs = await SharedPreferences.getInstance();

    final data = studies.map((e) => e.toJson()).toList();

    await prefs.setString(
      _studiesKey,
      jsonEncode(data),
    );
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_studiesKey);
  }

  Future<String> createBackup() async {
    final studies = await loadStudies();

    return const JsonEncoder.withIndent('  ').convert({
      'app': 'Bitaniya Bible Study',
      'version': 1,
      'created': DateTime.now().toIso8601String(),
      'studies': studies.map((e) => e.toJson()).toList(),
    });
  }

  Future<bool> restoreBackup(String backup) async {
    try {
      final decoded = jsonDecode(backup);

      if (decoded is! Map) {
        return false;
      }

      final rawStudies = decoded['studies'];

      if (rawStudies is! List) {
        return false;
      }

      final studies = rawStudies
          .map((item) => StudyDay.fromJson(item))
          .toList()
          .cast<StudyDay>();

      await saveStudies(studies);

      return true;
    } catch (_) {
      return false;
    }
  }
}

// ============================================================
// MODELS
// ============================================================

class StudyDay {
  String date;
  List<ChapterStudy> chapters;

  StudyDay({
    required this.date,
    required this.chapters,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'chapters': chapters.map((e) => e.toJson()).toList(),
    };
  }

  factory StudyDay.fromJson(Map<dynamic, dynamic> json) {
    final rawChapters = json['chapters'];

    return StudyDay(
      date: json['date']?.toString() ?? '',
      chapters: rawChapters is List
          ? rawChapters
              .map((e) => ChapterStudy.fromJson(e))
              .toList()
              .cast<ChapterStudy>()
          : [],
    );
  }
}

class ChapterStudy {
  String book;
  String chapter;
  String mainIdea;
  String observations;
  String keyVerses;
  String meaning;
  String application;
  String prayer;
  String characterStudy;
  String questions;

  ChapterStudy({
    this.book = '',
    this.chapter = '',
    this.mainIdea = '',
    this.observations = '',
    this.keyVerses = '',
    this.meaning = '',
    this.application = '',
    this.prayer = '',
    this.characterStudy = '',
    this.questions = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'book': book,
      'chapter': chapter,
      'mainIdea': mainIdea,
      'observations': observations,
      'keyVerses': keyVerses,
      'meaning': meaning,
      'application': application,
      'prayer': prayer,
      'characterStudy': characterStudy,
      'questions': questions,
    };
  }

  factory ChapterStudy.fromJson(Map<dynamic, dynamic> json) {
    return ChapterStudy(
      book: json['book']?.toString() ?? '',
      chapter: json['chapter']?.toString() ?? '',
      mainIdea: json['mainIdea']?.toString() ?? '',
      observations: json['observations']?.toString() ?? '',
      keyVerses: json['keyVerses']?.toString() ?? '',
      meaning: json['meaning']?.toString() ?? '',
      application: json['application']?.toString() ?? '',
      prayer: json['prayer']?.toString() ?? '',
      characterStudy: json['characterStudy']?.toString() ?? '',
      questions: json['questions']?.toString() ?? '',
    );
  }
}

// ============================================================
// DAILY STUDY
// ============================================================

class DailyStudyScreen extends StatefulWidget {
  final StudyStorage storage;

  const DailyStudyScreen({
    super.key,
    required this.storage,
  });

  @override
  State<DailyStudyScreen> createState() => _DailyStudyScreenState();
}

class _DailyStudyScreenState extends State<DailyStudyScreen> {
  List<StudyDay> _studies = [];
  DateTime _selectedDate = DateTime.now();

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  String _dateString(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> _load() async {
    final studies = await widget.storage.loadStudies();

    if (!mounted) return;

    setState(() {
      _studies = studies;
      _loading = false;
    });
  }

  StudyDay? get _todayStudy {
    final date = _dateString(_selectedDate);

    for (final study in _studies) {
      if (study.date == date) {
        return study;
      }
    }

    return null;
  }

  Future<StudyDay> _getOrCreateDay() async {
    final date = _dateString(_selectedDate);

    for (final study in _studies) {
      if (study.date == date) {
        return study;
      }
    }

    final newDay = StudyDay(
      date: date,
      chapters: [],
    );

    _studies.add(newDay);
    await widget.storage.saveStudies(_studies);

    return newDay;
  }

  Future<void> _addChapter() async {
    final day = await _getOrCreateDay();

    setState(() {
      day.chapters.add(
        ChapterStudy(),
      );
    });

    await widget.storage.saveStudies(_studies);

    if (!mounted) return;

    _openChapterEditor(
      day,
      day.chapters.length - 1,
    );
  }

  Future<void> _openChapterEditor(
    StudyDay day,
    int index,
  ) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChapterStudyScreen(
          chapter: day.chapters[index],
          chapterNumber: index + 1,
          onSave: () async {
            await widget.storage.saveStudies(_studies);

            if (mounted) {
              setState(() {});
            }
          },
        ),
      ),
    );

    if (mounted) {
      await _load();
    }
  }

  Future<void> _deleteChapter(
    StudyDay day,
    int index,
  ) async {
    setState(() {
      day.chapters.removeAt(index);
    });

    await widget.storage.saveStudies(_studies);
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final day = _todayStudy;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          title: const Text(
            'Bitaniya Bible Study',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              tooltip: 'Choose date',
              onPressed: _selectDate,
              icon: const Icon(Icons.calendar_month),
            ),
          ],
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 30),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                _buildDateCard(),
                const SizedBox(height: 12),
                _buildChapterCountCard(day),
                const SizedBox(height: 16),
                if (day != null && day.chapters.isNotEmpty)
                  ...List.generate(
                    day.chapters.length,
                    (index) => _buildChapterCard(
                      day,
                      index,
                    ),
                  ),
                if (day == null || day.chapters.isEmpty)
                  _buildEmptyState(),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: _addChapter,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Chapter'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(54),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateCard() {
    final formatted =
        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primaryContainer,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.calendar_today,
                color: Theme.of(context)
                    .colorScheme
                    .onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Study Date',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatted,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium,
                  ),
                ],
              ),
            ),
            OutlinedButton(
              onPressed: _selectDate,
              child: const Text('Change'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChapterCountCard(StudyDay? day) {
    final count = day?.chapters.length ?? 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            const Icon(Icons.menu_book),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                count == 0
                    ? 'No chapters yet'
                    : '$count ${count == 1 ? 'chapter' : 'chapters'} today',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (count > 0)
              Text(
                '$count',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildChapterCard(
    StudyDay day,
    int index,
  ) {
    final chapter = day.chapters[index];

    final title = chapter.book.trim().isEmpty
        ? 'Chapter ${index + 1}'
        : '${chapter.book} ${chapter.chapter}'.trim();

    final preview = chapter.mainIdea.trim().isEmpty
        ? 'Tap to continue your study'
        : chapter.mainIdea.trim();

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _openChapterEditor(day, index),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                child: Text('${index + 1}'),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      preview,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'delete') {
                    _deleteChapter(day, index);
                  }
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(
                    value: 'delete',
                    child: Text('Remove chapter'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          children: [
            Icon(
              Icons.menu_book_outlined,
              size: 52,
              color: Theme.of(context)
                  .colorScheme
                  .primary,
            ),
            const SizedBox(height: 12),
            const Text(
              'Ready for today\'s study?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Add one chapter or several chapters. '
              'There is no required number.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// CHAPTER STUDY
// ============================================================

class ChapterStudyScreen extends StatefulWidget {
  final ChapterStudy chapter;
  final int chapterNumber;
  final Future<void> Function() onSave;

  const ChapterStudyScreen({
    super.key,
    required this.chapter,
    required this.chapterNumber,
    required this.onSave,
  });

  @override
  State<ChapterStudyScreen> createState() =>
      _ChapterStudyScreenState();
}

class _ChapterStudyScreenState
    extends State<ChapterStudyScreen> {
  late final TextEditingController _bookController;
  late final TextEditingController _chapterController;
  late final TextEditingController _mainIdeaController;
  late final TextEditingController _observationsController;
  late final TextEditingController _keyVersesController;
  late final TextEditingController _meaningController;
  late final TextEditingController _applicationController;
  late final TextEditingController _prayerController;
  late final TextEditingController _characterController;
  late final TextEditingController _questionsController;

  @override
  void initState() {
    super.initState();

    _bookController =
        TextEditingController(text: widget.chapter.book);

    _chapterController =
        TextEditingController(text: widget.chapter.chapter);

    _mainIdeaController =
        TextEditingController(text: widget.chapter.mainIdea);

    _observationsController =
        TextEditingController(
          text: widget.chapter.observations,
        );

    _keyVersesController =
        TextEditingController(
          text: widget.chapter.keyVerses,
        );

    _meaningController =
        TextEditingController(
          text: widget.chapter.meaning,
        );

    _applicationController =
        TextEditingController(
          text: widget.chapter.application,
        );

    _prayerController =
        TextEditingController(
          text: widget.chapter.prayer,
        );

    _characterController =
        TextEditingController(
          text: widget.chapter.characterStudy,
        );

    _questionsController =
        TextEditingController(
          text: widget.chapter.questions,
        );
  }

  @override
  void dispose() {
    _bookController.dispose();
    _chapterController.dispose();
    _mainIdeaController.dispose();
    _observationsController.dispose();
    _keyVersesController.dispose();
    _meaningController.dispose();
    _applicationController.dispose();
    _prayerController.dispose();
    _characterController.dispose();
    _questionsController.dispose();

    super.dispose();
  }

  Future<void> _save() async {
    widget.chapter.book = _bookController.text;
    widget.chapter.chapter = _chapterController.text;
    widget.chapter.mainIdea = _mainIdeaController.text;
    widget.chapter.observations =
        _observationsController.text;
    widget.chapter.keyVerses =
        _keyVersesController.text;
    widget.chapter.meaning =
        _meaningController.text;
    widget.chapter.application =
        _applicationController.text;
    widget.chapter.prayer =
        _prayerController.text;
    widget.chapter.characterStudy =
        _characterController.text;
    widget.chapter.questions =
        _questionsController.text;

    await widget.onSave();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Study saved'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chapter ${widget.chapterNumber} Study',
        ),
        actions: [
          IconButton(
            tooltip: 'Save',
            onPressed: _save,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 30),
        children: [
          _sectionTitle(
            'Chapter',
            Icons.menu_book,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _field(
                  _bookController,
                  'Book',
                  'e.g. Matthew',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _field(
                  _chapterController,
                  'Chapter',
                  'e.g. 5',
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          _sectionTitle(
            'Understand the Chapter',
            Icons.search,
          ),

          _field(
            _mainIdeaController,
            'Main Idea',
            'What is the main message of this chapter?',
            minLines: 3,
          ),

          _field(
            _observationsController,
            'What Do You Notice?',
            'Important people, events, commands, promises, repeated words, contrasts, etc.',
            minLines: 4,
          ),

          _field(
            _keyVersesController,
            'Key Verses',
            'Which verses stand out and why?',
            minLines: 3,
          ),

          _field(
            _meaningController,
            'What Does It Mean?',
            'What does this chapter teach about God, people, sin, faith, salvation, or Christian living?',
            minLines: 4,
          ),

          const SizedBox(height: 12),

          _sectionTitle(
            'Character Study',
            Icons.person_outline,
          ),

          _field(
            _characterController,
            'Character Study',
            'Who is mentioned? What do they do, say, believe, or learn? What can you learn from or about them?',
            minLines: 5,
          ),

          const SizedBox(height: 12),

          _sectionTitle(
            'Questions',
            Icons.help_outline,
          ),

          _field(
            _questionsController,
            'Study Questions',
            'What surprised me? What is difficult to understand? What does this reveal about God? What should I believe or change?',
            minLines: 5,
          ),

          const SizedBox(height: 12),

          _sectionTitle(
            'Application',
            Icons.directions_walk,
          ),

          _field(
            _applicationController,
            'How Will I Apply This?',
            'What should I do, change, remember, practice, avoid, or trust because of this chapter?',
            minLines: 5,
          ),

          const SizedBox(height: 12),

          _sectionTitle(
            'Prayer',
            Icons.favorite_outline,
          ),

          _field(
            _prayerController,
            'Prayer',
            'Respond to what you learned from the chapter.',
            minLines: 4,
          ),

          const SizedBox(height: 20),

          FilledButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.save),
            label: const Text('Save Chapter Study'),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(54),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(
    String title,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(
            icon,
            size: 22,
            color: Theme.of(context)
                .colorScheme
                .primary,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label,
    String hint, {
    int minLines = 2,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: TextField(
        controller: controller,
        minLines: minLines,
        maxLines: null,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          alignLabelWithHint: true,
        ),
      ),
    );
  }
}

// ============================================================
// TRACKER
// ============================================================

class TrackerScreen extends StatefulWidget {
  final StudyStorage storage;

  const TrackerScreen({
    super.key,
    required this.storage,
  });

  @override
  State<TrackerScreen> createState() =>
      _TrackerScreenState();
}

class _TrackerScreenState extends State<TrackerScreen> {
  List<StudyDay> _studies = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final studies = await widget.storage.loadStudies();

    if (!mounted) return;

    setState(() {
      _studies = studies;
      _loading = false;
    });
  }

  int get _totalChapters {
    return _studies.fold(
      0,
      (sum, day) => sum + day.chapters.length,
    );
  }

  int get _daysStudied {
    return _studies
        .where((day) => day.chapters.isNotEmpty)
        .length;
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final sorted = [..._studies]
      ..sort(
        (a, b) => b.date.compareTo(a.date),
      );

    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          pinned: true,
          title: Text(
            'Study Tracker',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                Row(
                  children: [
                    Expanded(
                      child: _statCard(
                        'Days',
                        '$_daysStudied',
                        Icons.calendar_month,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _statCard(
                        'Chapters',
                        '$_totalChapters',
                        Icons.menu_book,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                const Text(
                  'Study History',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                if (sorted.isEmpty)
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        'Your completed study days will appear here.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ...sorted.map(
                  (day) => Card(
                    child: ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.menu_book),
                      ),
                      title: Text(day.date),
                      subtitle: Text(
                        '${day.chapters.length} '
                        '${day.chapters.length == 1 ? 'chapter' : 'chapters'}',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _statCard(
    String title,
    String value,
    IconData icon,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Icon(
              icon,
              size: 28,
              color: Theme.of(context)
                  .colorScheme
                  .primary,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(title),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// BACKUP / RESTORE
// ============================================================

class BackupScreen extends StatefulWidget {
  final StudyStorage storage;

  const BackupScreen({
    super.key,
    required this.storage,
  });

  @override
  State<BackupScreen> createState() =>
      _BackupScreenState();
}

class _BackupScreenState extends State<BackupScreen> {
  final TextEditingController _restoreController =
      TextEditingController();

  bool _working = false;

  @override
  void dispose() {
    _restoreController.dispose();
    super.dispose();
  }

  Future<void> _backup() async {
    setState(() {
      _working = true;
    });

    final backup =
        await widget.storage.createBackup();

    if (!mounted) return;

    setState(() {
      _working = false;
    });

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Backup'),
        content: SizedBox(
          width: 600,
          child: SingleChildScrollView(
            child: SelectableText(backup),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await Clipboard.setData(
                ClipboardData(text: backup),
              );

              if (context.mounted) {
                Navigator.pop(context);

                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Backup copied to clipboard',
                    ),
                  ),
                );
              }
            },
            child: const Text('Copy Backup'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _restore() async {
    final text = _restoreController.text.trim();

    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Paste your backup first.',
          ),
        ),
      );
      return;
    }

    setState(() {
      _working = true;
    });

    final success =
        await widget.storage.restoreBackup(text);

    if (!mounted) return;

    setState(() {
      _working = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Backup restored successfully.'
              : 'This backup could not be restored.',
        ),
      ),
    );

    if (success) {
      _restoreController.clear();
    }
  }

  Future<void> _clearAll() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete all studies?'),
        content: const Text(
          'This will permanently remove all saved '
          'study data from this device/browser.',
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.pop(context, true),
            child: const Text('Delete All'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    await widget.storage.clearAll();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All study data deleted.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          pinned: true,
          title: Text(
            'Backup & Restore',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.backup,
                          size: 40,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Backup your studies',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Create a backup containing your '
                          'dates, chapters and study notes.',
                        ),
                        const SizedBox(height: 16),
                        FilledButton.icon(
                          onPressed:
                              _working ? null : _backup,
                          icon: const Icon(Icons.copy),
                          label: const Text(
                            'Create Backup',
                          ),
                          style: FilledButton.styleFrom(
                            minimumSize:
                                const Size.fromHeight(52),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.restore,
                          size: 40,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Restore your studies',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Paste a previously created backup below.',
                        ),
                        const SizedBox(height: 14),
                        TextField(
                          controller:
                              _restoreController,
                          minLines: 8,
                          maxLines: 14,
                          decoration:
                              const InputDecoration(
                            hintText:
                                'Paste backup here...',
                            alignLabelWithHint: true,
                          ),
                        ),
                        const SizedBox(height: 14),
                        FilledButton.icon(
                          onPressed:
                              _working ? null : _restore,
                          icon: const Icon(
                            Icons.restore,
                          ),
                          label: const Text(
                            'Restore Backup',
                          ),
                          style: FilledButton.styleFrom(
                            minimumSize:
                                const Size.fromHeight(52),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.delete_outline,
                          size: 36,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Delete all local study data',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: _clearAll,
                          child: const Text(
                            'Delete Everything',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================
// SETTINGS
// ============================================================

class SettingsScreen extends StatelessWidget {
  final ThemeMode themeMode;
  final Future<void> Function(ThemeMode) onThemeChanged;

  const SettingsScreen({
    super.key,
    required this.themeMode,
    required this.onThemeChanged,
  });

  String _themeName() {
    if (themeMode == ThemeMode.light) {
      return 'Light';
    }

    if (themeMode == ThemeMode.dark) {
      return 'Dark';
    }

    return 'System default';
  }

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          pinned: true,
          title: Text(
            'Settings',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                Card(
                  child: ListTile(
                    leading: Icon(
                      isDark
                          ? Icons.dark_mode
                          : Icons.light_mode,
                    ),
                    title: const Text(
                      'Appearance',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      _themeName(),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                    ),
                    onTap: () {
                      _showThemePicker(context);
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Bitaniya Bible Study',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'A simple place to study the Bible '
                          'chapter by chapter, every day.',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showThemePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(18),
                child: Text(
                  'Choose appearance',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              RadioListTile<ThemeMode>(
                value: ThemeMode.light,
                groupValue: themeMode,
                title: const Text('Light'),
                secondary: const Icon(
                  Icons.light_mode,
                ),
                onChanged: (value) {
                  if (value != null) {
                    onThemeChanged(value);
                    Navigator.pop(context);
                  }
                },
              ),
              RadioListTile<ThemeMode>(
                value: ThemeMode.dark,
                groupValue: themeMode,
                title: const Text('Dark'),
                secondary: const Icon(
                  Icons.dark_mode,
                ),
                onChanged: (value) {
                  if (value != null) {
                    onThemeChanged(value);
                    Navigator.pop(context);
                  }
                },
              ),
              RadioListTile<ThemeMode>(
                value: ThemeMode.system,
                groupValue: themeMode,
                title: const Text('System default'),
                secondary: const Icon(
                  Icons.brightness_auto,
                ),
                onChanged: (value) {
                  if (value != null) {
                    onThemeChanged(value);
                    Navigator.pop(context);
                  }
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }
}
