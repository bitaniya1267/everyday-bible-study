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
  State<BitaniyaBibleStudyApp> createState() => _BitaniyaBibleStudyAppState();

  static _BitaniyaBibleStudyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_BitaniyaBibleStudyAppState>()!;
}

class _BitaniyaBibleStudyAppState extends State<BitaniyaBibleStudyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('is_dark_mode') ?? false;
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  Future<void> toggleTheme() async {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_dark_mode', _themeMode == ThemeMode.dark);
  }

  @override
  Widget build(BuildContext context) {
    const seedColor = Color(0xFF6A4BBC);

    return MaterialApp(
      title: 'Bitaniya Bible Study',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: seedColor,
        scaffoldBackgroundColor: const Color(0xFFF7F5FB),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: seedColor,
              width: 1.5,
            ),
          ),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: seedColor,
        scaffoldBackgroundColor: const Color(0xFF121212),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF1E1E1E),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.grey.shade800),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: seedColor,
              width: 1.5,
            ),
          ),
        ),
      ),
      home: const AppShell(),
    );
  }
}

// ============================================================
// DATA MODELS
// ============================================================

class ChapterEntry {
  String id;
  String reference;

  String keyVerse;
  String summary;
  String observations;
  String meaning;
  String lessons;
  String application;
  String questions;
  String prayer;

  String characterName;
  String characterWho;
  String characterTraits;
  String characterActions;
  String characterLessons;

  ChapterEntry({
    required this.id,
    required this.reference,
    this.keyVerse = '',
    this.summary = '',
    this.observations = '',
    this.meaning = '',
    this.lessons = '',
    this.application = '',
    this.questions = '',
    this.prayer = '',
    this.characterName = '',
    this.characterWho = '',
    this.characterTraits = '',
    this.characterActions = '',
    this.characterLessons = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reference': reference,
      'keyVerse': keyVerse,
      'summary': summary,
      'observations': observations,
      'meaning': meaning,
      'lessons': lessons,
      'application': application,
      'questions': questions,
      'prayer': prayer,
      'characterName': characterName,
      'characterWho': characterWho,
      'characterTraits': characterTraits,
      'characterActions': characterActions,
      'characterLessons': characterLessons,
    };
  }

  factory ChapterEntry.fromJson(Map<String, dynamic> json) {
    return ChapterEntry(
      id: json['id']?.toString() ??
          DateTime.now().microsecondsSinceEpoch.toString(),
      reference: json['reference']?.toString() ?? '',
      keyVerse: json['keyVerse']?.toString() ?? '',
      summary: json['summary']?.toString() ?? '',
      observations: json['observations']?.toString() ?? '',
      meaning: json['meaning']?.toString() ?? '',
      lessons: json['lessons']?.toString() ?? '',
      application: json['application']?.toString() ?? '',
      questions: json['questions']?.toString() ?? '',
      prayer: json['prayer']?.toString() ?? '',
      characterName: json['characterName']?.toString() ?? '',
      characterWho: json['characterWho']?.toString() ?? '',
      characterTraits: json['characterTraits']?.toString() ?? '',
      characterActions: json['characterActions']?.toString() ?? '',
      characterLessons: json['characterLessons']?.toString() ?? '',
    );
  }
}

class StudyDay {
  String dateKey;
  List<ChapterEntry> chapters;

  StudyDay({
    required this.dateKey,
    required this.chapters,
  });

  Map<String, dynamic> toJson() {
    return {
      'dateKey': dateKey,
      'chapters': chapters.map((c) => c.toJson()).toList(),
    };
  }

  factory StudyDay.fromJson(Map<String, dynamic> json) {
    final rawChapters = json['chapters'];

    final chapters = <ChapterEntry>[];

    if (rawChapters is List) {
      for (final item in rawChapters) {
        if (item is Map) {
          chapters.add(
            ChapterEntry.fromJson(
              Map<String, dynamic>.from(item),
            ),
          );
        }
      }
    }

    return StudyDay(
      dateKey: json['dateKey']?.toString() ?? '',
      chapters: chapters,
    );
  }
}

// ============================================================
// STORAGE
// ============================================================

class StudyStorage {
  static const String storageKey = 'bitaniya_bible_studies';
  static const String trackerStorageKey = 'bitaniya_bible_tracker';

  static Future<List<StudyDay>> loadDays() async {
    final prefs = await SharedPreferences.getInstance();

    final raw = prefs.getString(storageKey);

    if (raw == null || raw.trim().isEmpty) {
      return [];
    }

    try {
      final decoded = jsonDecode(raw);

      if (decoded is! List) {
        return [];
      }

      return decoded
          .whereType<Map>()
          .map(
            (item) => StudyDay.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> saveDays(List<StudyDay> days) async {
    final prefs = await SharedPreferences.getInstance();

    final data = days.map((day) => day.toJson()).toList();

    await prefs.setString(
      storageKey,
      jsonEncode(data),
    );
  }

  static Future<Set<String>> loadTrackerProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(trackerStorageKey);
    if (list == null) return {};
    return list.toSet();
  }

  static Future<void> saveTrackerProgress(Set<String> completedChapters) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(trackerStorageKey, completedChapters.toList());
  }

  static Future<String> createBackup(List<StudyDay> days) async {
    final prefs = await SharedPreferences.getInstance();
    final trackerList = prefs.getStringList(trackerStorageKey) ?? [];

    final backup = {
      'app': 'Bitaniya Bible Study',
      'version': 2,
      'createdAt': DateTime.now().toIso8601String(),
      'studies': days.map((day) => day.toJson()).toList(),
      'tracker': trackerList,
    };

    return const JsonEncoder.withIndent('  ').convert(backup);
  }

  static Future<bool> restoreBackup(String text) async {
    try {
      final decoded = jsonDecode(text);

      if (decoded is! Map) {
        return false;
      }

      final rawStudies = decoded['studies'];

      if (rawStudies is! List) {
        return false;
      }

      final restored = <StudyDay>[];

      for (final item in rawStudies) {
        if (item is Map) {
          restored.add(
            StudyDay.fromJson(
              Map<String, dynamic>.from(item),
            ),
          );
        }
      }

      await saveDays(restored);

      final rawTracker = decoded['tracker'];
      if (rawTracker is List) {
        final trackerSet = rawTracker.map((e) => e.toString()).toSet();
        await saveTrackerProgress(trackerSet);
      }

      return true;
    } catch (_) {
      return false;
    }
  }
}

// ============================================================
// APP SHELL
// ============================================================

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int currentIndex = 0;

  List<StudyDay> days = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final loaded = await StudyStorage.loadDays();

    if (!mounted) return;

    setState(() {
      days = loaded;
      loading = false;
    });
  }

  Future<void> saveData() async {
    await StudyStorage.saveDays(days);

    if (!mounted) return;

    setState(() {});
  }

  void updateDay(StudyDay day) {
    final index = days.indexWhere(
      (item) => item.dateKey == day.dateKey,
    );

    setState(() {
      if (index >= 0) {
        days[index] = day;
      } else {
        days.add(day);
      }
    });

    saveData();
  }

  void deleteDay(String dateKey) {
    setState(() {
      days.removeWhere(
        (day) => day.dateKey == dateKey,
      );
    });

    saveData();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final pages = [
      HomeScreen(
        days: days,
        onOpenDay: (day) {
          setState(() {
            currentIndex = 1;
          });
        },
        onDeleteDay: deleteDay,
      ),
      DailyStudyScreen(
        days: days,
        onSaveDay: updateDay,
      ),
      const BibleTrackerScreen(),
      BackupScreen(
        days: days,
        onRestored: loadData,
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: pages[currentIndex],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            currentIndex = index;
          });
        },
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
            icon: Icon(Icons.checklist_outlined),
            selectedIcon: Icon(Icons.checklist),
            label: 'Tracker',
          ),
          NavigationDestination(
            icon: Icon(Icons.backup_outlined),
            selectedIcon: Icon(Icons.backup),
            label: 'Backup',
          ),
        ],
      ),
    );
  }
}

// ============================================================
// THEME TOGGLE BUTTON WIDGET
// ============================================================

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return IconButton(
      tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
      onPressed: () {
        BitaniyaBibleStudyApp.of(context).toggleTheme();
      },
      icon: Icon(isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
    );
  }
}

// ============================================================
// HOME SCREEN
// ============================================================

class HomeScreen extends StatelessWidget {
  final List<StudyDay> days;
  final void Function(StudyDay day) onOpenDay;
  final void Function(String dateKey) onDeleteDay;

  const HomeScreen({
    super.key,
    required this.days,
    required this.onOpenDay,
    required this.onDeleteDay,
  });

  String formatDate(String dateKey) {
    try {
      final date = DateTime.parse(dateKey);

      return '${date.day}/${date.month}/${date.year}';
    } catch (_) {
      return dateKey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final sorted = [...days];

    sorted.sort(
      (a, b) => b.dateKey.compareTo(a.dateKey),
    );

    final completedDays = sorted.length;

    final totalChapters = sorted.fold<int>(
      0,
      (sum, day) => sum + day.chapters.length,
    );

    return CustomScrollView(
      slivers: [
        SliverAppBar.large(
          pinned: true,
          title: const Text('Bitaniya Bible Study'),
          actions: [
            const ThemeToggleButton(),
            IconButton(
              tooltip: 'New study',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Open the Study tab to start today’s study.',
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            16,
            8,
            16,
            24,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.calendar_month,
                        value: '$completedDays',
                        label: 'Study days',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.menu_book,
                        value: '$totalChapters',
                        label: 'Chapters',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Your Study History',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                if (sorted.isEmpty)
                  _EmptyCard(
                    icon: Icons.menu_book_outlined,
                    title: 'No studies yet',
                    message:
                        'Start your first Bible study from the Study tab.',
                  )
                else
                  ...sorted.map(
                    (day) => Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        leading: CircleAvatar(
                          child: Text(
                            '${day.chapters.length}',
                          ),
                        ),
                        title: Text(
                          formatDate(day.dateKey),
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        subtitle: Text(
                          day.chapters
                              .map((c) => c.reference)
                              .where((x) => x.isNotEmpty)
                              .join(' • '),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'delete') {
                              _confirmDelete(
                                context,
                                day,
                              );
                            }
                          },
                          itemBuilder: (context) => const [
                            PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete'),
                            ),
                          ],
                        ),
                        onTap: () {
                          onOpenDay(day);

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => StandaloneDayEditor(
                                day: day,
                                onSave: (updated) {
                                  onOpenDay(updated);
                                },
                              ),
                            ),
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
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    StudyDay day,
  ) async {
    final answer = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete study?'),
          content: Text(
            'Delete the study for ${formatDate(day.dateKey)}?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (answer == true) {
      onDeleteDay(day.dateKey);
    }
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
          children: [
            Icon(icon, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const _EmptyCard({
    required this.icon,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          children: [
            Icon(
              icon,
              size: 48,
              color: Colors.grey,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// DAILY STUDY SCREEN
// ============================================================

class DailyStudyScreen extends StatefulWidget {
  final List<StudyDay> days;
  final void Function(StudyDay day) onSaveDay;

  const DailyStudyScreen({
    super.key,
    required this.days,
    required this.onSaveDay,
  });

  @override
  State<DailyStudyScreen> createState() => _DailyStudyScreenState();
}

class _DailyStudyScreenState extends State<DailyStudyScreen> {
  late DateTime selectedDate;
  StudyDay? currentDay;

  @override
  void initState() {
    super.initState();

    selectedDate = DateTime.now();

    _loadSelectedDay();
  }

  String dateKey(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');

    return '$y-$m-$d';
  }

  void _loadSelectedDay() {
    final key = dateKey(selectedDate);

    final existing = widget.days.where(
      (day) => day.dateKey == key,
    );

    if (existing.isNotEmpty) {
      currentDay = _copyDay(existing.first);
    } else {
      currentDay = StudyDay(
        dateKey: key,
        chapters: [
          ChapterEntry(
            id: DateTime.now().microsecondsSinceEpoch.toString(),
            reference: '',
          ),
          ChapterEntry(
            id: (DateTime.now().microsecondsSinceEpoch + 1).toString(),
            reference: '',
          ),
          ChapterEntry(
            id: (DateTime.now().microsecondsSinceEpoch + 2).toString(),
            reference: '',
          ),
        ],
      );
    }
  }

  StudyDay _copyDay(StudyDay day) {
    return StudyDay(
      dateKey: day.dateKey,
      chapters: day.chapters
          .map(
            (chapter) => ChapterEntry.fromJson(
              chapter.toJson(),
            ),
          )
          .toList(),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked == null) return;

    setState(() {
      selectedDate = picked;
      _loadSelectedDay();
    });
  }

  void _save() {
    final day = currentDay;

    if (day == null) return;

    widget.onSaveDay(
      _copyDay(day),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Study saved'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _addChapter() {
    setState(() {
      currentDay!.chapters.add(
        ChapterEntry(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          reference: '',
        ),
      );
    });
  }

  void _removeChapter(int index) {
    if (currentDay!.chapters.length <= 1) {
      return;
    }

    setState(() {
      currentDay!.chapters.removeAt(index);
    });

    _saveSilently();
  }

  void _saveSilently() {
    final day = currentDay;

    if (day != null) {
      widget.onSaveDay(
        _copyDay(day),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final day = currentDay;

    if (day == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          title: const Text('Daily Study'),
          actions: [
            const ThemeToggleButton(),
            IconButton(
              tooltip: 'Save',
              onPressed: _save,
              icon: const Icon(Icons.save_outlined),
            ),
          ],
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            16,
            12,
            16,
            30,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                _buildDayHeader(),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${day.chapters.length} '
                        '${day.chapters.length == 1 ? 'chapter' : 'chapters'}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: _addChapter,
                      icon: const Icon(Icons.add),
                      label: const Text('Add chapter'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...List.generate(
                  day.chapters.length,
                  (index) {
                    final chapter = day.chapters[index];

                    return Padding(
                      padding: const EdgeInsets.only(
                        bottom: 14,
                      ),
                      child: ChapterCard(
                        key: ValueKey(chapter.id),
                        number: index + 1,
                        chapter: chapter,
                        canDelete: day.chapters.length > 1,
                        onChanged: () {
                          _saveSilently();
                        },
                        onDelete: () {
                          _removeChapter(index);
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton.icon(
                    onPressed: _save,
                    icon: const Icon(Icons.save),
                    label: const Text(
                      'SAVE TODAY’S STUDY',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
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

  Widget _buildDayHeader() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Study Day',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: _pickDate,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Date',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                child: Text(
                  '${selectedDate.day}/'
                  '${selectedDate.month}/'
                  '${selectedDate.year}',
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Plan as many chapters as you want. '
              'Three chapters are provided by default, '
              'but the number is completely optional.',
              style: TextStyle(
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// STANDALONE DAY EDITOR
// ============================================================

class StandaloneDayEditor extends StatelessWidget {
  final StudyDay day;
  final void Function(StudyDay day) onSave;

  const StandaloneDayEditor({
    super.key,
    required this.day,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Study'),
        actions: const [ThemeToggleButton()],
      ),
      body: DailyStudyEditorBody(
        initialDay: day,
        onSave: (updated) {
          onSave(updated);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Study saved'),
            ),
          );
        },
      ),
    );
  }
}

class DailyStudyEditorBody extends StatefulWidget {
  final StudyDay initialDay;
  final void Function(StudyDay day) onSave;

  const DailyStudyEditorBody({
    super.key,
    required this.initialDay,
    required this.onSave,
  });

  @override
  State<DailyStudyEditorBody> createState() => _DailyStudyEditorBodyState();
}

class _DailyStudyEditorBodyState extends State<DailyStudyEditorBody> {
  late StudyDay day;

  @override
  void initState() {
    super.initState();

    day = StudyDay.fromJson(
      widget.initialDay.toJson(),
    );
  }

  void save() {
    widget.onSave(
      StudyDay.fromJson(
        day.toJson(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ...List.generate(
          day.chapters.length,
          (index) {
            final chapter = day.chapters[index];

            return Padding(
              padding: const EdgeInsets.only(
                bottom: 14,
              ),
              child: ChapterCard(
                key: ValueKey(chapter.id),
                number: index + 1,
                chapter: chapter,
                canDelete: day.chapters.length > 1,
                onChanged: () {
                  setState(() {});
                },
                onDelete: () {
                  setState(() {
                    day.chapters.removeAt(index);
                  });
                },
              ),
            );
          },
        ),
        OutlinedButton.icon(
          onPressed: () {
            setState(() {
              day.chapters.add(
                ChapterEntry(
                  id: DateTime.now().microsecondsSinceEpoch.toString(),
                  reference: '',
                ),
              );
            });
          },
          icon: const Icon(Icons.add),
          label: const Text('Add chapter'),
        ),
        const SizedBox(height: 14),
        FilledButton.icon(
          onPressed: save,
          icon: const Icon(Icons.save),
          label: const Text('Save'),
        ),
      ],
    );
  }
}

// ============================================================
// BIBLE READING TRACKER SCREEN (NEW FEATURE)
// ============================================================

class BibleTrackerScreen extends StatefulWidget {
  const BibleTrackerScreen({super.key});

  @override
  State<BibleTrackerScreen> createState() => _BibleTrackerScreenState();
}

class _BibleTrackerScreenState extends State<BibleTrackerScreen> {
  final Map<String, int> newTestamentBooks = {
    'MATTHEW': 28,
    'MARK': 16,
    'LUKE': 24,
    'JOHN': 21,
    'ACTS': 28,
    'ROMANS': 16,
    '1 CORINTHIANS': 16,
    '2 CORINTHIANS': 13,
    'GALATIANS': 6,
    'EPHESIANS': 6,
    'PHILIPPIANS': 4,
    'COLOSSIANS': 4,
    '1 THESSALONIANS': 5,
    '2 THESSALONIANS': 3,
    '1 TIMOTHY': 6,
    '2 TIMOTHY': 4,
    'TITUS': 3,
    'PHILEMON': 1,
    'HEBREWS': 13,
    'JAMES': 5,
    '1 PETER': 5,
    '2 PETER': 3,
    '1 JOHN': 5,
    '2 JOHN': 1,
    '3 JOHN': 1,
    'JUDE': 1,
    'REVELATION': 22,
  };

  Set<String> completedChapters = {};
  bool loadingTracker = true;

  @override
  void initState() {
    super.initState();
    _loadTracker();
  }

  Future<void> _loadTracker() async {
    final progress = await StudyStorage.loadTrackerProgress();
    if (!mounted) return;
    setState(() {
      completedChapters = progress;
      loadingTracker = false;
    });
  }

  void _toggleChapter(String book, int chapterNum) {
    final key = '$book:$chapterNum';
    setState(() {
      if (completedChapters.contains(key)) {
        completedChapters.remove(key);
      } else {
        completedChapters.add(key);
      }
    });
    StudyStorage.saveTrackerProgress(completedChapters);
  }

  int get totalCompletedCount => completedChapters.length;
  int get totalChaptersCount =>
      newTestamentBooks.values.fold(0, (sum, count) => sum + count);

  @override
  Widget build(BuildContext context) {
    if (loadingTracker) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final progressPercent =
        (totalCompletedCount / totalChaptersCount).clamp(0.0, 1.0);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CustomScrollView(
      slivers: [
        SliverAppBar.large(
          pinned: true,
          title: const Text('New Testament Tracker'),
          actions: const [ThemeToggleButton()],
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Header Card matching the style of the reference image
              Card(
                elevation: 0,
                color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF0EBF9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      const Text(
                        'NEW TESTAMENT',
                        style: TextStyle(
                          fontSize: 14,
                          letterSpacing: 2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'BIBLE READING TRACKER',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.black26 : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '"All Scripture is God-breathed and isHere is the updated complete code for your **Bitaniya Bible Study** application. It retains all your existing features, data structures, and storage logic while adding:

1. **Dark & Light Mode Support:** A persistent theme switcher added to the app bar so you can toggle between light and dark themes seamlessly.
2. **New Testament Bible Reading Tracker:** A brand-new tab featuring all 27 books of the New Testament with interactive chapter circles (matching your reference layout) that save your reading progress automatically.

```dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('is_dark_mode') ?? false;

  runApp(BitaniyaBibleStudyApp(initialDarkMode: isDarkMode));
}

class ThemeController {
  static final ValueNotifier<bool> isDarkMode = ValueNotifier<bool>(false);
}

class BitaniyaBibleStudyApp extends StatelessWidget {
  final bool initialDarkMode;

  const BitaniyaBibleStudyApp({
    super.key,
    required this.initialDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    ThemeController.isDarkMode.value = initialDarkMode;

    return ValueListenableBuilder<bool>(
      valueListenable: ThemeController.isDarkMode,
      builder: (context, darkEnabled, _) {
        return MaterialApp(
          title: 'Bitaniya Bible Study',
          debugShowCheckedModeBanner: false,
          themeMode: darkEnabled ? ThemeMode.dark : ThemeMode.light,
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            colorSchemeSeed: const Color(0xFF6A4BBC),
            scaffoldBackgroundColor: const Color(0xFFF7F5FB),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: Color(0xFF6A4BBC),
                  width: 1.5,
                ),
              ),
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            colorSchemeSeed: const Color(0xFF9D7FEA),
            scaffoldBackgroundColor: const Color(0xFF121018),
            cardColor: const Color(0xFF1E1A29),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: const Color(0xFF262135),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.grey.shade800),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: Color(0xFF9D7FEA),
                  width: 1.5,
                ),
              ),
            ),
          ),
          home: const AppShell(),
        );
      },
    );
  }
}

// ============================================================
// DATA MODELS
// ============================================================

class ChapterEntry {
  String id;
  String reference;

  String keyVerse;
  String summary;
  String observations;
  String meaning;
  String lessons;
  String application;
  String questions;
  String prayer;

  String characterName;
  String characterWho;
  String characterTraits;
  String characterActions;
  String characterLessons;

  ChapterEntry({
    required this.id,
    required this.reference,
    this.keyVerse = '',
    this.summary = '',
    this.observations = '',
    this.meaning = '',
    this.lessons = '',
    this.application = '',
    this.questions = '',
    this.prayer = '',
    this.characterName = '',
    this.characterWho = '',
    this.characterTraits = '',
    this.characterActions = '',
    this.characterLessons = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reference': reference,
      'keyVerse': keyVerse,
      'summary': summary,
      'observations': observations,
      'meaning': meaning,
      'lessons': lessons,
      'application': application,
      'questions': questions,
      'prayer': prayer,
      'characterName': characterName,
      'characterWho': characterWho,
      'characterTraits': characterTraits,
      'characterActions': characterActions,
      'characterLessons': characterLessons,
    };
  }

  factory ChapterEntry.fromJson(Map<String, dynamic> json) {
    return ChapterEntry(
      id: json['id']?.toString() ??
          DateTime.now().microsecondsSinceEpoch.toString(),
      reference: json['reference']?.toString() ?? '',
      keyVerse: json['keyVerse']?.toString() ?? '',
      summary: json['summary']?.toString() ?? '',
      observations: json['observations']?.toString() ?? '',
      meaning: json['meaning']?.toString() ?? '',
      lessons: json['lessons']?.toString() ?? '',
      application: json['application']?.toString() ?? '',
      questions: json['questions']?.toString() ?? '',
      prayer: json['prayer']?.toString() ?? '',
      characterName: json['characterName']?.toString() ?? '',
      characterWho: json['characterWho']?.toString() ?? '',
      characterTraits: json['characterTraits']?.toString() ?? '',
      characterActions: json['characterActions']?.toString() ?? '',
      characterLessons: json['characterLessons']?.toString() ?? '',
    );
  }
}

class StudyDay {
  String dateKey;
  List<ChapterEntry> chapters;

  StudyDay({
    required this.dateKey,
    required this.chapters,
  });

  Map<String, dynamic> toJson() {
    return {
      'dateKey': dateKey,
      'chapters': chapters.map((c) => c.toJson()).toList(),
    };
  }

  factory StudyDay.fromJson(Map<String, dynamic> json) {
    final rawChapters = json['chapters'];

    final chapters = <ChapterEntry>[];

    if (rawChapters is List) {
      for (final item in rawChapters) {
        if (item is Map) {
          chapters.add(
            ChapterEntry.fromJson(
              Map<String, dynamic>.from(item),
            ),
          );
        }
      }
    }

    return StudyDay(
      dateKey: json['dateKey']?.toString() ?? '',
      chapters: chapters,
    );
  }
}

// ============================================================
// STORAGE
// ============================================================

class StudyStorage {
  static const String storageKey = 'bitaniya_bible_studies';
  static const String trackerKey = 'bitaniya_nt_tracker';

  static Future<List<StudyDay>> loadDays() async {
    final prefs = await SharedPreferences.getInstance();

    final raw = prefs.getString(storageKey);

    if (raw == null || raw.trim().isEmpty) {
      return [];
    }

    try {
      final decoded = jsonDecode(raw);

      if (decoded is! List) {
        return [];
      }

      return decoded
          .whereType<Map>()
          .map(
            (item) => StudyDay.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> saveDays(List<StudyDay> days) async {
    final prefs = await SharedPreferences.getInstance();

    final data = days.map((day) => day.toJson()).toList();

    await prefs.setString(
      storageKey,
      jsonEncode(data),
    );
  }

  static Future<Set<String>> loadTrackerProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(trackerKey);
    return list != null ? list.toSet() : {};
  }

  static Future<void> saveTrackerProgress(Set<String> progress) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(trackerKey, progress.toList());
  }

  static Future<String> createBackup(List<StudyDay> days) async {
    final prefs = await SharedPreferences.getInstance();
    final trackerList = prefs.getStringList(trackerKey) ?? [];

    final backup = {
      'app': 'Bitaniya Bible Study',
      'version': 2,
      'createdAt': DateTime.now().toIso8601String(),
      'studies': days.map((day) => day.toJson()).toList(),
      'tracker': trackerList,
    };

    return const JsonEncoder.withIndent('  ').convert(backup);
  }

  static Future<bool> restoreBackup(String text) async {
    try {
      final decoded = jsonDecode(text);

      if (decoded is! Map) {
        return false;
      }

      final rawStudies = decoded['studies'];

      if (rawStudies is! List) {
        return false;
      }

      final restored = <StudyDay>[];

      for (final item in rawStudies) {
        if (item is Map) {
          restored.add(
            StudyDay.fromJson(
              Map<String, dynamic>.from(item),
            ),
          );
        }
      }

      await saveDays(restored);

      final rawTracker = decoded['tracker'];
      if (rawTracker is List) {
        await saveTrackerProgress(rawTracker.map((e) => e.toString()).toSet());
      }

      return true;
    } catch (_) {
      return false;
    }
  }
}

// ============================================================
// APP SHELL
// ============================================================

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int currentIndex = 0;

  List<StudyDay> days = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final loaded = await StudyStorage.loadDays();

    if (!mounted) return;

    setState(() {
      days = loaded;
      loading = false;
    });
  }

  Future<void> saveData() async {
    await StudyStorage.saveDays(days);

    if (!mounted) return;

    setState(() {});
  }

  void updateDay(StudyDay day) {
    final index = days.indexWhere(
      (item) => item.dateKey == day.dateKey,
    );

    setState(() {
      if (index >= 0) {
        days[index] = day;
      } else {
        days.add(day);
      }
    });

    saveData();
  }

  void deleteDay(String dateKey) {
    setState(() {
      days.removeWhere(
        (day) => day.dateKey == dateKey,
      );
    });

    saveData();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final pages = [
      HomeScreen(
        days: days,
        onOpenDay: (day) {
          setState(() {
            currentIndex = 1;
          });
        },
        onDeleteDay: deleteDay,
      ),
      DailyStudyScreen(
        days: days,
        onSaveDay: updateDay,
      ),
      const ReadingTrackerScreen(),
      BackupScreen(
        days: days,
        onRestored: loadData,
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: pages[currentIndex],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            currentIndex = index;
          });
        },
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
            icon: Icon(Icons.checklist_outlined),
            selectedIcon: Icon(Icons.checklist),
            label: 'Tracker',
          ),
          NavigationDestination(
            icon: Icon(Icons.backup_outlined),
            selectedIcon: Icon(Icons.backup),
            label: 'Backup',
          ),
        ],
      ),
    );
  }
}

// ============================================================
// THEME TOGGLE BUTTON WIDGET
// ============================================================

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  Future<void> _toggleTheme() async {
    final newValue = !ThemeController.isDarkMode.value;
    ThemeController.isDarkMode.value = newValue;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_dark_mode', newValue);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Toggle Theme',
      onPressed: _toggleTheme,
      icon: Icon(
        ThemeController.isDarkMode.value
            .light_mode_outlined ??
            Icons.dark_mode_outlined,
      ),
    );
  }
}

// ============================================================
// HOME SCREEN
// ============================================================

class HomeScreen extends StatelessWidget {
  final List<StudyDay> days;
  final void Function(StudyDay day) onOpenDay;
  final void Function(String dateKey) onDeleteDay;

  const HomeScreen({
    super.key,
    required this.days,
    required this.onOpenDay,
    required this.onDeleteDay,
  });

  String formatDate(String dateKey) {
    try {
      final date = DateTime.parse(dateKey);

      return '${date.day}/${date.month}/${date.year}';
    } catch (_) {
      return dateKey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final sorted = [...days];

    sorted.sort(
      (a, b) => b.dateKey.compareTo(a.dateKey),
    );

    final completedDays = sorted.length;

    final totalChapters = sorted.fold<int>(
      0,
      (sum, day) => sum + day.chapters.length,
    );

    return CustomScrollView(
      slivers: [
        SliverAppBar.large(
          pinned: true,
          title: const Text('Bitaniya Bible Study'),
          actions: [
            const ThemeToggleButton(),
            IconButton(
              tooltip: 'New study',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Open the Study tab to start today’s study.',
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            16,
            8,
            16,
            24,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.calendar_month,
                        value: '$completedDays',
                        label: 'Study days',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.menu_book,
                        value: '$totalChapters',
                        label: 'Chapters',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Your Study History',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                if (sorted.isEmpty)
                  _EmptyCard(
                    icon: Icons.menu_book_outlined,
                    title: 'No studies yet',
                    message:
                        'Start your first Bible study from the Study tab.',
                  )
                else
                  ...sorted.map(
                    (day) => Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        leading: CircleAvatar(
                          child: Text(
                            '${day.chapters.length}',
                          ),
                        ),
                        title: Text(
                          formatDate(day.dateKey),
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        subtitle: Text(
                          day.chapters
                              .map((c) => c.reference)
                              .where((x) => x.isNotEmpty)
                              .join(' • '),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'delete') {
                              _confirmDelete(
                                context,
                                day,
                              );
                            }
                          },
                          itemBuilder: (context) => const [
                            PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete'),
                            ),
                          ],
                        ),
                        onTap: () {
                          onOpenDay(day);

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => StandaloneDayEditor(
                                day: day,
                                onSave: (updated) {
                                  onOpenDay(updated);
                                },
                              ),
                            ),
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
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    StudyDay day,
  ) async {
    final answer = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete study?'),
          content: Text(
            'Delete the study for ${formatDate(day.dateKey)}?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (answer == true) {
      onDeleteDay(day.dateKey);
    }
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
          children: [
            Icon(icon, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const _EmptyCard({
    required this.icon,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          children: [
            Icon(
              icon,
              size: 48,
              color: Colors.grey,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// DAILY STUDY SCREEN
// ============================================================

class DailyStudyScreen extends StatefulWidget {
  final List<StudyDay> days;
  final void Function(StudyDay day) onSaveDay;

  const DailyStudyScreen({
    super.key,
    required this.days,
    required this.onSaveDay,
  });

  @override
  State<DailyStudyScreen> createState() => _DailyStudyScreenState();
}

class _DailyStudyScreenState extends State<DailyStudyScreen> {
  late DateTime selectedDate;
  StudyDay? currentDay;

  @override
  void initState() {
    super.initState();

    selectedDate = DateTime.now();

    _loadSelectedDay();
  }

  String dateKey(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');

    return '$y-$m-$d';
  }

  void _loadSelectedDay() {
    final key = dateKey(selectedDate);

    final existing = widget.days.where(
      (day) => day.dateKey == key,
    );

    if (existing.isNotEmpty) {
      currentDay = _copyDay(existing.first);
    } else {
      currentDay = StudyDay(
        dateKey: key,
        chapters: [
          ChapterEntry(
            id: DateTime.now().microsecondsSinceEpoch.toString(),
            reference: '',
          ),
          ChapterEntry(
            id: (DateTime.now().microsecondsSinceEpoch + 1).toString(),
            reference: '',
          ),
          ChapterEntry(
            id: (DateTime.now().microsecondsSinceEpoch + 2).toString(),
            reference: '',
          ),
        ],
      );
    }
  }

  StudyDay _copyDay(StudyDay day) {
    return StudyDay(
      dateKey: day.dateKey,
      chapters: day.chapters
          .map(
            (chapter) => ChapterEntry.fromJson(
              chapter.toJson(),
            ),
          )
          .toList(),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked == null) return;

    setState(() {
      selectedDate = picked;
      _loadSelectedDay();
    });
  }

  void _save() {
    final day = currentDay;

    if (day == null) return;

    widget.onSaveDay(
      _copyDay(day),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Study saved'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _addChapter() {
    setState(() {
      currentDay!.chapters.add(
        ChapterEntry(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          reference: '',
        ),
      );
    });
  }

  void _removeChapter(int index) {
    if (currentDay!.chapters.length <= 1) {
      return;
    }

    setState(() {
      currentDay!.chapters.removeAt(index);
    });

    _saveSilently();
  }

  void _saveSilently() {
    final day = currentDay;

    if (day != null) {
      widget.onSaveDay(
        _copyDay(day),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final day = currentDay;

    if (day == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          title: const Text('Daily Study'),
          actions: [
            const ThemeToggleButton(),
            IconButton(
              tooltip: 'Save',
              onPressed: _save,
              icon: const Icon(Icons.save_outlined),
            ),
          ],
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            16,
            12,
            16,
            30,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                _buildDayHeader(),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${day.chapters.length} '
                        '${day.chapters.length == 1 ? 'chapter' : 'chapters'}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: _addChapter,
                      icon: const Icon(Icons.add),
                      label: const Text('Add chapter'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...List.generate(
                  day.chapters.length,
                  (index) {
                    final chapter = day.chapters[index];

                    return Padding(
                      padding: const EdgeInsets.only(
                        bottom: 14,
                      ),
                      child: ChapterCard(
                        key: ValueKey(chapter.id),
                        number: index + 1,
                        chapter: chapter,
                        canDelete: day.chapters.length > 1,
                        onChanged: () {
                          _saveSilently();
                        },
                        onDelete: () {
                          _removeChapter(index);
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton.icon(
                    onPressed: _save,
                    icon: const Icon(Icons.save),
                    label: const Text(
                      'SAVE TODAY’S STUDY',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
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

  Widget _buildDayHeader() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Study Day',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: _pickDate,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Date',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                child: Text(
                  '${selectedDate.day}/'
                  '${selectedDate.month}/'
                  '${selectedDate.year}',
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Plan as many chapters as you want. '
              'Three chapters are provided by default, '
              'but the number is completely optional.',
              style: TextStyle(
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// NEW TESTAMENT BIBLE READING TRACKER SCREEN
// ============================================================

class ReadingTrackerScreen extends StatefulWidget {
  const ReadingTrackerScreen({super.key});

  @override
  State<ReadingTrackerScreen> createState() => _ReadingTrackerScreenState();
}

class _ReadingTrackerScreenState extends State<ReadingTrackerScreen> {
  Set<String> completedChapters = {};
  bool loading = true;

  final Map<String, int> ntBooks = {
    'MATTHEW': 28,
    'MARK': 16,
    'LUKE': 24,
    'JOHN': 21,
    'ACTS': 28,
    'ROMANS': 16,
    '1 CORINTHIANS': 16,
    '2 CORINTHIANS': 13,
    'GALATIANS': 6,
    'EPHESIANS': 6,
    'PHILIPPIANS': 4,
    'COLOSSIANS': 4,
    '1 THESSALONIANS': 5,
    '2 THESSALONIANS': 3,
    '1 TIMOTHY': 6,
    '2 TIMOTHY': 4,
    'TITUS': 3,
    'PHILEMON': 1,
    'HEBREWS': 13,
    'JAMES': 5,
    '1 PETER': 5,
    '2 PETER': 3,
    '1 JOHN': 5,
    '2 JOHN': 1,
    '3 JOHN': 1,
    'JUDE': 1,
    'REVELATION': 22,
  };

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final progress = await StudyStorage.loadTrackerProgress();
    if (!mounted) return;
    setState(() {
      completedChapters = progress;
      loading = false;
    });
  }

  Future<void> _toggleChapter(String book, int chapter) async {
    final key = '$book:$chapter';
    setState(() {
      if (completedChapters.contains(key)) {
        completedChapters.remove(key);
      } else {
        completedChapters.add(key);
      }
    });
    await StudyStorage.saveTrackerProgress(completedChapters);
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final totalNtChapters = ntBooks.values.fold(0, (sum, val) => sum + val);
    final readCount = completedChapters.length;
    final progressPercent = totalNtChapters > 0 ? readCount / totalNtChapters : 0.0;

    return CustomScrollView(
      slivers: [
        SliverAppBar.large(
          pinned: true,
          title: const Text('NT Bible Tracker'),
          actions: const [
            ThemeToggleButton(),
          ],
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text(
                        '"All Scripture is God-breathed and is useful for teaching, rebuking, correcting and training in righteousness..."',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        '– 2 Timothy 3:16-17',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 16),
                      LinearProgressIndicator(
                        value: progressPercent,
                        minHeight: 10,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '$readCount of $totalNtChapters chapters read (${(progressPercent * 100).toStringAsFixed(1)}%)',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ...ntBooks.entries.map((entry) {
                final bookName = entry.key;
                final count = entry.value;

                return Card(
                  margin: const EdgeInsets.only(bottom: 14),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            bookName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: List.generate(count, (index) {
                            final chapterNum = index + 1;
                            final isChecked = completedChapters.contains('$bookName:$chapterNum');

                            return InkWell(
                              onTap: () => _toggleChapter(bookName, chapterNum),
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                width: 32,
                                height: 32,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Theme.of(context).colorScheme.primary,
                                    width: 1.5,
                                  ),
                                  color: isChecked
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.transparent,
                                ),
                                child: Text(
                                  '$chapterNum',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: isChecked
                                        ? Theme.of(context).colorScheme.onPrimary
                                        : Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ]),
          ),
        ),
      ],
    );
  }
}

// ============================================================
// STANDALONE DAY EDITOR
// ============================================================

class StandaloneDayEditor extends StatelessWidget {
  final StudyDay day;
  final void Function(StudyDay day) onSave;

  const StandaloneDayEditor({
    super.key,
    required this.day,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Study'),
        actions: const [
          ThemeToggleButton(),
        ],
      ),
      body: DailyStudyEditorBody(
        initialDay: day,
        onSave: (updated) {
          onSave(updated);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Study saved'),
            ),
          );
        },
      ),
    );
  }
}

class DailyStudyEditorBody extends StatefulWidget {
  final StudyDay initialDay;
  final void Function(StudyDay day) onSave;

  const DailyStudyEditorBody({
    super.key,
    required this.initialDay,
    required this.onSave,
  });

  @override
  State<DailyStudyEditorBody> createState() =>
      _DailyStudyEditorBodyState();
}

class _DailyStudyEditorBodyState
    extends State<DailyStudyEditorBody> {
  late StudyDay day;

  @override
  void initState() {
    super.initState();

    day = StudyDay.fromJson(
      widget.initialDay.toJson(),
    );
  }

  void save() {
    widget.onSave(
      StudyDay.fromJson(
        day.toJson(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ...List.generate(
          day.chapters.length,
          (index) {
            final chapter = day.chapters[index];

            return Padding(
              padding: const EdgeInsets.only(
                bottom: 14,
              ),
              child: ChapterCard(
                key: ValueKey(chapter.id),
                number: index + 1,
                chapter: chapter,
                canDelete: day.chapters.length > 1,
                onChanged: () {
                  setState(() {});
                },
                onDelete: () {
                  setState(() {
                    day.chapters.removeAt(index);
                  });
                },
              ),
            );
          },
        ),
        OutlinedButton.icon(
          onPressed: () {
            setState(() {
              day.chapters.add(
                ChapterEntry(
                  id: DateTime.now().microsecondsSinceEpoch.toString(),
                  reference: '',
                ),
              );
            });
          },
          icon: const Icon(Icons.add),
          label: const Text('Add chapter'),
        ),
        const SizedBox(height: 14),
        FilledButton.icon(
          onPressed: save,
          icon: const Icon(Icons.save),
          label: const Text('Save'),
        ),
      ],
    );
  }
}

// ============================================================
// CHAPTER CARD
// ============================================================

class ChapterCard extends StatefulWidget {
  final int number;
  final ChapterEntry chapter;
  final bool canDelete;
  final VoidCallback onChanged;
  final VoidCallback onDelete;

  const ChapterCard({
    super.key,
    required this.number,
    required this.chapter,
    required this.canDelete,
    required this.onChanged,
    required this.onDelete,
  });

  @override
  State<ChapterCard> createState() => _ChapterCardState();
}

class _ChapterCardState extends State<ChapterCard> {
  late final TextEditingController referenceController;
  late final TextEditingController keyVerseController;
  late final TextEditingController summaryController;
  late final TextEditingController observationsController;
  late final TextEditingController meaningController;
  late final TextEditingController lessonsController;
  late final TextEditingController applicationController;
  late final TextEditingController questionsController;
  late final TextEditingController prayerController;

  late final TextEditingController characterNameController;
  late final TextEditingController characterWhoController;
  late final TextEditingController characterTraitsController;
  late final TextEditingController characterActionsController;
  late final TextEditingController characterLessonsController;

  @override
  void initState() {
    super.initState();

    referenceController = TextEditingController(
      text: widget.chapter.reference,
    );

    keyVerseController = TextEditingController(
      text: widget.chapter.keyVerse,
    );

    summaryController = TextEditingController(
      text: widget.chapter.summary,
    );

    observationsController = TextEditingController(
      text: widget.chapter.observations,
    );

    meaningController = TextEditingController(
      text: widget.chapter.meaning,
    );

    lessonsController = TextEditingController(
      text: widget.chapter.lessons,
    );

    applicationController = TextEditingController(
      text: widget.chapter.application,
    );

    questionsController = TextEditingController(
      text: widget.chapter.questions,
    );

    prayerController = TextEditingController(
      text: widget.chapter.prayer,
    );

    characterNameController = TextEditingController(
      text: widget.chapter.characterName,
    );

    characterWhoController = TextEditingController(
      text: widget.chapter.characterWho,
    );

    characterTraitsController = TextEditingController(
      text: widget.chapter.characterTraits,
    );

    characterActionsController = TextEditingController(
      text: widget.chapter.characterActions,
    );

    characterLessonsController = TextEditingController(
      text: widget.chapter.characterLessons,
    );
  }

  @override
  void dispose() {
    referenceController.dispose();
    keyVerseController.dispose();
    summaryController.dispose();
    observationsController.dispose();
    meaningController.dispose();
    lessonsController.dispose();
    applicationController.dispose();
    questionsController.dispose();
    prayerController.dispose();

    characterNameController.dispose();
    characterWhoController.dispose();
    characterTraitsController.dispose();
    characterActionsController.dispose();
    characterLessonsController.dispose();

    super.dispose();
  }

  void sync() {
    widget.chapter.reference = referenceController.text;
    widget.chapter.keyVerse = keyVerseController.text;
    widget.chapter.summary = summaryController.text;
    widget.chapter.observations = observationsController.text;
    widget.chapter.meaning = meaningController.text;
    widget.chapter.lessons = lessonsController.text;
    widget.chapter.application = applicationController.text;
    widget.chapter.questions = questionsController.text;
    widget.chapter.prayer = prayerController.text;

    widget.chapter.characterName = characterNameController.text;
    widget.chapter.characterWho = characterWhoController.text;
    widget.chapter.characterTraits = characterTraitsController.text;
    widget.chapter.characterActions = characterActionsController.text;
    widget.chapter.characterLessons = characterLessonsController.text;

    widget.onChanged();
  }

  Widget field(
    String label,
    TextEditingController controller, {
    String? hint,
    int minLines = 2,
    int maxLines = 6,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        minLines: minLines,
        maxLines: maxLines,
        textCapitalization: TextCapitalization.sentences,
        onChanged: (_) => sync(),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          alignLabelWithHint: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        initiallyExpanded: true,
        tilePadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 5,
        ),
        title: Text(
          'Chapter ${widget.number}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Text(
          widget.chapter.reference.isEmpty
              ? 'Enter chapter reference'
              : widget.chapter.reference,
        ),
        childrenPadding: const EdgeInsets.fromLTRB(
          16,
          0,
          16,
          16,
        ),
        children: [
          TextField(
            controller: referenceController,
            onChanged: (_) => sync(),
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Bible reference',
              hintText: 'Example: Matthew 5',
              prefixIcon: Icon(Icons.menu_book),
            ),
          ),
          const SizedBox(height: 18),

          // --------------------------------------------------
          // MAIN CHAPTER STUDY
          // --------------------------------------------------

          const _SectionTitle(
            icon: Icons.search,
            title: 'Chapter Study',
          ),

          field(
            'Key verse',
            keyVerseController,
            hint: 'Which verse stands out to you?',
          ),

          field(
            'What happens in this chapter?',
            summaryController,
            hint: 'Summarize the chapter in your own words.',
          ),

          field(
            'What do you notice?',
            observationsController,
            hint:
                'Important people, events, commands, promises, '
                'repeated words, contrasts, etc.',
          ),

          field(
            'What does it mean?',
            meaningController,
            hint:
                'What do you think the main message of the chapter is?',
          ),

          field(
            'What does this teach me about God?',
            lessonsController,
            hint:
                'God’s character, His will, His promises, His actions, etc.',
          ),

          field(
            'How should I respond?',
            applicationController,
            hint:
                'What can you believe, change, obey, practice, or remember?',
          ),

          field(
            'Questions I still have',
            questionsController,
            hint:
                'Write anything you do not understand or want to study later.',
          ),

          // --------------------------------------------------
          // CHARACTER STUDY
          // --------------------------------------------------

          const Divider(height: 25),

          ExpansionTile(
            tilePadding: EdgeInsets.zero,
            title: const Text(
              'Character Study',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            subtitle: const Text(
              'Study a person from this chapter',
            ),
            leading: const Icon(Icons.person_outline),
            children: [
              const SizedBox(height: 8),

              field(
                'Character name',
                characterNameController,
                hint: 'Example: Peter',
                minLines: 1,
                maxLines: 2,
              ),

              field(
                'Who is this person?',
                characterWhoController,
                hint:
                    'What do we learn about their identity and role?',
              ),

              field(
                'What character traits do I see?',
                characterTraitsController,
                hint:
                    'Faith, courage, weakness, humility, pride, obedience, etc.',
              ),

              field(
                'What did this person do?',
                characterActionsController,
                hint:
                    'Important choices, words, actions, successes, failures.',
              ),

              field(
                'What can I learn from this person?',
                characterLessonsController,
                hint:
                    'What should I imitate, avoid, or learn from their story?',
              ),
            ],
          ),

          // --------------------------------------------------
          // PRAYER
          // --------------------------------------------------

          const Divider(height: 25),

          const _SectionTitle(
            icon: Icons.favorite_outline,
            title: 'Response',
          ),

          field(
            'Prayer / personal response',
            prayerController,
            hint:
                'Write a short prayer or personal response to what you studied.',
          ),

          if (widget.canDelete)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: widget.onDelete,
                icon: const Icon(Icons.delete_outline),
                label: const Text('Remove chapter'),
              ),
            ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionTitle({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 6,
        bottom: 14,
      ),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// BACKUP SCREEN
// ============================================================

class BackupScreen extends StatefulWidget {
  final List<StudyDay> days;
  final Future<void> Function() onRestored;

  const BackupScreen({
    super.key,
    required this.days,
    required this.onRestored,
  });

  @override
  State<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends State<BackupScreen> {
  late final TextEditingController backupController;

  bool showingBackup = false;

  @override
  void initState() {
    super.initState();

    backupController = TextEditingController();
  }

  @override
  void dispose() {
    backupController.dispose();
    super.dispose();
  }

  Future<void> createBackup() async {
    final backup = await StudyStorage.createBackup(
      widget.days,
    );

    setState(() {
      backupController.text = backup;
      showingBackup = true;
    });
  }

  Future<void> copyBackup() async {
    if (backupController.text.trim().isEmpty) {
      await createBackup();
    }

    await Clipboard.setData(
      ClipboardData(
        text: backupController.text,
      ),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Backup copied. Paste it into a safe file.',
        ),
      ),
    );
  }

  Future<void> restoreBackup() async {
    final text = backupController.text.trim();

    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Paste your backup first.'),
        ),
      );

      return;
    }

    final success = await StudyStorage.restoreBackup(
      text,
    );

    if (!mounted) return;

    if (success) {
      await widget.onRestored();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Backup restored successfully.',
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'That backup is not valid.',
          ),
        ),
      );
    }
  }

  Future<void> confirmRestore() async {
    final answer = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Restore backup?'),
          content: const Text(
            'Restoring will replace the current study data '
            'with the backup data.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Restore'),
            ),
          ],
        );
      },
    );

    if (answer == true) {
      await restoreBackup();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverAppBar.large(
          title: Text('Backup & Restore'),
          actions: [
            ThemeToggleButton(),
          ],
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            16,
            8,
            16,
            30,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.security,
                          size: 38,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Protect your Bible studies',
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${widget.days.length} study days '
                          'are currently saved.',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Create a backup and keep the text somewhere '
                          'safe. You can paste it back here later to '
                          'restore your studies.',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                SizedBox(
                  height: 52,
                  child: FilledButton.icon(
                    onPressed: createBackup,
                    icon: const Icon(Icons.backup),
                    label: const Text(
                      'CREATE BACKUP',
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                SizedBox(
                  height: 52,
                  child: OutlinedButton.icon(
                    onPressed: copyBackup,
                    icon: const Icon(Icons.copy),
                    label: const Text(
                      'COPY BACKUP',
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                const Text(
                  'Restore',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Paste a backup below, then press Restore.',
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: backupController,
                  minLines: 12,
                  maxLines: 25,
                  decoration: const InputDecoration(
                    labelText: 'Backup data',
                    hintText: 'Paste your backup here',
                    alignLabelWithHint: true,
                  ),
                ),

                const SizedBox(height: 10),

                SizedBox(
                  height: 52,
                  child: FilledButton.icon(
                    onPressed: confirmRestore,
                    icon: const Icon(Icons.restore),
                    label: const Text(
                      'RESTORE BACKUP',
                    ),
                  ),
                ),

                if (showingBackup) ...[
                  const SizedBox(height: 20),
                  const Text(
                    'Your backup is ready',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Copy the text above and save it somewhere safe.',
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
