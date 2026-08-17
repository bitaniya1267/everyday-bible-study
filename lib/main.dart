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
  static const _themeKey = 'bitaniya_dark_mode';
  ThemeMode _themeMode = ThemeMode.light;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final dark = prefs.getBool(_themeKey) ?? false;

    if (mounted) {
      setState(() {
        _themeMode = dark ? ThemeMode.dark : ThemeMode.light;
      });
    }
  }

  Future<void> _toggleTheme() async {
    final dark = _themeMode != ThemeMode.dark;

    setState(() {
      _themeMode = dark ? ThemeMode.dark : ThemeMode.light;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, dark);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bitaniya Bible Study',

      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFFCF9F6),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.pink,
          brightness: Brightness.light,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
        cardTheme: const CardThemeData(
          color: Colors.white,
        ),
      ),

      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.pink,
          brightness: Brightness.dark,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.grey.shade900,
        ),
        cardTheme: CardThemeData(
          color: Colors.grey.shade900,
        ),
      ),

      themeMode: _themeMode,

      home: HomePage(
        isDarkMode: _themeMode == ThemeMode.dark,
        onToggleTheme: _toggleTheme,
      ),
    );
  }
}

// ============================================================
// HOME PAGE
// ============================================================

class HomePage extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const HomePage({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<StudyDay> _studies = [];

  @override
  void initState() {
    super.initState();
    _loadStudies();
  }

  Future<void> _loadStudies() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('bitaniya_studies');

    if (saved != null) {
      final decoded = jsonDecode(saved);

      if (decoded is List) {
        setState(() {
          _studies.clear();

          for (final item in decoded) {
            _studies.add(
              StudyDay.fromJson(
                Map<String, dynamic>.from(item),
              ),
            );
          }
        });
      }
    }
  }

  Future<void> _saveStudies() async {
    final prefs = await SharedPreferences.getInstance();

    final encoded = jsonEncode(
      _studies.map((e) => e.toJson()).toList(),
    );

    await prefs.setString(
      'bitaniya_studies',
      encoded,
    );
  }

  Future<void> _addStudy() async {
    final result = await Navigator.push<StudyDay>(
      context,
      MaterialPageRoute(
        builder: (_) => DailyStudyPage(
          study: null,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _studies.add(result);
      });

      await _saveStudies();
    }
  }

  Future<void> _editStudy(int index) async {
    final result = await Navigator.push<StudyDay>(
      context,
      MaterialPageRoute(
        builder: (_) => DailyStudyPage(
          study: _studies[index],
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _studies[index] = result;
      });

      await _saveStudies();
    }
  }

  Future<void> _deleteStudy(int index) async {
    setState(() {
      _studies.removeAt(index);
    });

    await _saveStudies();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildHome(),
      _buildStudyTab(),
      const BackupPage(),
    ];

    return Scaffold(
      body: pages[_currentIndex],

      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              onPressed: _addStudy,
              child: const Icon(Icons.add),
            )
          : null,

      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book),
            label: 'Study',
          ),
          NavigationDestination(
            icon: Icon(Icons.cloud_upload),
            label: 'Backup',
          ),
        ],
      ),
    );
  }

  Widget _buildHome() {
    final totalChapters = _studies.fold<int>(
      0,
      (sum, study) => sum + study.chapters.length,
    );

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text(
              'Bitaniya Bible Study',
            ),
            actions: [
              IconButton(
                tooltip: widget.isDarkMode
                    ? 'Switch to light mode'
                    : 'Switch to dark mode',
                onPressed: widget.onToggleTheme,
                icon: Icon(
                  widget.isDarkMode
                      ? Icons.light_mode
                      : Icons.dark_mode,
                ),
              ),
            ],
          ),

          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Row(
                  children: [
                    Expanded(
                      child: _statCard(
                        Icons.calendar_month,
                        '${_studies.length}',
                        'Study days',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _statCard(
                        Icons.menu_book,
                        '$totalChapters',
                        'Chapters',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                Text(
                  'Your Study History',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),

                const SizedBox(height: 12),

                if (_studies.isEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 60,
                        horizontal: 20,
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.menu_book,
                            size: 70,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No studies yet',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Start your first Bible study from the Study tab.',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ...List.generate(
                    _studies.length,
                    (index) => _studyHistoryCard(
                      _studies[index],
                      index,
                    ),
                  ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(
    IconData icon,
    String number,
    String label,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 24,
          horizontal: 12,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
            ),
            const SizedBox(height: 10),
            Text(
              number,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(label),
          ],
        ),
      ),
    );
  }

  Widget _studyHistoryCard(
    StudyDay study,
    int index,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const CircleAvatar(
          child: Icon(Icons.menu_book),
        ),
        title: Text(
          study.title.isEmpty
              ? 'Bible Study'
              : study.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '${study.date} • ${study.chapters.length} chapter(s)',
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              _editStudy(index);
            }

            if (value == 'delete') {
              _deleteStudy(index);
            }
          },
          itemBuilder: (_) => const [
            PopupMenuItem(
              value: 'edit',
              child: Text('Edit'),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Text('Delete'),
            ),
          ],
        ),
        onTap: () {
          _editStudy(index);
        },
      ),
    );
  }

  Widget _buildStudyTab() {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text('Bible Study'),
            actions: [
              IconButton(
                onPressed: widget.onToggleTheme,
                icon: Icon(
                  widget.isDarkMode
                      ? Icons.light_mode
                      : Icons.dark_mode,
                ),
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.menu_book,
                          size: 60,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Daily Bible Study',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Choose your date and chapters, then study each chapter using the sections below.',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        FilledButton.icon(
                          onPressed: _addStudy,
                          icon: const Icon(Icons.add),
                          label: const Text(
                            'Start Today\'s Study',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.check_circle_outline,
                    ),
                    title: const Text(
                      'New Testament Reading Tracker',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: const Text(
                      'Track chapters you have completed.',
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const NewTestamentTrackerPage(),
                        ),
                      );
                    },
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// DATA MODEL
// ============================================================

class StudyDay {
  String title;
  String date;
  List<String> chapters;

  String characterStudy;
  String chapterStudy;
  String quietTime;
  String reflection;

  StudyDay({
    required this.title,
    required this.date,
    required this.chapters,
    this.characterStudy = '',
    this.chapterStudy = '',
    this.quietTime = '',
    this.reflection = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'date': date,
      'chapters': chapters,
      'characterStudy': characterStudy,
      'chapterStudy': chapterStudy,
      'quietTime': quietTime,
      'reflection': reflection,
    };
  }

  factory StudyDay.fromJson(
    Map<String, dynamic> json,
  ) {
    return StudyDay(
      title: json['title'] ?? '',
      date: json['date'] ?? '',
      chapters: List<String>.from(
        json['chapters'] ?? [],
      ),
      characterStudy:
          json['characterStudy'] ?? '',
      chapterStudy:
          json['chapterStudy'] ?? '',
      quietTime:
          json['quietTime'] ?? '',
      reflection:
          json['reflection'] ?? '',
    );
  }
}

// ============================================================
// DAILY STUDY PAGE
// ============================================================

class DailyStudyPage extends StatefulWidget {
  final StudyDay? study;

  const DailyStudyPage({
    super.key,
    required this.study,
  });

  @override
  State<DailyStudyPage> createState() =>
      _DailyStudyPageState();
}

class _DailyStudyPageState
    extends State<DailyStudyPage> {
  late TextEditingController _titleController;
  late TextEditingController _chapterController;

  final TextEditingController _characterController =
      TextEditingController();

  final TextEditingController _chapterStudyController =
      TextEditingController();

  final TextEditingController _quietController =
      TextEditingController();

  final TextEditingController _reflectionController =
      TextEditingController();

  final List<String> _chapters = [];

  @override
  void initState() {
    super.initState();

    final study = widget.study;

    _titleController = TextEditingController(
      text: study?.title ?? '',
    );

    _chapterController =
        TextEditingController();

    if (study != null) {
      _chapters.addAll(study.chapters);

      _characterController.text =
          study.characterStudy;

      _chapterStudyController.text =
          study.chapterStudy;

      _quietController.text =
          study.quietTime;

      _reflectionController.text =
          study.reflection;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _chapterController.dispose();
    _characterController.dispose();
    _chapterStudyController.dispose();
    _quietController.dispose();
    _reflectionController.dispose();
    super.dispose();
  }

  String get _date {
    if (widget.study?.date.isNotEmpty == true) {
      return widget.study!.date;
    }

    final now = DateTime.now();

    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  void _addChapter() {
    final value =
        _chapterController.text.trim();

    if (value.isEmpty) return;

    setState(() {
      _chapters.add(value);
      _chapterController.clear();
    });
  }

  void _removeChapter(int index) {
    setState(() {
      _chapters.removeAt(index);
    });
  }

  void _save() {
    if (_chapters.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please add at least one chapter.',
          ),
        ),
      );
      return;
    }

    final study = StudyDay(
      title: _titleController.text.trim(),
      date: _date,
      chapters: List.from(_chapters),
      characterStudy:
          _characterController.text,
      chapterStudy:
          _chapterStudyController.text,
      quietTime:
          _quietController.text,
      reflection:
          _reflectionController.text,
    );

    Navigator.pop(context, study);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.study == null
              ? 'New Daily Study'
              : 'Edit Daily Study',
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // DATE + CHAPTERS TOGETHER
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Study Details',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),

                    const SizedBox(height: 16),

                    Text(
                      'Date: $_date',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 16),

                    TextField(
                      controller: _titleController,
                      decoration:
                          const InputDecoration(
                        labelText: 'Study title (optional)',
                        hintText:
                            'Example: Romans 1–3',
                      ),
                    ),

                    const SizedBox(height: 16),

                    TextField(
                      controller: _chapterController,
                      decoration:
                          InputDecoration(
                        labelText: 'Add a chapter',
                        hintText:
                            'Example: Romans 1',
                        suffixIcon: IconButton(
                          onPressed: _addChapter,
                          icon: const Icon(
                            Icons.add_circle,
                          ),
                        ),
                      ),
                      onSubmitted: (_) =>
                          _addChapter(),
                    ),

                    const SizedBox(height: 12),

                    if (_chapters.isEmpty)
                      const Text(
                        'No chapters added yet. You can study one chapter or several chapters in the same day.',
                      )
                    else
                      ...List.generate(
                        _chapters.length,
                        (index) => Card(
                          margin:
                              const EdgeInsets.only(
                            bottom: 6,
                          ),
                          child: ListTile(
                            dense: true,
                            leading: CircleAvatar(
                              radius: 16,
                              child: Text(
                                '${index + 1}',
                              ),
                            ),
                            title: Text(
                              _chapters[index],
                            ),
                            trailing:
                                IconButton(
                              onPressed: () =>
                                  _removeChapter(
                                      index),
                              icon: const Icon(
                                Icons.close,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // CHAPTER STUDY
            _studySection(
              title: 'CHAPTER STUDY',
              icon: Icons.menu_book,
              controller:
                  _chapterStudyController,
              questions: const [
                'What is happening in this chapter?',
                'What stands out to me?',
                'What does this chapter teach me about God?',
                'What does it teach me about people?',
                'What commands, promises, warnings, or examples do I see?',
                'Is there a repeated word, idea, or theme?',
                'What does this chapter mean in its context?',
                'How should this change the way I think or live?',
                'What is one thing I want to remember from this chapter?',
              ],
            ),

            const SizedBox(height: 16),

            // CHARACTER STUDY UNDER CHAPTER STUDY
            _studySection(
              title: 'BIBLE CHARACTER STUDY',
              icon: Icons.person,
              controller:
                  _characterController,
              questions: const [
                'Who is the main person or people in this chapter?',
                'What do I learn about their character?',
                'What did they do well?',
                'What did they do poorly?',
                'What motivated their actions?',
                'How did they respond to God?',
                'What can I learn from their example?',
                'Is there a warning I should learn from?',
              ],
            ),

            const SizedBox(height: 16),

            // QUIET TIME
            _studySection(
              title: 'QUIET TIME NOTES',
              icon: Icons.spa,
              controller: _quietController,
              questions: const [
                'What is God putting on my heart?',
                'What do I need to pray about?',
                'Is there a truth I need to remember today?',
              ],
            ),

            const SizedBox(height: 16),

            // REFLECTION
            _studySection(
              title: 'REFLECTION JOURNAL',
              icon: Icons.edit_note,
              controller:
                  _reflectionController,
              questions: const [
                'What did I learn today?',
                'How can I apply it?',
                'What is one practical step I can take?',
              ],
            ),

            const SizedBox(height: 24),

            FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save),
              label: const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 14,
                ),
                child: Text(
                  'SAVE STUDY',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _studySection({
    required String title,
    required IconData icon,
    required TextEditingController controller,
    required List<String> questions,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            ...questions.map(
              (question) => Padding(
                padding:
                    const EdgeInsets.only(
                  bottom: 8,
                ),
                child: Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '• ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: Text(question),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: controller,
              maxLines: 8,
              decoration:
                  const InputDecoration(
                hintText:
                    'Write your notes here...',
                alignLabelWithHint: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// NEW TESTAMENT TRACKER
// ============================================================

class NewTestamentTrackerPage
    extends StatefulWidget {
  const NewTestamentTrackerPage({
    super.key,
  });

  @override
  State<NewTestamentTrackerPage> createState() =>
      _NewTestamentTrackerPageState();
}

class _NewTestamentTrackerPageState
    extends State<NewTestamentTrackerPage> {
  static const String _storageKey =
      'bitaniya_nt_tracker_v2';

  final Map<String, int> _bookChapters = {
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

  final Set<String> _completed = {};

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final prefs =
        await SharedPreferences.getInstance();

    final list =
        prefs.getStringList(_storageKey) ?? [];

    setState(() {
      _completed.addAll(list);
    });
  }

  Future<void> _saveProgress() async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setStringList(
      _storageKey,
      _completed.toList(),
    );
  }

  String _chapterKey(
    String book,
    int chapter,
  ) {
    return '$book:$chapter';
  }

  bool _isComplete(
    String book,
    int chapter,
  ) {
    return _completed.contains(
      _chapterKey(book, chapter),
    );
  }

  void _toggleChapter(
    String book,
    int chapter,
  ) async {
    final key = _chapterKey(book, chapter);

    setState(() {
      if (_completed.contains(key)) {
        _completed.remove(key);
      } else {
        _completed.add(key);
      }
    });

    await _saveProgress();
  }

  int get _totalChapters {
    return _bookChapters.values.fold(
      0,
      (sum, value) => sum + value,
    );
  }

  double get _progress {
    if (_totalChapters == 0) {
      return 0;
    }

    return _completed.length /
        _totalChapters;
  }

  void _clearProgress() async {
    final confirmed =
        await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Reset tracker?',
          ),
          content: const Text(
            'This will remove all completed chapter marks.',
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(
                context,
                false,
              ),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () =>
                  Navigator.pop(
                context,
                true,
              ),
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    setState(() {
      _completed.clear();
    });

    await _saveProgress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'New Testament Reading Tracker',
        ),
        actions: [
          IconButton(
            tooltip: 'Reset tracker',
            onPressed: _clearProgress,
            icon: const Icon(
              Icons.restart_alt,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_completed.length} / $_totalChapters chapters completed',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    LinearProgressIndicator(
                      value: _progress,
                      minHeight: 10,
                    ),

                    const SizedBox(height: 8),

                    Text(
                      '${(_progress * 100).toStringAsFixed(1)}% complete',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            ..._bookChapters.entries.map(
              (entry) {
                final book = entry.key;
                final chapters = entry.value;

                final completedForBook =
                    List.generate(
                  chapters,
                  (index) => index + 1,
                ).where(
                  (chapter) =>
                      _isComplete(
                    book,
                    chapter,
                  ),
                ).length;

                return Card(
                  margin:
                      const EdgeInsets.only(
                    bottom: 12,
                  ),
                  child: ExpansionTile(
                    title: Text(
                      book,
                      style: const TextStyle(
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '$completedForBook / $chapters chapters',
                    ),
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(
                          16,
                          0,
                          16,
                          16,
                        ),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: List.generate(
                            chapters,
                            (index) {
                              final chapter =
                                  index + 1;
                              final complete =
                                  _isComplete(
                                book,
                                chapter,
                              );

                              return FilterChip(
                                selected:
                                    complete,
                                label: Text(
                                  '$chapter',
                                ),
                                onSelected: (_) =>
                                    _toggleChapter(
                                  book,
                                  chapter,
                                ),
                                avatar: complete
                                    ? const Icon(
                                        Icons.check,
                                        size: 18,
                                      )
                                    : null,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// BACKUP PAGE
// ============================================================

class BackupPage extends StatefulWidget {
  const BackupPage({super.key});

  @override
  State<BackupPage> createState() =>
      _BackupPageState();
}

class _BackupPageState
    extends State<BackupPage> {
  String _message = '';

  Future<void> _backup() async {
    final prefs =
        await SharedPreferences.getInstance();

    final studies =
        prefs.getString('bitaniya_studies') ?? '[]';

    final tracker =
        prefs.getStringList(
          'bitaniya_nt_tracker_v2',
        ) ??
        [];

    final backup = jsonEncode({
      'app': 'Bitaniya Bible Study',
      'version': 1,
      'studies': jsonDecode(studies),
      'newTestamentTracker': tracker,
    });

    await Clipboard.setData(
      ClipboardData(text: backup),
    );

    setState(() {
      _message =
          'Backup copied to your clipboard.';
    });
  }

  Future<void> _restore() async {
    final data =
        await Clipboard.getData(
      Clipboard.kTextPlain,
    );

    if (data == null ||
        data.text == null ||
        data.text!.trim().isEmpty) {
      setState(() {
        _message =
            'No backup data was found in the clipboard.';
      });
      return;
    }

    try {
      final decoded =
          jsonDecode(data.text!);

      if (decoded is! Map) {
        throw Exception();
      }

      final prefs =
          await SharedPreferences.getInstance();

      final studies =
          decoded['studies'];

      if (studies is List) {
        await prefs.setString(
          'bitaniya_studies',
          jsonEncode(studies),
        );
      }

      final tracker =
          decoded['newTestamentTracker'];

      if (tracker is List) {
        await prefs.setStringList(
          'bitaniya_nt_tracker_v2',
          List<String>.from(tracker),
        );
      }

      setState(() {
        _message =
            'Backup restored successfully. Restart or revisit the pages to see the restored data.';
      });
    } catch (_) {
      setState(() {
        _message =
            'That clipboard content is not a valid Bitaniya Bible Study backup.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Backup & Restore'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Icon(
                    Icons.cloud_upload,
                    size: 60,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Backup all your study data',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Your daily studies and New Testament reading tracker can be backed up together.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: _backup,
                    icon: const Icon(
                      Icons.copy,
                    ),
                    label: const Text(
                      'Copy Backup',
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: _restore,
                    icon: const Icon(
                      Icons.restore,
                    ),
                    label: const Text(
                      'Restore Backup',
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (_message.isNotEmpty) ...[
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding:
                    const EdgeInsets.all(16),
                child: Text(
                  _message,
                  textAlign:
                      TextAlign.center,
                ),
              ),
            ),
          ],

          const SizedBox(height: 20),

          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Tip: Keep your backup text somewhere safe. You can use it to restore your study data later.',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
