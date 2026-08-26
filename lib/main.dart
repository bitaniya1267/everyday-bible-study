import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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

    await prefs.setBool('bitaniya_dark_mode', dark);

    if (!mounted) return;

    setState(() {
      themeMode = dark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  ThemeData get lightTheme {
    const ivory = Color(0xFFF8F7F3);
    const paper = Color(0xFFFFFFFF);
    const plum = Color(0xFF5E4B8B);
    const plumSoft = Color(0xFFE9E3F3);
    const ink = Color(0xFF252331);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: ivory,
      colorScheme: ColorScheme.fromSeed(
        seedColor: plum,
        brightness: Brightness.light,
        primary: plum,
        surface: paper,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: ivory,
        foregroundColor: ink,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: ink,
          fontSize: 21,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2,
        ),
      ),
      cardTheme: CardThemeData(
        color: paper,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: const BorderSide(
            color: Color(0xFFE9E5EF),
            width: 1,
          ),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFFE9E5EF),
        thickness: 1,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: paper,
        indicatorColor: plumSoft,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          return TextStyle(
            color: states.contains(WidgetState.selected)
                ? plum
                : const Color(0xFF6E6A78),
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w500,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          return IconThemeData(
            color: states.contains(WidgetState.selected)
                ? plum
                : const Color(0xFF77727F),
          );
        }),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFFCFBFD),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color(0xFFE6E1EA),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color(0xFFE6E1EA),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: plum,
            width: 1.6,
          ),
        ),
        labelStyle: const TextStyle(
          color: Color(0xFF6E6877),
        ),
        hintStyle: const TextStyle(
          color: Color(0xFFAAA4B0),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: plum,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: plum,
          side: const BorderSide(
            color: Color(0xFFD9D1E6),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: plum,
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: plum,
        linearTrackColor: Color(0xFFEAE5F0),
        linearMinHeight: 7,
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 6,
        ),
        iconColor: plum,
      ),
      expansionTileTheme: const ExpansionTileThemeData(
        iconColor: plum,
        collapsedIconColor: Color(0xFF6F6977),
        textColor: ink,
        collapsedTextColor: ink,
        backgroundColor: Colors.transparent,
        collapsedBackgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(18),
          ),
        ),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(18),
          ),
        ),
      ),
      iconTheme: const IconThemeData(
        color: plum,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  ThemeData get darkTheme {
    const night = Color(0xFF15131A);
    const surface = Color(0xFF211E27);
    const surfaceSoft = Color(0xFF2A2632);
    const plum = Color(0xFFB79AE8);
    const text = Color(0xFFF4F0F8);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: night,
      colorScheme: ColorScheme.fromSeed(
        seedColor: plum,
        brightness: Brightness.dark,
        primary: plum,
        surface: surface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: night,
        foregroundColor: text,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: text,
          fontSize: 21,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2,
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: const BorderSide(
            color: Color(0xFF37313F),
          ),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFF39333F),
        thickness: 1,
      ),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: Color(0xFF3A3148),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceSoft,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color(0xFF413A49),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color(0xFF413A49),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: plum,
            width: 1.6,
          ),
        ),
        labelStyle: const TextStyle(
          color: Color(0xFFD6CFDD),
        ),
        hintStyle: const TextStyle(
          color: Color(0xFF9E96A8),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: plum,
          foregroundColor: const Color(0xFF201A29),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: plum,
          side: const BorderSide(
            color: Color(0xFF51475E),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: plum,
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: plum,
        linearTrackColor: Color(0xFF3A3442),
        linearMinHeight: 7,
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 6,
        ),
        iconColor: plum,
      ),
      expansionTileTheme: const ExpansionTileThemeData(
        iconColor: plum,
        collapsedIconColor: Color(0xFFC5BDCF),
        backgroundColor: Colors.transparent,
        collapsedBackgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(18),
          ),
        ),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(18),
          ),
        ),
      ),
      iconTheme: const IconThemeData(
        color: plum,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
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
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        FlutterQuillLocalizations.delegate,
      ],
      home: AppShell(
        isDarkMode: themeMode == ThemeMode.dark,
        onThemeChanged: toggleTheme,
      ),
    );
  }
}

// ============================================================
// RICH TEXT HELPERS
// ============================================================

String documentToJson(Document document) {
  return jsonEncode(document.toDelta().toJson());
}

Document documentFromJson(String value) {
  try {
    final decoded = jsonDecode(value);

    if (decoded is List) {
      return Document.fromJson(
        List<dynamic>.from(decoded),
      );
    }
  } catch (_) {}

  return Document();
}

Document documentFromStoredValue(
  String richText,
  String plainText,
) {
  if (richText.trim().isNotEmpty) {
    final document = documentFromJson(richText);

    if (!document.isEmpty()) {
      return document;
    }
  }

  if (plainText.isNotEmpty) {
    return Document.fromJson([
      {
        'insert': plainText,
      },
      {
        'insert': '\n',
      },
    ]);
  }

  return Document();
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

  // Rich text versions of the study fields.
  String keyVerseRich;
  String summaryRich;
  String observationsRich;
  String meaningRich;
  String lessonsRich;
  String applicationRich;
  String questionsRich;
  String prayerRich;

  String characterNameRich;
  String characterWhoRich;
  String characterTraitsRich;
  String characterActionsRich;
  String characterLessonsRich;

  bool bookmarked;
  bool favorite;

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
    this.keyVerseRich = '',
    this.summaryRich = '',
    this.observationsRich = '',
    this.meaningRich = '',
    this.lessonsRich = '',
    this.applicationRich = '',
    this.questionsRich = '',
    this.prayerRich = '',
    this.characterNameRich = '',
    this.characterWhoRich = '',
    this.characterTraitsRich = '',
    this.characterActionsRich = '',
    this.characterLessonsRich = '',
    this.bookmarked = false,
    this.favorite = false,
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

      'keyVerseRich': keyVerseRich,
      'summaryRich': summaryRich,
      'observationsRich': observationsRich,
      'meaningRich': meaningRich,
      'lessonsRich': lessonsRich,
      'applicationRich': applicationRich,
      'questionsRich': questionsRich,
      'prayerRich': prayerRich,

      'characterNameRich': characterNameRich,
      'characterWhoRich': characterWhoRich,
      'characterTraitsRich': characterTraitsRich,
      'characterActionsRich': characterActionsRich,
      'characterLessonsRich': characterLessonsRich,
      'bookmarked': bookmarked,
      'favorite': favorite,
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

      keyVerseRich: json['keyVerseRich']?.toString() ?? '',
      summaryRich: json['summaryRich']?.toString() ?? '',
      observationsRich:
          json['observationsRich']?.toString() ?? '',
      meaningRich: json['meaningRich']?.toString() ?? '',
      lessonsRich: json['lessonsRich']?.toString() ?? '',
      applicationRich:
          json['applicationRich']?.toString() ?? '',
      questionsRich:
          json['questionsRich']?.toString() ?? '',
      prayerRich: json['prayerRich']?.toString() ?? '',

      characterNameRich:
          json['characterNameRich']?.toString() ?? '',
      characterWhoRich:
          json['characterWhoRich']?.toString() ?? '',
      characterTraitsRich:
          json['characterTraitsRich']?.toString() ?? '',
      characterActionsRich:
          json['characterActionsRich']?.toString() ?? '',
      characterLessonsRich:
          json['characterLessonsRich']?.toString() ?? '',
      bookmarked: json['bookmarked'] == true,
      favorite: json['favorite'] == true,
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
      'version': 2,
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
// STUDY HELPERS
// ============================================================

String prettyStudyDate(String key) {
  try {
    final d = DateTime.parse(key);
    return '${d.day}/${d.month}/${d.year}';
  } catch (_) {
    return key;
  }
}

String chapterSearchText(ChapterEntry c) {
  return [
    c.reference,
    c.keyVerse,
    c.summary,
    c.observations,
    c.meaning,
    c.lessons,
    c.application,
    c.questions,
    c.prayer,
    c.characterName,
    c.characterWho,
    c.characterTraits,
    c.characterActions,
    c.characterLessons,
  ].join(' ').toLowerCase();
}

int calculateStudyStreak(List<StudyDay> days) {
  final keys = days.map((d) => d.dateKey).where((x) => x.isNotEmpty).toSet();
  if (keys.isEmpty) return 0;
  var date = DateTime.now();
  String key(DateTime d) => ReadingStorage.dateKey(d);
  if (!keys.contains(key(date))) {
    date = date.subtract(const Duration(days: 1));
  }
  var streak = 0;
  while (keys.contains(key(date))) {
    streak++;
    date = date.subtract(const Duration(days: 1));
  }
  return streak;
}

List<Map<String, dynamic>> studySearchResults(List<StudyDay> days, String query) {
  final q = query.trim().toLowerCase();
  if (q.isEmpty) return [];
  final results = <Map<String, dynamic>>[];
  for (final day in days) {
    for (final chapter in day.chapters) {
      if (chapterSearchText(chapter).contains(q)) {
        results.add({'day': day, 'chapter': chapter});
      }
    }
  }
  return results;
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
        onOpenStudy: () {
          setState(() {
            currentIndex = 1;
          });
        },
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
  final VoidCallback onOpenStudy;
  final void Function(StudyDay day) onOpenDay;
  final void Function(String dateKey) onDeleteDay;
  final VoidCallback onOpenSettings;

  const HomeScreen({
    super.key,
    required this.days,
    required this.onOpenStudy,
    required this.onOpenDay,
    required this.onDeleteDay,
    required this.onOpenSettings,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate = DateTime.now();
  Map<String, Set<String>> progress = {};
  bool loadingReading = true;
  bool booksExpanded = false;

  @override
  void initState() {
    super.initState();
    loadReadingProgress();
  }

  Future<void> loadReadingProgress() async {
    final loaded = await ReadingStorage.load();
    if (!mounted) return;
    setState(() {
      progress = loaded;
      loadingReading = false;
    });
  }

  String get currentDateKey => ReadingStorage.dateKey(selectedDate);

  Set<String> get todayRead => progress[currentDateKey] ?? <String>{};

  int get totalReadToday => todayRead.length;

  double get todayPercentage {
    if (totalNewTestamentChapters == 0) return 0;
    return totalReadToday / totalNewTestamentChapters;
  }

  int bookReadCount(BibleBook book) {
    return todayRead.where((id) => id.startsWith('${book.name}|')).length;
  }

  int get studyDays => widget.days.length;

  int get studyChapterCount => widget.days.fold<int>(
        0,
        (sum, day) => sum + day.chapters.length,
      );

  int get streak => calculateStudyStreak(widget.days);

  String formatDate(String dateKey) {
    try {
      final date = DateTime.parse(dateKey);
      return '${date.day}/${date.month}/${date.year}';
    } catch (_) {
      return dateKey;
    }
  }

  Future<void> toggleChapter(BibleBook book, int chapter) async {
    final id = '${book.name}|$chapter';
    final set = progress.putIfAbsent(currentDateKey, () => <String>{});

    setState(() {
      if (set.contains(id)) {
        set.remove(id);
      } else {
        set.add(id);
      }
    });

    await ReadingStorage.save(progress);
  }

  Future<void> pickReadingDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;
    setState(() => selectedDate = picked);
  }

  Future<void> _showStudyExport(BuildContext context) async {
    final sorted = [...widget.days]
      ..sort((a, b) => b.dateKey.compareTo(a.dateKey));
    final buffer = StringBuffer('BITANIYA BIBLE STUDY\n\n');

    for (final day in sorted) {
      buffer.writeln('DATE: ${prettyStudyDate(day.dateKey)}');
      for (final c in day.chapters) {
        buffer.writeln('\n${c.reference.isEmpty ? 'Chapter' : c.reference}');
        final fields = <String, String>{
          'Key verse': c.keyVerse,
          'Summary': c.summary,
          'Observations': c.observations,
          'Meaning': c.meaning,
          'Lessons': c.lessons,
          'Application': c.application,
          'Questions': c.questions,
          'Prayer': c.prayer,
          'Character': c.characterName,
          'Character lessons': c.characterLessons,
        };
        for (final e in fields.entries) {
          if (e.value.trim().isNotEmpty) {
            buffer.writeln('${e.key}: ${e.value.trim()}');
          }
        }
      }
      buffer.writeln('\n----------------------------------------\n');
    }

    final text = buffer.toString();
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Export your studies'),
        content: SizedBox(
          width: 650,
          child: SingleChildScrollView(child: SelectableText(text)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Close'),
          ),
          FilledButton.icon(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: text));
              if (dialogContext.mounted) Navigator.pop(dialogContext);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Study export copied to clipboard.')),
                );
              }
            },
            icon: const Icon(Icons.copy),
            label: const Text('Copy'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sorted = [...widget.days]
      ..sort((a, b) => b.dateKey.compareTo(a.dateKey));
    final latest = sorted.isEmpty ? null : sorted.first;
    final recent = sorted.take(3).toList();

    return CustomScrollView(
      slivers: [
        SliverAppBar.large(
          pinned: true,
          title: const Text('Bitaniya Bible Study'),
          actions: [
            PopupMenuButton<String>(
              tooltip: 'More',
              onSelected: (value) {
                switch (value) {
                  case 'favorites':
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => StudyLibraryScreen(
                          days: widget.days,
                          favoritesOnly: true,
                        ),
                      ),
                    );
                    break;
                  case 'export':
                    _showStudyExport(context);
                    break;
                  case 'settings':
                    widget.onOpenSettings();
                    break;
                }
              },
              itemBuilder: (_) => const [
                PopupMenuItem(
                  value: 'favorites',
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.star_border),
                    title: Text('Favorites'),
                  ),
                ),
                PopupMenuItem(
                  value: 'export',
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.ios_share_outlined),
                    title: Text('Export studies'),
                  ),
                ),
                PopupMenuItem(
                  value: 'settings',
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.settings_outlined),
                    title: Text('Settings'),
                  ),
                ),
              ],
            ),
          ],
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Main welcome / continue card.
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              Icons.menu_book_rounded,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Welcome back',
                                  style: TextStyle(
                                    color: theme.colorScheme.onSurfaceVariant,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  latest == null
                                      ? 'Ready for today’s study?'
                                      : 'Continue your Bible study',
                                  style: const TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (latest != null) ...[
                        Text(
                          '${prettyStudyDate(latest.dateKey)} • ${latest.chapters.length} chapter${latest.chapters.length == 1 ? '' : 's'}',
                          style: TextStyle(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: widget.onOpenStudy,
                          icon: const Icon(Icons.edit_note_rounded),
                          label: Text(latest == null ? 'START TODAY’S STUDY' : 'START TODAY’S STUDY'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // One compact stats card instead of repeated stat sections.
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: _HomeStat(
                          icon: Icons.calendar_month_outlined,
                          value: '$studyDays',
                          label: 'Study days',
                        ),
                      ),
                      _homeDivider(context),
                      Expanded(
                        child: _HomeStat(
                          icon: Icons.menu_book_outlined,
                          value: '$studyChapterCount',
                          label: 'Chapters',
                        ),
                      ),
                      _homeDivider(context),
                      Expanded(
                        child: _HomeStat(
                          icon: Icons.local_fire_department_outlined,
                          value: '$streak',
                          label: 'Day streak',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Small, non-repetitive tools area.
              Text(
                'Quick access',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _HomeQuickAction(
                      icon: Icons.search,
                      label: 'Search',
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => StudySearchScreen(days: widget.days),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _HomeQuickAction(
                      icon: Icons.calendar_month_outlined,
                      label: 'Calendar',
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => StudyCalendarScreen(days: widget.days),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _HomeQuickAction(
                      icon: Icons.bookmark_border,
                      label: 'Bookmarks',
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => StudyLibraryScreen(
                            days: widget.days,
                            favoritesOnly: false,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _HomeQuickAction(
                      icon: Icons.person_outline,
                      label: 'Characters',
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => CharacterLibraryScreen(days: widget.days),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // New Testament progress gets one clean card.
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.auto_stories_outlined, color: theme.colorScheme.primary),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Text(
                              'New Testament reading',
                              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
                            ),
                          ),
                          IconButton(
                            tooltip: 'Choose date',
                            onPressed: pickReadingDate,
                            icon: const Icon(Icons.calendar_today_outlined, size: 20),
                          ),
                          IconButton(
                            tooltip: booksExpanded ? 'Hide books' : 'Show books',
                            onPressed: () => setState(() => booksExpanded = !booksExpanded),
                            icon: Icon(
                              booksExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${(todayPercentage * 100).toStringAsFixed(1)}% • $totalReadToday / $totalNewTestamentChapters chapters',
                        style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                      ),
                      const SizedBox(height: 10),
                      LinearProgressIndicator(value: todayPercentage),
                      const SizedBox(height: 8),
                      Text(
                        'Reading date: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      if (booksExpanded) ...[
                        const SizedBox(height: 12),
                        ...newTestamentBooks.map(_buildBookCard),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Recent studies',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  if (recent.isNotEmpty)
                    Text(
                      '${sorted.length} total',
                      style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                    ),
                ],
              ),
              const SizedBox(height: 9),

              if (recent.isEmpty)
                const _EmptyCard(
                  icon: Icons.menu_book_outlined,
                  title: 'No studies yet',
                  message: 'Your saved studies will appear here.',
                )
              else
                ...recent.map(
                  (day) => _RecentStudyTile(
                    day: day,
                    formatDate: formatDate,
                    onOpen: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => StandaloneDayEditor(
                          day: day,
                          onSave: widget.onOpenDay,
                        ),
                      ),
                    ),
                    onDelete: () => _confirmDelete(context, day),
                  ),
                ),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _homeDivider(BuildContext context) {
    return Container(
      width: 1,
      height: 34,
      color: Theme.of(context).colorScheme.outlineVariant,
    );
  }

  Widget _buildBookCard(BibleBook book) {
    final read = bookReadCount(book);
    final percentage = book.chapters == 0 ? 0.0 : read / book.chapters;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Card(
        child: ExpansionTile(
          initiallyExpanded: false,
          leading: CircleAvatar(child: Text('$read', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
          title: Text(book.name, style: const TextStyle(fontWeight: FontWeight.w700)),
          subtitle: Text('$read / ${book.chapters}'),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
          children: [
            LinearProgressIndicator(value: percentage, minHeight: 5),
            const SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 7,
                mainAxisSpacing: 7,
                childAspectRatio: 1.45,
              ),
              itemCount: book.chapters,
              itemBuilder: (context, index) {
                final chapter = index + 1;
                final id = '${book.name}|$chapter';
                final isRead = todayRead.contains(id);

                return InkWell(
                  borderRadius: BorderRadius.circular(9),
                  onTap: () => toggleChapter(book, chapter),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isRead
                          ? themeOf(context).primary
                          : themeOf(context).surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(9),
                      border: Border.all(
                        color: themeOf(context).outline.withOpacity(.3),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Ch. $chapter',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isRead ? themeOf(context).onPrimary : null,
                        ),
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

  ColorScheme themeOf(BuildContext context) => Theme.of(context).colorScheme;

  Future<void> _confirmDelete(BuildContext context, StudyDay day) async {
    final answer = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete study?'),
        content: Text('Delete the study for ${formatDate(day.dateKey)}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (answer == true) widget.onDeleteDay(day.dateKey);
  }
}

class _HomeStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _HomeStat({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Column(
      children: [
        Icon(icon, size: 21, color: color),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _HomeQuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _HomeQuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(.55),
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 5),
          child: Column(
            children: [
              Icon(icon, size: 21),
              const SizedBox(height: 5),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecentStudyTile extends StatelessWidget {
  final StudyDay day;
  final String Function(String) formatDate;
  final VoidCallback onOpen;
  final VoidCallback onDelete;

  const _RecentStudyTile({
    required this.day,
    required this.formatDate,
    required this.onOpen,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final refs = day.chapters
        .map((c) => c.reference.trim())
        .where((x) => x.isNotEmpty)
        .join(' • ');

    return Card(
      margin: const EdgeInsets.only(bottom: 9),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
        leading: CircleAvatar(
          radius: 21,
          child: Text(
            '${day.chapters.length}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          formatDate(day.dateKey),
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Text(
          refs.isEmpty ? 'Bible study' : refs,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'delete') onDelete();
          },
          itemBuilder: (_) => const [
            PopupMenuItem(
              value: 'delete',
              child: Text('Delete'),
            ),
          ],
        ),
        onTap: onOpen,
      ),
    );
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

class _StatMini extends StatelessWidget {
  final String label;
  final String value;
  const _StatMini({required this.label, required this.value});
  @override
  Widget build(BuildContext context) => Column(children: [Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)), const SizedBox(height: 3), Text(label, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant))]);
}

// ============================================================
// DASHBOARD QUICK ACTIONS
// ============================================================

class _DashboardQuickActions extends StatelessWidget {
  final List<StudyDay> days;
  final VoidCallback onSearch;
  final VoidCallback onBookmarks;
  final VoidCallback onFavorites;
  final VoidCallback onCalendar;
  final VoidCallback onCharacters;
  final VoidCallback onExport;

  const _DashboardQuickActions({required this.days, required this.onSearch, required this.onBookmarks, required this.onFavorites, required this.onCalendar, required this.onCharacters, required this.onExport});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _quick(context, Icons.search, 'Search', onSearch),
            _quick(context, Icons.bookmark_border, 'Bookmarks', onBookmarks),
            _quick(context, Icons.star_border, 'Favorites', onFavorites),
            _quick(context, Icons.calendar_month, 'Calendar', onCalendar),
            _quick(context, Icons.person_outline, 'Characters', onCharacters),
            _quick(context, Icons.ios_share_outlined, 'Export', onExport),
          ],
        ),
      ),
    );
  }

  Widget _quick(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return ActionChip(avatar: Icon(icon, size: 18), label: Text(label), onPressed: onTap);
  }
}

// ============================================================
// STUDY SEARCH
// ============================================================

class StudySearchScreen extends StatefulWidget {
  final List<StudyDay> days;
  const StudySearchScreen({super.key, required this.days});
  @override State<StudySearchScreen> createState() => _StudySearchScreenState();
}

class _StudySearchScreenState extends State<StudySearchScreen> {
  final controller = TextEditingController();
  String query = '';
  @override
  void dispose() { controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final results = studySearchResults(widget.days, query);
    return Scaffold(
      appBar: AppBar(title: const Text('Search your studies')),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
          child: TextField(
            controller: controller,
            autofocus: true,
            onChanged: (v) => setState(() => query = v),
            decoration: InputDecoration(
              hintText: 'Search notes, verses, people, questions…',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: query.isEmpty ? null : IconButton(icon: const Icon(Icons.clear), onPressed: () { controller.clear(); setState(() => query = ''); }),
            ),
          ),
        ),
        Expanded(
          child: query.trim().isEmpty
              ? const Center(child: Text('Search across all your saved studies.'))
              : results.isEmpty
                  ? const Center(child: Text('No matching studies found.'))
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      itemCount: results.length,
                      itemBuilder: (_, i) {
                        final day = results[i]['day'] as StudyDay;
                        final chapter = results[i]['chapter'] as ChapterEntry;
                        return Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: ExpansionTile(
                            leading: Icon(chapter.favorite ? Icons.star : Icons.menu_book_outlined),
                            title: Text(chapter.reference.isEmpty ? 'Chapter ${i + 1}' : chapter.reference, style: const TextStyle(fontWeight: FontWeight.w700)),
                            subtitle: Text(prettyStudyDate(day.dateKey)),
                            childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            children: _resultFields(chapter),
                          ),
                        );
                      },
                    ),
        ),
      ]),
    );
  }

  List<Widget> _resultFields(ChapterEntry c) {
    final items = <String, String>{
      'Key verse': c.keyVerse,
      'Summary': c.summary,
      'Observations': c.observations,
      'Meaning': c.meaning,
      'Lessons': c.lessons,
      'Application': c.application,
      'Questions': c.questions,
      'Prayer': c.prayer,
      'Character': c.characterName,
      'Character lessons': c.characterLessons,
    };
    return items.entries.where((e) => e.value.trim().isNotEmpty).map((e) => Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Align(alignment: Alignment.centerLeft, child: Text('${e.key}:\n${e.value}')),
    )).toList();
  }
}

// ============================================================
// BOOKMARKS / FAVORITES
// ============================================================

class StudyLibraryScreen extends StatefulWidget {
  final List<StudyDay> days;
  final bool favoritesOnly;
  const StudyLibraryScreen({super.key, required this.days, required this.favoritesOnly});
  @override State<StudyLibraryScreen> createState() => _StudyLibraryScreenState();
}

class _StudyLibraryScreenState extends State<StudyLibraryScreen> {
  @override
  Widget build(BuildContext context) {
    final entries = <Map<String, dynamic>>[];
    for (final day in widget.days) {
      for (final c in day.chapters) {
        if (widget.favoritesOnly ? c.favorite : c.bookmarked) entries.add({'day': day, 'chapter': c});
      }
    }
    return Scaffold(
      appBar: AppBar(title: Text(widget.favoritesOnly ? 'Favorites' : 'Bookmarks')),
      body: entries.isEmpty
          ? Center(child: _EmptyCard(icon: widget.favoritesOnly ? Icons.star_border : Icons.bookmark_border, title: widget.favoritesOnly ? 'No favorites yet' : 'No bookmarks yet', message: widget.favoritesOnly ? 'Favorite studies you want to return to.' : 'Bookmark chapters you want to find quickly.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: entries.length,
              itemBuilder: (_, i) {
                final day = entries[i]['day'] as StudyDay;
                final c = entries[i]['chapter'] as ChapterEntry;
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: Icon(widget.favoritesOnly ? Icons.star : Icons.bookmark),
                    title: Text(c.reference.isEmpty ? 'Untitled chapter' : c.reference, style: const TextStyle(fontWeight: FontWeight.w700)),
                    subtitle: Text('${prettyStudyDate(day.dateKey)}${c.summary.trim().isEmpty ? '' : '\n${c.summary.trim()}'}', maxLines: 3, overflow: TextOverflow.ellipsis),
                    isThreeLine: true,
                    trailing: IconButton(
                      tooltip: widget.favoritesOnly ? 'Remove favorite' : 'Remove bookmark',
                      icon: const Icon(Icons.close),
                      onPressed: () => setState(() { if (widget.favoritesOnly) { c.favorite = false; } else { c.bookmarked = false; } StudyStorage.saveDays(widget.days); }),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

// ============================================================
// CHARACTER LIBRARY
// ============================================================

class CharacterLibraryScreen extends StatelessWidget {
  final List<StudyDay> days;
  const CharacterLibraryScreen({super.key, required this.days});

  @override
  Widget build(BuildContext context) {
    final entries = <Map<String, dynamic>>[];
    final seen = <String>{};
    for (final day in days) {
      for (final c in day.chapters) {
        final name = c.characterName.trim();
        if (name.isEmpty) continue;
        final key = name.toLowerCase();
        if (seen.add(key)) entries.add({'name': name, 'chapter': c, 'date': day.dateKey});
      }
    }
    entries.sort((a, b) => (a['name'] as String).toLowerCase().compareTo((b['name'] as String).toLowerCase()));
    return Scaffold(
      appBar: AppBar(title: const Text('Character study library')),
      body: entries.isEmpty
          ? const _EmptyCard(icon: Icons.person_outline, title: 'No characters yet', message: 'Add a character name in Character Study and it will appear here.')
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: entries.length,
              itemBuilder: (_, i) {
                final c = entries[i]['chapter'] as ChapterEntry;
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ExpansionTile(
                    leading: const Icon(Icons.person_outline),
                    title: Text(entries[i]['name'] as String, style: const TextStyle(fontWeight: FontWeight.w700)),
                    subtitle: Text(c.reference.isEmpty ? 'Bible character' : c.reference),
                    childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    children: [
                      if (c.characterWho.trim().isNotEmpty) Text('Who: ${c.characterWho}'),
                      if (c.characterTraits.trim().isNotEmpty) Padding(padding: const EdgeInsets.only(top: 8), child: Text('Traits: ${c.characterTraits}')),
                      if (c.characterActions.trim().isNotEmpty) Padding(padding: const EdgeInsets.only(top: 8), child: Text('Actions: ${c.characterActions}')),
                      if (c.characterLessons.trim().isNotEmpty) Padding(padding: const EdgeInsets.only(top: 8), child: Text('Lessons: ${c.characterLessons}')),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

// ============================================================
// STUDY CALENDAR
// ============================================================

class StudyCalendarScreen extends StatefulWidget {
  final List<StudyDay> days;
  const StudyCalendarScreen({super.key, required this.days});
  @override State<StudyCalendarScreen> createState() => _StudyCalendarScreenState();
}

class _StudyCalendarScreenState extends State<StudyCalendarScreen> {
  DateTime month = DateTime(DateTime.now().year, DateTime.now().month);
  DateTime? selected;

  bool hasStudy(DateTime d) => widget.days.any((x) => x.dateKey == ReadingStorage.dateKey(d));
  StudyDay? dayFor(DateTime d) {
    final key = ReadingStorage.dateKey(d);
    for (final day in widget.days) { if (day.dateKey == key) return day; }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final first = DateTime(month.year, month.month, 1);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final leading = first.weekday - 1;
    final cells = leading + daysInMonth;
    final selectedDay = selected == null ? null : dayFor(selected!);
    return Scaffold(
      appBar: AppBar(title: const Text('Study calendar')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Card(child: Padding(padding: const EdgeInsets.all(14), child: Column(children: [
          Row(children: [
            IconButton(onPressed: () => setState(() => month = DateTime(month.year, month.month - 1)), icon: const Icon(Icons.chevron_left)),
            Expanded(child: Center(child: Text('${_monthName(month.month)} ${month.year}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)))),
            IconButton(onPressed: () => setState(() => month = DateTime(month.year, month.month + 1)), icon: const Icon(Icons.chevron_right)),
          ]),
          const SizedBox(height: 8),
          Row(
            children: ['M', 'T', 'W', 'T', 'F', 'S', 'S']
                .map(
                  (x) => Expanded(
                    child: Center(
                      child: Text(
                        x,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: cells,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, mainAxisSpacing: 6, crossAxisSpacing: 6),
            itemBuilder: (_, index) {
              if (index < leading) return const SizedBox();
              final d = DateTime(month.year, month.month, index - leading + 1);
              final studied = hasStudy(d);
              final isSelected = selected != null && ReadingStorage.dateKey(selected!) == ReadingStorage.dateKey(d);
              return InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => setState(() => selected = d),
                child: Container(
                  decoration: BoxDecoration(color: isSelected ? Theme.of(context).colorScheme.primary : studied ? Theme.of(context).colorScheme.primaryContainer : null, borderRadius: BorderRadius.circular(12), border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(.25))),
                  child: Center(child: Text('${d.day}', style: TextStyle(fontWeight: studied || isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? Theme.of(context).colorScheme.onPrimary : null))),
                ),
              );
            },
          ),
        ]))),
        const SizedBox(height: 14),
        if (selectedDay != null)
          Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(prettyStudyDate(selected!.toIso8601String().substring(0,10)), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('${selectedDay.chapters.length} chapter${selectedDay.chapters.length == 1 ? '' : 's'} studied'),
            const SizedBox(height: 8),
            ...selectedDay.chapters.map((c) => ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.menu_book_outlined), title: Text(c.reference.isEmpty ? 'Untitled chapter' : c.reference), subtitle: Text(c.summary.isEmpty ? 'No summary' : c.summary, maxLines: 2, overflow: TextOverflow.ellipsis))),
          ])))
        else
          const _EmptyCard(icon: Icons.touch_app_outlined, title: 'Choose a day', message: 'Tap a date to see what you studied.'),
      ]),
    );
  }

  String _monthName(int m) => const ['January','February','March','April','May','June','July','August','September','October','November','December'][m - 1];
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
// RICH TEXT FIELD
// ============================================================

class RichStudyField extends StatefulWidget {
  final String label;
  final String hint;

  final String plainText;
  final String richText;

  final ValueChanged<RichFieldValue> onChanged;

  final int minLines;
  final int maxLines;

  const RichStudyField({
    super.key,
    required this.label,
    required this.hint,
    required this.plainText,
    required this.richText,
    required this.onChanged,
    this.minLines = 3,
    this.maxLines = 8,
  });

  @override
  State<RichStudyField> createState() =>
      _RichStudyFieldState();
}

class RichFieldValue {
  final String plainText;
  final String richText;

  const RichFieldValue({
    required this.plainText,
    required this.richText,
  });
}

class _RichStudyFieldState
    extends State<RichStudyField> {
  late QuillController controller;
  late final FocusNode _fieldFocusNode;

  bool _showFormattingToolbar = false;
  bool _toolbarPointerDown = false;
  Timer? _hideToolbarTimer;
  Timer? _saveTimer;

  @override
  void initState() {
    super.initState();

    _fieldFocusNode = FocusNode();
    _fieldFocusNode.addListener(_handleFocusChange);

    final document = documentFromStoredValue(
      widget.richText,
      widget.plainText,
    );

    controller = QuillController(
      document: document,
      selection: TextSelection.collapsed(
        offset: document.length > 0
            ? document.length - 1
            : 0,
      ),
    );

    controller.addListener(_changed);
  }

  void _handleFocusChange() {
    if (!mounted) return;

    if (_fieldFocusNode.hasFocus) {
      _hideToolbarTimer?.cancel();

      if (!_showFormattingToolbar) {
        setState(() {
          _showFormattingToolbar = true;
        });
      }
      return;
    }

    // Quill's toolbar can briefly take focus on Web. Do not
    // immediately remove the toolbar while a formatting button
    // is being pressed.
    if (_toolbarPointerDown) return;

    _hideToolbarTimer?.cancel();
    _hideToolbarTimer = Timer(
      const Duration(milliseconds: 250),
      () {
        if (!mounted ||
            _fieldFocusNode.hasFocus ||
            _toolbarPointerDown) {
          return;
        }

        setState(() {
          _showFormattingToolbar = false;
        });
      },
    );
  }

  void _toolbarPointerDownHandler(PointerDownEvent event) {
    _hideToolbarTimer?.cancel();
    _toolbarPointerDown = true;

    if (mounted && !_showFormattingToolbar) {
      setState(() {
        _showFormattingToolbar = true;
      });
    }
  }

  void _toolbarPointerUpHandler(PointerUpEvent event) {
    _toolbarPointerDown = false;

    // Keep the editor focused after using a formatting button.
    // This prevents the toolbar from disappearing and keeps the
    // cursor/selection available for the next edit.
    if (mounted && !_fieldFocusNode.hasFocus) {
      Future<void>.delayed(
        const Duration(milliseconds: 50),
        () {
          if (!mounted || _toolbarPointerDown) return;

          _fieldFocusNode.requestFocus();

          if (!_showFormattingToolbar) {
            setState(() {
              _showFormattingToolbar = true;
            });
          }
        },
      );
    }
  }

  void _toolbarPointerCancelHandler(PointerCancelEvent event) {
    _toolbarPointerDown = false;
    _handleFocusChange();
  }

  void _changed() {
    final plain = controller.document.toPlainText();
    final value = RichFieldValue(
      plainText: plain.trimRight(),
      richText: documentToJson(
        controller.document,
      ),
    );

    // Do not rebuild the entire ChapterCard on every single
    // keystroke. That was causing the editor to freeze briefly
    // and could also interrupt the formatting toolbar.
    _saveTimer?.cancel();
    _saveTimer = Timer(
      const Duration(milliseconds: 350),
      () {
        if (!mounted) return;
        widget.onChanged(value);
      },
    );
  }

  @override
  void dispose() {
    _saveTimer?.cancel();
    _hideToolbarTimer?.cancel();

    controller.removeListener(_changed);
    controller.dispose();

    _fieldFocusNode.removeListener(_handleFocusChange);
    _fieldFocusNode.dispose();

    super.dispose();
  }

  Widget _buildToolbar(BuildContext context, bool isDark) {
    return Listener(
      onPointerDown: _toolbarPointerDownHandler,
      onPointerUp: _toolbarPointerUpHandler,
      onPointerCancel: _toolbarPointerCancelHandler,
      child: Container(
        decoration: BoxDecoration(
          color: isDark
              ? const Color(0xFF302B38)
              : const Color(0xFFF3F0F6),
          border: Border(
            bottom: BorderSide(
              color: Theme.of(context)
                  .colorScheme
                  .outline
                  .withOpacity(0.25),
            ),
          ),
        ),
        child: QuillSimpleToolbar(
          controller: controller,
          config: QuillSimpleToolbarConfig(
            // IMPORTANT: In flutter_quill 11.5.1 the toggle buttons use
            // buttonOptions/base for their icon theme. Putting iconTheme
            // only on QuillSimpleToolbarConfig does not reliably override
            // the Material 3 selected-button background.
            buttonOptions: QuillSimpleToolbarButtonOptions(
              base: QuillToolbarBaseButtonOptions(
                iconSize: 17,
                iconButtonFactor: 1.0,
                iconTheme: QuillIconTheme(
                  iconButtonSelectedData: IconButtonData(
                    color: Theme.of(context).colorScheme.primary,
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        Theme.of(context).colorScheme.primary.withOpacity(0.12),
                      ),
                      foregroundColor: WidgetStateProperty.resolveWith<Color?>(
                        (_) => Theme.of(context).colorScheme.primary,
                      ),
                      overlayColor: WidgetStateProperty.resolveWith<Color?>(
                        (_) => Colors.transparent,
                      ),
                      shadowColor: WidgetStateProperty.resolveWith<Color?>(
                        (_) => Colors.transparent,
                      ),
                      surfaceTintColor: WidgetStateProperty.resolveWith<Color?>(
                        (_) => Colors.transparent,
                      ),
                      shape: WidgetStateProperty.resolveWith<OutlinedBorder?>(
                        (_) => RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ),
                  iconButtonUnselectedData: IconButtonData(
                    color: Theme.of(context).colorScheme.primary,
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                        (_) => Colors.transparent,
                      ),
                      foregroundColor: WidgetStateProperty.resolveWith<Color?>(
                        (_) => Theme.of(context).colorScheme.primary,
                      ),
                      overlayColor: WidgetStateProperty.resolveWith<Color?>(
                        (_) => Colors.transparent,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // One compact row greatly reduces the delay when the
            // toolbar first appears, while keeping the formatting
            // controls available.
            multiRowsDisplay: false,

            showFontFamily: false,
            showFontSize: false,
            showAlignmentButtons: false,
            showHeaderStyle: false,
            showCodeBlock: false,
            showQuote: false,
            showIndent: false,
            showLink: false,
            showSearchButton: false,
            showDirection: false,
            showSubscript: false,
            showSuperscript: false,
            showClipboardCut: false,
            showClipboardCopy: false,
            showClipboardPaste: false,

            showColorButton: true,
            showBackgroundColorButton: true,
            showClearFormat: true,

            showBoldButton: true,
            showItalicButton: true,
            showUnderLineButton: true,
            showStrikeThrough: true,

            showInlineCode: false,

            showListNumbers: true,
            showListBullets: true,
            showListCheck: true,

            showUndo: true,
            showRedo: true,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface,
            ),
          ),
          const SizedBox(height: 7),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .inputDecorationTheme
                  .fillColor,
              borderRadius:
                  BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context)
                    .colorScheme
                    .outline
                    .withOpacity(0.35),
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                if (_showFormattingToolbar)
                  _buildToolbar(context, isDark),

                Container(
                  constraints: BoxConstraints(
                    minHeight: widget.minLines * 20.0,
                    maxHeight: widget.maxLines * 30.0,
                  ),
                  padding:
                      const EdgeInsets.all(12),
                  child: QuillEditor.basic(
                    controller: controller,
                    focusNode: _fieldFocusNode,
                    config: QuillEditorConfig(
                      // The study question/hint is only shown while
                      // this writing field is active.
                      placeholder:
                          _showFormattingToolbar
                              ? widget.hint
                              : null,
                      padding: EdgeInsets.zero,
                      expands: false,
                      autoFocus: false,
                      scrollable: true,
                      showCursor: true,
                      enableInteractiveSelection: true,
                      enableSelectionToolbar: true,

                      // Do not let Quill's outside-tap handling steal
                      // focus when a toolbar button is pressed.
                      onTapOutsideEnabled: false,
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

  @override
  void initState() {
    super.initState();

    referenceController =
        TextEditingController(
      text: widget.chapter.reference,
    );
  }

  @override
  void dispose() {
    referenceController.dispose();
    super.dispose();
  }

  void syncReference() {
    widget.chapter.reference =
        referenceController.text;

    widget.onChanged();
  }

  void updateRich(
    String plainField,
    String richField,
    RichFieldValue value,
  ) {
    switch (plainField) {
      case 'keyVerse':
        widget.chapter.keyVerse =
            value.plainText;
        widget.chapter.keyVerseRich =
            value.richText;
        break;

      case 'summary':
        widget.chapter.summary =
            value.plainText;
        widget.chapter.summaryRich =
            value.richText;
        break;

      case 'observations':
        widget.chapter.observations =
            value.plainText;
        widget.chapter.observationsRich =
            value.richText;
        break;

      case 'meaning':
        widget.chapter.meaning =
            value.plainText;
        widget.chapter.meaningRich =
            value.richText;
        break;

      case 'lessons':
        widget.chapter.lessons =
            value.plainText;
        widget.chapter.lessonsRich =
            value.richText;
        break;

      case 'application':
        widget.chapter.application =
            value.plainText;
        widget.chapter.applicationRich =
            value.richText;
        break;

      case 'questions':
        widget.chapter.questions =
            value.plainText;
        widget.chapter.questionsRich =
            value.richText;
        break;

      case 'prayer':
        widget.chapter.prayer =
            value.plainText;
        widget.chapter.prayerRich =
            value.richText;
        break;

      case 'characterName':
        widget.chapter.characterName =
            value.plainText;
        widget.chapter.characterNameRich =
            value.richText;
        break;

      case 'characterWho':
        widget.chapter.characterWho =
            value.plainText;
        widget.chapter.characterWhoRich =
            value.richText;
        break;

      case 'characterTraits':
        widget.chapter.characterTraits =
            value.plainText;
        widget.chapter.characterTraitsRich =
            value.richText;
        break;

      case 'characterActions':
        widget.chapter.characterActions =
            value.plainText;
        widget.chapter.characterActionsRich =
            value.richText;
        break;

      case 'characterLessons':
        widget.chapter.characterLessons =
            value.plainText;
        widget.chapter.characterLessonsRich =
            value.richText;
        break;
    }

    widget.onChanged();
  }

  Widget richField(
    String label,
    String hint,
    String plainField,
    String richFieldName, {
    int minLines = 3,
    int maxLines = 8,
  }) {
    String plainValue = '';
    String richValue = '';

    switch (plainField) {
      case 'keyVerse':
        plainValue =
            widget.chapter.keyVerse;
        richValue =
            widget.chapter.keyVerseRich;
        break;

      case 'summary':
        plainValue =
            widget.chapter.summary;
        richValue =
            widget.chapter.summaryRich;
        break;

      case 'observations':
        plainValue =
            widget.chapter.observations;
        richValue =
            widget.chapter.observationsRich;
        break;

      case 'meaning':
        plainValue =
            widget.chapter.meaning;
        richValue =
            widget.chapter.meaningRich;
        break;

      case 'lessons':
        plainValue =
            widget.chapter.lessons;
        richValue =
            widget.chapter.lessonsRich;
        break;

      case 'application':
        plainValue =
            widget.chapter.application;
        richValue =
            widget.chapter.applicationRich;
        break;

      case 'questions':
        plainValue =
            widget.chapter.questions;
        richValue =
            widget.chapter.questionsRich;
        break;

      case 'prayer':
        plainValue =
            widget.chapter.prayer;
        richValue =
            widget.chapter.prayerRich;
        break;

      case 'characterName':
        plainValue =
            widget.chapter.characterName;
        richValue =
            widget.chapter.characterNameRich;
        break;

      case 'characterWho':
        plainValue =
            widget.chapter.characterWho;
        richValue =
            widget.chapter.characterWhoRich;
        break;

      case 'characterTraits':
        plainValue =
            widget.chapter.characterTraits;
        richValue =
            widget.chapter.characterTraitsRich;
        break;

      case 'characterActions':
        plainValue =
            widget.chapter.characterActions;
        richValue =
            widget.chapter.characterActionsRich;
        break;

      case 'characterLessons':
        plainValue =
            widget.chapter.characterLessons;
        richValue =
            widget.chapter.characterLessonsRich;
        break;
    }

    return RichStudyField(
      key: ValueKey('${widget.chapter.id}-$plainField'),
      label: label,
      hint: hint,
      plainText: plainValue,
      richText: richValue,
      minLines: minLines,
      maxLines: maxLines,
      onChanged: (value) {
        updateRich(
          plainField,
          richFieldName,
          value,
        );
      },
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
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: widget.chapter.bookmarked ? 'Remove bookmark' : 'Bookmark',
              onPressed: () {
                setState(() => widget.chapter.bookmarked = !widget.chapter.bookmarked);
                widget.onChanged();
              },
              icon: Icon(widget.chapter.bookmarked ? Icons.bookmark : Icons.bookmark_border),
            ),
            IconButton(
              tooltip: widget.chapter.favorite ? 'Remove favorite' : 'Favorite',
              onPressed: () {
                setState(() => widget.chapter.favorite = !widget.chapter.favorite);
                widget.onChanged();
              },
              icon: Icon(widget.chapter.favorite ? Icons.star : Icons.star_border),
            ),
            const Icon(Icons.expand_more),
          ],
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
                (_) => syncReference(),
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
            title: 'Chapter Study',
          ),

          richField(
            'Key verse',
            'Which verse stands out to you?',
            'keyVerse',
            'keyVerseRich',
            minLines: 2,
            maxLines: 5,
          ),

          richField(
            'What happens in this chapter?',
            'Summarize the chapter in your own words.',
            'summary',
            'summaryRich',
          ),

          richField(
            'What do you notice?',
            'Important people, events, commands, promises, repeated words, contrasts, etc.',
            'observations',
            'observationsRich',
          ),

          richField(
            'What does it mean?',
            'What do you think the main message of the chapter is?',
            'meaning',
            'meaningRich',
          ),

          richField(
            'What does this teach me about God?',
            'God’s character, His will, His promises, His actions, etc.',
            'lessons',
            'lessonsRich',
          ),

          richField(
            'How should I respond?',
            'What can you believe, change, obey, practice, or remember?',
            'application',
            'applicationRich',
          ),

          richField(
            'Questions I still have',
            'Write anything you do not understand or want to study later.',
            'questions',
            'questionsRich',
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

              richField(
                'Character name',
                'Example: Peter',
                'characterName',
                'characterNameRich',
                minLines: 1,
                maxLines: 3,
              ),

              richField(
                'Who is this person?',
                'What do we learn about their identity and role?',
                'characterWho',
                'characterWhoRich',
              ),

              richField(
                'What character traits do I see?',
                'Faith, courage, weakness, humility, pride, obedience, etc.',
                'characterTraits',
                'characterTraitsRich',
              ),

              richField(
                'What did this person do?',
                'Important choices, words, actions, successes, failures.',
                'characterActions',
                'characterActionsRich',
              ),

              richField(
                'What can I learn from this person?',
                'What should I imitate, avoid, or learn from their story?',
                'characterLessons',
                'characterLessonsRich',
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

          richField(
            'Prayer / personal response',
            'Write a short prayer or personal response to what you studied.',
            'prayer',
            'prayerRich',
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
