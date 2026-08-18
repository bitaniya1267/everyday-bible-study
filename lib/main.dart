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

class _BitaniyaBibleStudyAppState
    extends State<BitaniyaBibleStudyApp> {
  ThemeMode themeMode = ThemeMode.light;
  bool loadingTheme = true;

  @override
  void initState() {
    super.initState();
    loadTheme();
  }

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final dark = prefs.getBool('bitaniya_dark_mode') ?? false;

    if (!mounted) return;

    setState(() {
      themeMode = dark ? ThemeMode.dark : ThemeMode.light;
      loadingTheme = false;
    });
  }

  Future<void> toggleTheme(bool dark) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(
      'bitaniya_dark_mode',
      dark,
    );

    if (!mounted) return;

    setState(() {
      themeMode = dark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  ThemeData get lightTheme {
    const primary = Color(0xFF5A3E8E);
    const background = Color(0xFFF8F6FB);
    const surface = Color(0xFFFFFCFF);

    return ThemeData(
      useMaterial3: true,
      cardTheme: CardThemeData(elevation: 1.5, margin: EdgeInsets.zero),
      navigationBarTheme: NavigationBarThemeData(elevation: 2),
      appBarTheme: const AppBarTheme(centerTitle: false),
      colorSchemeSeed: primary,
      brightness: Brightness.light,
      scaffoldBackgroundColor: background,
      cardTheme: CardTheme(
        color: surface,
        elevation: 1.5,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(
            color: Color(0xFFE9E2F1),
            width: 0.8,
          ),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        elevation: 2,
        indicatorColor: Color(0xFFE8DDF5),
        labelTextStyle: MaterialStatePropertyAll(
          TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          side: const BorderSide(color: Color(0xFFB9A7CC)),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        minLinearTrackHeight: 7,
      ),
      dividerTheme: const DividerThemeData(
        space: 24,
        thickness: 0.7,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFFE5DDEA)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFFE5DDEA)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: primary, width: 1.5),
        ),
      ),
    );
  }

  ThemeData get darkTheme {
    const primary = Color(0xFFB99AE8);
    const background = Color(0xFF111014);
    const surface = Color(0xFF1B181F);

    return ThemeData(
      useMaterial3: true,
      cardTheme: CardThemeData(elevation: 1.5, margin: EdgeInsets.zero),
      navigationBarTheme: NavigationBarThemeData(elevation: 2),
      appBarTheme: const AppBarTheme(centerTitle: false),
      colorSchemeSeed: const Color(0xFF8061B5),
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      cardTheme: CardTheme(
        color: surface,
        elevation: 1.5,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(
            color: Color(0xFF332D3A),
            width: 0.8,
          ),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        elevation: 2,
        indicatorColor: Color(0xFF40344F),
        labelTextStyle: MaterialStatePropertyAll(
          TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFF39333F)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFF39333F)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: primary, width: 1.5),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          side: const BorderSide(color: Color(0xFF665A70)),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        minLinearTrackHeight: 7,
      ),
      dividerTheme: const DividerThemeData(
        space: 24,
        thickness: 0.7,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loadingTheme) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return MaterialApp(
      title: 'Bitaniya Bible Study',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      home: AppShell(
        isDarkMode: themeMode == ThemeMode.dark,
        onThemeChanged: toggleTheme,
      ),
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
// NEW TESTAMENT BOOKS
// ============================================================

class BibleBook {
  final String name;
  final int chapters;

  const BibleBook(
    this.name,
    this.chapters,
  );
}

const List<BibleBook> newTestamentBooks = [
  BibleBook('Matthew', 28),
  BibleBook('Mark', 16),
  BibleBook('Luke', 24),
  BibleBook('John', 21),
  BibleBook('Acts', 28),
  BibleBook('Romans', 16),
  BibleBook('1 Corinthians', 16),
  BibleBook('2 Corinthians', 13),
  BibleBook('Galatians', 6),
  BibleBook('Ephesians', 6),
  BibleBook('Philippians', 4),
  BibleBook('Colossians', 4),
  BibleBook('1 Thessalonians', 5),
  BibleBook('2 Thessalonians', 3),
  BibleBook('1 Timothy', 6),
  BibleBook('2 Timothy', 4),
  BibleBook('Titus', 3),
  BibleBook('Philemon', 1),
  BibleBook('Hebrews', 13),
  BibleBook('James', 5),
  BibleBook('1 Peter', 5),
  BibleBook('2 Peter', 3),
  BibleBook('1 John', 5),
  BibleBook('2 John', 1),
  BibleBook('3 John', 1),
  BibleBook('Jude', 1),
  BibleBook('Revelation', 22),
];

int get totalNewTestamentChapters {
  return newTestamentBooks.fold(
    0,
    (sum, book) => sum + book.chapters,
  );
}

// ============================================================
// STUDY STORAGE
// ============================================================

class StudyStorage {
  static const String storageKey =
      'bitaniya_bible_studies';

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

  static Future<void> saveDays(
    List<StudyDay> days,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    final data =
        days.map((day) => day.toJson()).toList();

    await prefs.setString(
      storageKey,
      jsonEncode(data),
    );
  }

  static Future<String> createBackup(
    List<StudyDay> days,
  ) async {
    final backup = {
      'app': 'Bitaniya Bible Study',
      'version': 1,
      'createdAt': DateTime.now().toIso8601String(),
      'studies':
          days.map((day) => day.toJson()).toList(),
    };

    return const JsonEncoder.withIndent('  ')
        .convert(backup);
  }

  static Future<bool> restoreBackup(
    String text,
  ) async {
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

      return true;
    } catch (_) {
      return false;
    }
  }
}

// ============================================================
// READING TRACKER STORAGE
// ============================================================

class ReadingStorage {
  static const String key =
      'bitaniya_new_testament_reading';

  static String dateKey(DateTime date) {
    final y =
        date.year.toString().padLeft(4, '0');
    final m =
        date.month.toString().padLeft(2, '0');
    final d =
        date.day.toString().padLeft(2, '0');

    return '$y-$m-$d';
  }

  static Future<Map<String, Set<String>>> load()
      async {
    final prefs =
        await SharedPreferences.getInstance();

    final raw = prefs.getString(key);

    if (raw == null || raw.isEmpty) {
      return {};
    }

    try {
      final decoded = jsonDecode(raw);

      if (decoded is! Map) {
        return {};
      }

      final result =
          <String, Set<String>>{};

      for (final entry in decoded.entries) {
        if (entry.value is List) {
          result[entry.key.toString()] = {
            ...(entry.value as List)
                .map((item) => item.toString()),
          };
        }
      }

      return result;
    } catch (_) {
      return {};
    }
  }

  static Future<void> save(
    Map<String, Set<String>> data,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    final jsonData =
        <String, dynamic>{};

    data.forEach((date, chapters) {
      jsonData[date] = chapters.toList();
    });

    await prefs.setString(
      key,
      jsonEncode(jsonData),
    );
  }
}

// ============================================================
// APP SHELL
// ============================================================

class AppShell extends StatefulWidget {
  final bool isDarkMode;
  final Future<void> Function(bool) onThemeChanged;

  const AppShell({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<AppShell> createState() =>
      _AppShellState();
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
    final loaded =
        await StudyStorage.loadDays();

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
        onOpenSettings: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => SettingsScreen(
                isDarkMode:
                    widget.isDarkMode,
                onThemeChanged:
                    widget.onThemeChanged,
              ),
            ),
          );
        },
      ),

      DailyStudyScreen(
        days: days,
        onSaveDay: updateDay,
      ),

      BackupScreen(
        days: days,
        onRestored: loadData,
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: pages[currentIndex],
      ),
      bottomNavigationBar:
          NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(
              Icons.home_outlined,
            ),
            selectedIcon: Icon(
              Icons.home,
            ),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.menu_book_outlined,
            ),
            selectedIcon: Icon(
              Icons.menu_book,
            ),
            label: 'Study',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.backup_outlined,
            ),
            selectedIcon: Icon(
              Icons.backup,
            ),
            label: 'Backup',
          ),
        ],
      ),
    );
  }
}

// ============================================================
// HOME SCREEN
// ============================================================

class HomeScreen extends StatefulWidget {
  final List<StudyDay> days;
  final void Function(StudyDay day) onOpenDay;
  final void Function(String dateKey) onDeleteDay;
  final VoidCallback onOpenSettings;

  const HomeScreen({
    super.key,
    required this.days,
    required this.onOpenDay,
    required this.onDeleteDay,
    required this.onOpenSettings,
  });

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate = DateTime.now();

  Map<String, Set<String>> progress = {};

  bool loadingReading = true;

  // The New Testament section itself is closed by default.
  bool booksExpanded = false;

  @override
  void initState() {
    super.initState();
    loadReadingProgress();
  }

  Future<void> loadReadingProgress() async {
    final loaded =
        await ReadingStorage.load();

    if (!mounted) return;

    setState(() {
      progress = loaded;
      loadingReading = false;
    });
  }

  String get currentDateKey {
    return ReadingStorage.dateKey(
      selectedDate,
    );
  }

  Set<String> get todayRead {
    return progress[currentDateKey] ??
        <String>{};
  }

  int get totalReadToday {
    return todayRead.length;
  }

  int bookReadCount(BibleBook book) {
    return todayRead
        .where(
          (id) =>
              id.startsWith(
                '${book.name}|',
              ),
        )
        .length;
  }

  double get todayPercentage {
    if (totalNewTestamentChapters == 0) {
      return 0;
    }

    return totalReadToday /
        totalNewTestamentChapters;
  }

  String formatDate(String dateKey) {
    try {
      final date =
          DateTime.parse(dateKey);

      return '${date.day}/'
          '${date.month}/'
          '${date.year}';
    } catch (_) {
      return dateKey;
    }
  }

  Future<void> toggleChapter(
    BibleBook book,
    int chapter,
  ) async {
    final id =
        '${book.name}|$chapter';

    final set =
        progress.putIfAbsent(
      currentDateKey,
      () => <String>{},
    );

    setState(() {
      if (set.contains(id)) {
        set.remove(id);
      } else {
        set.add(id);
      }
    });

    await ReadingStorage.save(
      progress,
    );
  }

  Future<void> pickReadingDate() async {
    final picked =
        await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked == null) return;

    setState(() {
      selectedDate = picked;
    });
  }

  int get studyDays {
    return widget.days.length;
  }

  int get studyChapterCount {
    return widget.days.fold<int>(
      0,
      (sum, day) =>
          sum + day.chapters.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    final sorted = [
      ...widget.days
    ];

    sorted.sort(
      (a, b) =>
          b.dateKey.compareTo(
        a.dateKey,
      ),
    );

    return CustomScrollView(
      slivers: [
        SliverAppBar.large(
          pinned: true,
          title: const Text(
            'Bitaniya Bible Study',
          ),
          actions: [
            IconButton(
              tooltip: 'New study',
              onPressed: () {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Open the Study tab to start a study.',
                    ),
                  ),
                );
              },
              icon: const Icon(
                Icons.add,
              ),
            ),
            IconButton(
              tooltip: 'Settings',
              onPressed:
                  widget.onOpenSettings,
              icon: const Icon(
                Icons.settings_outlined,
              ),
            ),
          ],
        ),

        SliverPadding(
          padding:
              const EdgeInsets.fromLTRB(
            16,
            8,
            16,
            24,
          ),
          sliver: SliverList(
            delegate:
                SliverChildListDelegate(
              [
                // ==================================================
                // TOP ROW
                // ==================================================
                //
                // Only chapter count + study days.
                // No New Testament heading here.
                // No Writing Completed tracker.
                //

                Row(
                  children: [
                    Expanded(
                      child: _TopProgressItem(
                        icon: Icons.menu_book,
                        value:
                            '$studyChapterCount',
                      ),
                    ),

                    Container(
                      height: 34,
                      width: 1,
                      color: Theme.of(
                        context,
                      )
                          .colorScheme
                          .outlineVariant,
                    ),

                    Expanded(
                      child: _TopProgressItem(
                        icon:
                            Icons.calendar_month,
                        value:
                            '$studyDays',
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 18,
                ),

                // ==================================================
                // NEW TESTAMENT BOOKS
                // ==================================================
                //
                // This is BEFORE the progress section.
                // Only ONE New Testament heading.
                //

                Card(
                  clipBehavior:
                      Clip.antiAlias,
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            booksExpanded =
                                !booksExpanded;
                          });
                        },
                        child: Padding(
                          padding:
                              const EdgeInsets
                                  .symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.menu_book,
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              const Expanded(
                                child: Text(
                                  'New Testament',
                                  style:
                                      TextStyle(
                                    fontSize: 18,
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                                ),
                              ),
                              Icon(
                                booksExpanded
                                    ? Icons
                                        .keyboard_arrow_up
                                    : Icons
                                        .keyboard_arrow_down,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Books are hidden until the
                      // New Testament section is opened.
                      if (booksExpanded)
                        ...newTestamentBooks.map(
                          _buildBookCard,
                        ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 18,
                ),

                // ==================================================
                // READING PROGRESS
                // ==================================================
                //
                // "Completed" is next to the percentage.
                // No separate Writing Completed bar.
                //

                Card(
                  child: Padding(
                    padding:
                        const EdgeInsets.all(
                      16,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.auto_stories,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Text(
                                '${(todayPercentage * 100).toStringAsFixed(1)}% Completed',
                                style:
                                    const TextStyle(
                                  fontSize: 20,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              tooltip:
                                  'Choose date',
                              onPressed:
                                  pickReadingDate,
                              icon:
                                  const Icon(
                                Icons
                                    .calendar_month,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 8,
                        ),

                        LinearProgressIndicator(
                          value:
                              todayPercentage,
                          minHeight: 7,
                        ),

                        const SizedBox(
                          height: 8,
                        ),

                        // KEEP 0 / 260 HERE.
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${selectedDate.day}/'
                                '${selectedDate.month}/'
                                '${selectedDate.year}',
                                style:
                                    TextStyle(
                                  color: Theme.of(
                                    context,
                                  )
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                              ),
                            ),
                            Text(
                              '$totalReadToday / '
                              '$totalNewTestamentChapters',
                              style:
                                  const TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(
                  height: 22,
                ),

                // ==================================================
                // STUDY HISTORY
                // ==================================================

                const Text(
                  'Your Study History',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                if (sorted.isEmpty)
                  const _EmptyCard(
                    icon: Icons
                        .menu_book_outlined,
                    title:
                        'No studies yet',
                    message:
                        'Start your first Bible study from the Study tab.',
                  )
                else
                  ...sorted.map(
                    (day) => Card(
                      margin:
                          const EdgeInsets.only(
                        bottom: 10,
                      ),
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets
                                .symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        leading:
                            CircleAvatar(
                          child: Text(
                            '${day.chapters.length}',
                          ),
                        ),
                        title: Text(
                          formatDate(
                            day.dateKey,
                          ),
                          style:
                              const TextStyle(
                            fontWeight:
                                FontWeight.w700,
                          ),
                        ),
                        subtitle: Text(
                          day.chapters
                              .map(
                                (c) =>
                                    c.reference,
                              )
                              .where(
                                (x) =>
                                    x.isNotEmpty,
                              )
                              .join(' • '),
                          maxLines: 2,
                          overflow:
                              TextOverflow
                                  .ellipsis,
                        ),
                        trailing:
                            PopupMenuButton<
                                String>(
                          onSelected:
                              (value) {
                            if (value ==
                                'delete') {
                              _confirmDelete(
                                context,
                                day,
                              );
                            }
                          },
                          itemBuilder:
                              (context) =>
                                  const [
                            PopupMenuItem(
                              value:
                                  'delete',
                              child:
                                  Text(
                                'Delete',
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.of(
                            context,
                          ).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  StandaloneDayEditor(
                                day: day,
                                onSave:
                                    (updated) {
                                  widget.onOpenDay(
                                    updated,
                                  );
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

  Widget _buildBookCard(
    BibleBook book,
  ) {
    final read =
        bookReadCount(book);

    final percentage =
        book.chapters == 0
            ? 0.0
            : read / book.chapters;

    return Padding(
      padding:
          const EdgeInsets.fromLTRB(
        10,
        0,
        10,
        8,
      ),
      child: Card(
        child: ExpansionTile(
          initiallyExpanded: false,

          leading: CircleAvatar(
            child: Text(
              '$read',
              style:
                  const TextStyle(
                fontSize: 13,
                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ),

          title: Text(
            book.name,
            style:
                const TextStyle(
              fontWeight:
                  FontWeight.w700,
            ),
          ),

          subtitle: Text(
            '$read / ${book.chapters}',
          ),

          childrenPadding:
              const EdgeInsets.fromLTRB(
            16,
            0,
            16,
            16,
          ),

          children: [
            LinearProgressIndicator(
              value: percentage,
              minHeight: 6,
            ),

            const SizedBox(
              height: 12,
            ),

            GridView.builder(
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1.4,
              ),
              itemCount:
                  book.chapters,
              itemBuilder:
                  (context, index) {
                final chapter =
                    index + 1;

                final id =
                    '${book.name}|$chapter';

                final isRead =
                    todayRead.contains(
                  id,
                );

                return InkWell(
                  borderRadius:
                      BorderRadius.circular(
                    10,
                  ),
                  onTap: () {
                    toggleChapter(
                      book,
                      chapter,
                    );
                  },
                  child: Container(
                    decoration:
                        BoxDecoration(
                      color: isRead
                          ? Theme.of(
                              context,
                            )
                              .colorScheme
                              .primary
                          : Theme.of(
                              context,
                            )
                              .colorScheme
                              .surfaceContainerHighest,
                      borderRadius:
                          BorderRadius.circular(
                        10,
                      ),
                      border:
                          Border.all(
                        color: isRead
                            ? Theme.of(
                                context,
                              )
                                .colorScheme
                                .primary
                            : Theme.of(
                                context,
                              )
                                .colorScheme
                                .outline
                                .withOpacity(
                                  0.3,
                                ),
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .center,
                        children: [
                          Icon(
                            isRead
                                ? Icons
                                    .check_circle
                                : Icons
                                    .circle_outlined,
                            size: 20,
                            color: isRead
                                ? Theme.of(
                                    context,
                                  )
                                    .colorScheme
                                    .onPrimary
                                : Theme.of(
                                    context,
                                  )
                                    .colorScheme
                                    .onSurface,
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          Text(
                            'Ch. $chapter',
                            style:
                                TextStyle(
                              fontSize: 12,
                              fontWeight:
                                  FontWeight
                                      .bold,
                              color: isRead
                                  ? Theme.of(
                                      context,
                                    )
                                      .colorScheme
                                      .onPrimary
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    StudyDay day,
  ) async {
    final answer =
        await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Delete study?',
          ),
          content: Text(
            'Delete the study for '
            '${formatDate(day.dateKey)}?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child:
                  const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              child:
                  const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (answer == true) {
      widget.onDeleteDay(
        day.dateKey,
      );
    }
  }
}

// ============================================================
// SIMPLE HOME TOP PROGRESS ITEM
// ============================================================

class _TopProgressItem
    extends StatelessWidget {
  final IconData icon;
  final String value;

  const _TopProgressItem({
    required this.icon,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 25,
        ),
        const SizedBox(
          width: 8,
        ),
        Text(
          value,
          style:
              const TextStyle(
            fontSize: 23,
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

// ============================================================
// EMPTY CARD
// ============================================================

class _EmptyCard
    extends StatelessWidget {
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
        padding:
            const EdgeInsets.all(28),
        child: Column(
          children: [
            Icon(
              icon,
              size: 48,
              color: Colors.grey,
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              title,
              style:
                  const TextStyle(
                fontSize: 19,
                fontWeight:
                    FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            Text(
              message,
              textAlign:
                  TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// SETTINGS
// ============================================================

class SettingsScreen
    extends StatelessWidget {
  final bool isDarkMode;
  final Future<void> Function(bool)
      onThemeChanged;

  const SettingsScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Settings'),
      ),
      body: ListView(
        padding:
            const EdgeInsets.all(16),
        children: [
          Card(
            child:
                SwitchListTile(
              value: isDarkMode,
              onChanged:
                  onThemeChanged,
              secondary: Icon(
                isDarkMode
                    ? Icons.dark_mode
                    : Icons.light_mode,
              ),
              title:
                  const Text(
                'Dark mode',
                style:
                    TextStyle(
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
              subtitle:
                  Text(
                isDarkMode
                    ? 'Dark theme is currently enabled'
                    : 'Light theme is currently enabled',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// DAILY STUDY SCREEN
// ============================================================

class DailyStudyScreen
    extends StatefulWidget {
  final List<StudyDay> days;
  final void Function(
    StudyDay day,
  ) onSaveDay;

  const DailyStudyScreen({
    super.key,
    required this.days,
    required this.onSaveDay,
  });

  @override
  State<DailyStudyScreen> createState() =>
      _DailyStudyScreenState();
}

class _DailyStudyScreenState
    extends State<DailyStudyScreen> {
  late DateTime selectedDate;

  StudyDay? currentDay;

  @override
  void initState() {
    super.initState();

    selectedDate =
        DateTime.now();

    _loadSelectedDay();
  }

  String dateKey(
    DateTime date,
  ) {
    final y =
        date.year.toString().padLeft(
              4,
              '0',
            );

    final m =
        date.month.toString().padLeft(
              2,
              '0',
            );

    final d =
        date.day.toString().padLeft(
              2,
              '0',
            );

    return '$y-$m-$d';
  }

  void _loadSelectedDay() {
    final key =
        dateKey(selectedDate);

    final existing =
        widget.days.where(
      (day) =>
          day.dateKey == key,
    );

    if (existing.isNotEmpty) {
      currentDay =
          _copyDay(
        existing.first,
      );
    } else {
      currentDay = StudyDay(
        dateKey: key,
        chapters: [],
      );
    }
  }

  StudyDay _copyDay(
    StudyDay day,
  ) {
    return StudyDay(
      dateKey: day.dateKey,
      chapters: day.chapters
          .map(
            (chapter) =>
                ChapterEntry.fromJson(
              chapter.toJson(),
            ),
          )
          .toList(),
    );
  }

  void _autoSave() {
    final day =
        currentDay;

    if (day == null) return;

    widget.onSaveDay(
      _copyDay(day),
    );
  }

  Future<void> _pickDate() async {
    _autoSave();

    final picked =
        await showDatePicker(
      context: context,
      initialDate:
          selectedDate,
      firstDate:
          DateTime(2000),
      lastDate:
          DateTime(2100),
    );

    if (picked == null) {
      return;
    }

    setState(() {
      selectedDate =
          picked;

      _loadSelectedDay();
    });
  }

  void _addChapter() {
    setState(() {
      currentDay!.chapters.add(
        ChapterEntry(
          id: DateTime.now()
              .microsecondsSinceEpoch
              .toString(),
          reference: '',
        ),
      );
    });

    _autoSave();
  }

  void _removeChapter(
    int index,
  ) {
    setState(() {
      currentDay!
          .chapters
          .removeAt(index);
    });

    _autoSave();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final day =
        currentDay;

    if (day == null) {
      return const Center(
        child:
            CircularProgressIndicator(),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        _autoSave();
        return true;
      },
      child:
          CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title:
                const Text(
              'Daily Study',
            ),
            actions: [
              IconButton(
                tooltip:
                    'Save',
                onPressed:
                    _autoSave,
                icon:
                    const Icon(
                  Icons.save_outlined,
                ),
              ),
            ],
          ),

          SliverPadding(
            padding:
                const EdgeInsets.fromLTRB(
              16,
              12,
              16,
              30,
            ),
            sliver: SliverList(
              delegate:
                  SliverChildListDelegate(
                [
                  _buildDayHeader(),

                  const SizedBox(
                    height: 16,
                  ),

                  if (day.chapters.isEmpty)
                    Card(
                      child:
                          Padding(
                        padding:
                            const EdgeInsets.all(
                          22,
                        ),
                        child:
                            Column(
                          children: [
                            Icon(
                              Icons
                                  .menu_book_outlined,
                              size: 42,
                              color: Theme.of(
                                context,
                              )
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              'No chapters yet',
                              style:
                                  TextStyle(
                                fontSize:
                                    18,
                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            const Text(
                              'Add a chapter when you are ready.',
                              textAlign:
                                  TextAlign
                                      .center,
                            ),
                          ],
                        ),
                      ),
                    ),

                  ...List.generate(
                    day.chapters.length,
                    (index) {
                      final chapter =
                          day.chapters[
                              index];

                      return Padding(
                        padding:
                            const EdgeInsets.only(
                          bottom: 14,
                        ),
                        child:
                            ChapterCard(
                          key: ValueKey(
                            chapter.id,
                          ),
                          number:
                              index + 1,
                          chapter:
                              chapter,
                          canDelete:
                              true,
                          onChanged:
                              _autoSave,
                          onDelete:
                              () {
                            _removeChapter(
                              index,
                            );
                          },
                        ),
                      );
                    },
                  ),

                  const SizedBox(
                    height: 4,
                  ),

                  SizedBox(
                    width:
                        double.infinity,
                    height: 50,
                    child:
                        OutlinedButton.icon(
                      onPressed:
                          _addChapter,
                      icon:
                          const Icon(
                        Icons.add,
                      ),
                      label:
                          const Text(
                        'Add chapter',
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  SizedBox(
                    width:
                        double.infinity,
                    height: 52,
                    child:
                        FilledButton.icon(
                      onPressed:
                          _autoSave,
                      icon:
                          const Icon(
                        Icons.save,
                      ),
                      label:
                          const Text(
                        'SAVE STUDY',
                        style:
                            TextStyle(
                          fontWeight:
                              FontWeight.bold,
                        ),
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

  Widget _buildDayHeader() {
    return Card(
      child: InkWell(
        borderRadius:
            BorderRadius.circular(
          12,
        ),
        onTap:
            _pickDate,
        child: Padding(
          padding:
              const EdgeInsets.all(
            16,
          ),
          child: Row(
            children: [
              const CircleAvatar(
                child: Icon(
                  Icons.calendar_today,
                ),
              ),

              const SizedBox(
                width: 14,
              ),

              Expanded(
                child: Text(
                  '${selectedDate.day}/'
                  '${selectedDate.month}/'
                  '${selectedDate.year}',
                  style:
                      const TextStyle(
                    fontSize: 18,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),

              const Icon(
                Icons.chevron_right,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// STANDALONE DAY EDITOR
// ============================================================

class StandaloneDayEditor
    extends StatelessWidget {
  final StudyDay day;

  final void Function(
    StudyDay day,
  ) onSave;

  const StandaloneDayEditor({
    super.key,
    required this.day,
    required this.onSave,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Edit Study'),
      ),
      body:
          DailyStudyEditorBody(
        initialDay:
            day,
        onSave:
            onSave,
      ),
    );
  }
}

class DailyStudyEditorBody
    extends StatefulWidget {
  final StudyDay initialDay;

  final void Function(
    StudyDay day,
  ) onSave;

  const DailyStudyEditorBody({
    super.key,
    required this.initialDay,
    required this.onSave,
  });

  @override
  State<DailyStudyEditorBody>
      createState() =>
          _DailyStudyEditorBodyState();
}

class _DailyStudyEditorBodyState
    extends State<
        DailyStudyEditorBody> {
  late StudyDay day;

  @override
  void initState() {
    super.initState();

    day =
        StudyDay.fromJson(
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

  void addChapter() {
    setState(() {
      day.chapters.add(
        ChapterEntry(
          id: DateTime.now()
              .microsecondsSinceEpoch
              .toString(),
          reference: '',
        ),
      );
    });

    save();
  }

  void deleteChapter(
    int index,
  ) {
    setState(() {
      day.chapters
          .removeAt(index);
    });

    save();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return WillPopScope(
      onWillPop: () async {
        save();
        return true;
      },
      child: ListView(
        padding:
            const EdgeInsets.all(
          16,
        ),
        children: [
          ...List.generate(
            day.chapters.length,
            (index) {
              final chapter =
                  day.chapters[index];

              return Padding(
                padding:
                    const EdgeInsets.only(
                  bottom: 14,
                ),
                child:
                    ChapterCard(
                  key: ValueKey(
                    chapter.id,
                  ),
                  number:
                      index + 1,
                  chapter:
                      chapter,
                  canDelete:
                      true,
                  onChanged: () {
                    save();
                  },
                  onDelete: () {
                    deleteChapter(
                      index,
                    );
                  },
                ),
              );
            },
          ),

          OutlinedButton.icon(
            onPressed:
                addChapter,
            icon:
                const Icon(
              Icons.add,
            ),
            label:
                const Text(
              'Add chapter',
            ),
          ),

          const SizedBox(
            height: 14,
          ),

          FilledButton.icon(
            onPressed:
                save,
            icon:
                const Icon(
              Icons.save,
            ),
            label:
                const Text(
              'Save',
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// CHAPTER CARD
// ============================================================

class ChapterCard
    extends StatefulWidget {
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
  State<ChapterCard> createState() =>
      _ChapterCardState();
}

class _ChapterCardState
    extends State<ChapterCard> {
  late final TextEditingController
      referenceController;

  late final TextEditingController
      keyVerseController;

  late final TextEditingController
      summaryController;

  late final TextEditingController
      observationsController;

  late final TextEditingController
      meaningController;

  late final TextEditingController
      lessonsController;

  late final TextEditingController
      applicationController;

  late final TextEditingController
      questionsController;

  late final TextEditingController
      prayerController;

  late final TextEditingController
      characterNameController;

  late final TextEditingController
      characterWhoController;

  late final TextEditingController
      characterTraitsController;

  late final TextEditingController
      characterActionsController;

  late final TextEditingController
      characterLessonsController;

  @override
  void initState() {
    super.initState();

    referenceController =
        TextEditingController(
      text: widget.chapter.reference,
    );

    keyVerseController =
        TextEditingController(
      text: widget.chapter.keyVerse,
    );

    summaryController =
        TextEditingController(
      text: widget.chapter.summary,
    );

    observationsController =
        TextEditingController(
      text: widget.chapter.observations,
    );

    meaningController =
        TextEditingController(
      text: widget.chapter.meaning,
    );

    lessonsController =
        TextEditingController(
      text: widget.chapter.lessons,
    );

    applicationController =
        TextEditingController(
      text: widget.chapter.application,
    );

    questionsController =
        TextEditingController(
      text: widget.chapter.questions,
    );

    prayerController =
        TextEditingController(
      text: widget.chapter.prayer,
    );

    characterNameController =
        TextEditingController(
      text: widget.chapter.characterName,
    );

    characterWhoController =
        TextEditingController(
      text: widget.chapter.characterWho,
    );

    characterTraitsController =
        TextEditingController(
      text: widget.chapter.characterTraits,
    );

    characterActionsController =
        TextEditingController(
      text: widget.chapter.characterActions,
    );

    characterLessonsController =
        TextEditingController(
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
    widget.chapter.reference =
        referenceController.text;

    widget.chapter.keyVerse =
        keyVerseController.text;

    widget.chapter.summary =
        summaryController.text;

    widget.chapter.observations =
        observationsController.text;

    widget.chapter.meaning =
        meaningController.text;

    widget.chapter.lessons =
        lessonsController.text;

    widget.chapter.application =
        applicationController.text;

    widget.chapter.questions =
        questionsController.text;

    widget.chapter.prayer =
        prayerController.text;

    widget.chapter.characterName =
        characterNameController.text;

    widget.chapter.characterWho =
        characterWhoController.text;

    widget.chapter.characterTraits =
        characterTraitsController.text;

    widget.chapter.characterActions =
        characterActionsController.text;

    widget.chapter.characterLessons =
        characterLessonsController.text;

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
      padding:
          const EdgeInsets.only(
        bottom: 12,
      ),
      child: TextField(
        controller:
            controller,
        minLines:
            minLines,
        maxLines:
            maxLines,
        textCapitalization:
            TextCapitalization.sentences,
        onChanged: (_) {
          sync();
        },
        decoration:
            InputDecoration(
          labelText:
              label,
          hintText:
              hint,
          alignLabelWithHint:
              true,
        ),
      ),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Card(
      clipBehavior:
          Clip.antiAlias,
      child:
          ExpansionTile(
        // Chapters are CLOSED by default.
        initiallyExpanded:
            false,

        tilePadding:
            const EdgeInsets
                .symmetric(
          horizontal: 16,
          vertical: 5,
        ),

        title: Text(
          'Chapter ${widget.number}',
          style:
              const TextStyle(
            fontWeight:
                FontWeight.bold,
            fontSize: 18,
          ),
        ),

        childrenPadding:
            const EdgeInsets
                .fromLTRB(
          16,
          0,
          16,
          16,
        ),

        children: [
          TextField(
            controller:
                referenceController,
            onChanged:
                (_) => sync(),
            textCapitalization:
                TextCapitalization.words,
            decoration:
                const InputDecoration(
              labelText:
                  'Bible reference',
              hintText:
                  'Example: Matthew 5',
              prefixIcon:
                  Icon(
                Icons.menu_book,
              ),
            ),
          ),

          const SizedBox(
            height: 18,
          ),

          const _SectionTitle(
            icon: Icons.search,
            title:
                'Chapter Study',
          ),

          field(
            'Key verse',
            keyVerseController,
            hint:
                'Which verse stands out to you?',
          ),

          field(
            'What happens in this chapter?',
            summaryController,
            hint:
                'Summarize the chapter in your own words.',
          ),

          field(
            'What do you notice?',
            observationsController,
            hint:
                'Important people, events, commands, promises, repeated words, contrasts, etc.',
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

          const Divider(
            height: 25,
          ),

          ExpansionTile(
            initiallyExpanded:
                false,

            tilePadding:
                EdgeInsets.zero,

            title:
                const Text(
              'Character Study',
              style:
                  TextStyle(
                fontWeight:
                    FontWeight.bold,
                fontSize: 17,
              ),
            ),

            subtitle:
                const Text(
              'Study a person from this chapter',
            ),

            leading:
                const Icon(
              Icons.person_outline,
            ),

            children: [
              const SizedBox(
                height: 8,
              ),

              field(
                'Character name',
                characterNameController,
                hint:
                    'Example: Peter',
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

          const Divider(
            height: 25,
          ),

          const _SectionTitle(
            icon:
                Icons.favorite_outline,
            title:
                'Response',
          ),

          field(
            'Prayer / personal response',
            prayerController,
            hint:
                'Write a short prayer or personal response to what you studied.',
          ),

          if (widget.canDelete)
            Align(
              alignment:
                  Alignment.centerRight,
              child:
                  TextButton.icon(
                onPressed:
                    widget.onDelete,
                icon:
                    const Icon(
                  Icons.delete_outline,
                ),
                label:
                    const Text(
                  'Remove chapter',
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ============================================================
// SECTION TITLE
// ============================================================

class _SectionTitle
    extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionTitle({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Padding(
      padding:
          const EdgeInsets.only(
        top: 6,
        bottom: 14,
      ),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(
            width: 10,
          ),
          Text(
            title,
            style:
                const TextStyle(
              fontSize: 18,
              fontWeight:
                  FontWeight.bold,
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

class BackupScreen
    extends StatefulWidget {
  final List<StudyDay> days;

  final Future<void> Function()
      onRestored;

  const BackupScreen({
    super.key,
    required this.days,
    required this.onRestored,
  });

  @override
  State<BackupScreen> createState() =>
      _BackupScreenState();
}

class _BackupScreenState
    extends State<BackupScreen> {
  late final TextEditingController
      backupController;

  bool showingBackup = false;

  @override
  void initState() {
    super.initState();

    backupController =
        TextEditingController();
  }

  @override
  void dispose() {
    backupController.dispose();
    super.dispose();
  }

  Future<void> createBackup()
      async {
    final backup =
        await StudyStorage
            .createBackup(
      widget.days,
    );

    setState(() {
      backupController.text =
          backup;
      showingBackup = true;
    });
  }

  Future<void> copyBackup()
      async {
    if (backupController
        .text
        .trim()
        .isEmpty) {
      await createBackup();
    }

    await Clipboard.setData(
      ClipboardData(
        text:
            backupController.text,
      ),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
      const SnackBar(
        content: Text(
          'Backup copied. Paste it into a safe file.',
        ),
      ),
    );
  }

  Future<void> restoreBackup()
      async {
    final text =
        backupController.text
            .trim();

    if (text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text(
            'Paste your backup first.',
          ),
        ),
      );

      return;
    }

    final success =
        await StudyStorage
            .restoreBackup(
      text,
    );

    if (!mounted) return;

    if (success) {
      await widget.onRestored();

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text(
            'Backup restored successfully.',
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text(
            'That backup is not valid.',
          ),
        ),
      );
    }
  }

  Future<void> confirmRestore()
      async {
    final answer =
        await showDialog<bool>(
      context: context,
      builder:
          (dialogContext) {
        return AlertDialog(
          title:
              const Text(
            'Restore backup?',
          ),
          content:
              const Text(
            'Restoring will replace the current study data with the backup data.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child:
                  const Text(
                'Cancel',
              ),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              child:
                  const Text(
                'Restore',
              ),
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
  Widget build(
    BuildContext context,
  ) {
    return CustomScrollView(
      slivers: [
        const SliverAppBar.large(
          title:
              Text(
            'Backup & Restore',
          ),
        ),

        SliverPadding(
          padding:
              const EdgeInsets.fromLTRB(
            16,
            8,
            16,
            30,
          ),
          sliver: SliverList(
            delegate:
                SliverChildListDelegate(
              [
                Card(
                  child: Padding(
                    padding:
                        const EdgeInsets.all(
                      18,
                    ),
                    child:
                        Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        const Icon(
                          Icons.security,
                          size: 38,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        const Text(
                          'Protect your Bible studies',
                          style:
                              TextStyle(
                            fontSize: 21,
                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          '${widget.days.length} study days are currently saved.',
                          style:
                              TextStyle(
                            color: Theme.of(
                              context,
                            )
                                .colorScheme
                                .onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        const Text(
                          'Create a backup and keep the text somewhere safe. You can paste it back here later to restore your studies.',
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(
                  height: 14,
                ),

                SizedBox(
                  height: 52,
                  child:
                      FilledButton.icon(
                    onPressed:
                        createBackup,
                    icon:
                        const Icon(
                      Icons.backup,
                    ),
                    label:
                        const Text(
                      'CREATE BACKUP',
                    ),
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                SizedBox(
                  height: 52,
                  child:
                      OutlinedButton.icon(
                    onPressed:
                        copyBackup,
                    icon:
                        const Icon(
                      Icons.copy,
                    ),
                    label:
                        const Text(
                      'COPY BACKUP',
                    ),
                  ),
                ),

                const SizedBox(
                  height: 22,
                ),

                const Text(
                  'Restore',
                  style:
                      TextStyle(
                    fontSize: 21,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 8,
                ),

                const Text(
                  'Paste a backup below, then press Restore.',
                ),

                const SizedBox(
                  height: 12,
                ),

                TextField(
                  controller:
                      backupController,
                  minLines: 12,
                  maxLines: 25,
                  decoration:
                      const InputDecoration(
                    labelText:
                        'Backup data',
                    hintText:
                        'Paste your backup here',
                    alignLabelWithHint:
                        true,
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                SizedBox(
                  height: 52,
                  child:
                      FilledButton.icon(
                    onPressed:
                        confirmRestore,
                    icon:
                        const Icon(
                      Icons.restore,
                    ),
                    label:
                        const Text(
                      'RESTORE BACKUP',
                    ),
                  ),
                ),

                if (showingBackup) ...[
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Your backup is ready',
                    style:
                        TextStyle(
                      fontWeight:
                          FontWeight
                              .bold,
                    ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
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
