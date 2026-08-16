import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BitaniyaBibleStudyApp());
}

class BitaniyaBibleStudyApp extends StatelessWidget {
  const BitaniyaBibleStudyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bitaniya Bible Study',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFCF9F6),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      home: const HomePage(),
    );
  }
}

// ============================================================
// DATA MODELS
// ============================================================

class ChapterStudy {
  String id;
  String book;
  String chapter;
  String passage;
  bool completed;

  // Character Study
  String character;
  String knownFor;
  String charBooks;
  String charChapters;
  String charStory;
  String traits;
  String charVerses;
  String charLearn;
  String charApply;
  String charChallenges;
  String charGodUsed;
  String charTakeaway;
  String charPrayer;

  // Chapter Study
  String summary;
  String chapterCharacters;
  String concepts;
  String chapterChallenge;
  String chapterVerse;

  // Quiet Time
  String noticed;
  String remember;
  String aboutGod;
  String aboutChrist;
  String aboutHumans;
  String response;

  // Reflection
  String questions;
  String lifeApplication;
  String studyFurther;
  String teaching;
  String memoryVerse;
  String reflectionPrayer;

  ChapterStudy({
    required this.id,
    this.book = '',
    this.chapter = '',
    this.passage = '',
    this.completed = false,
    this.character = '',
    this.knownFor = '',
    this.charBooks = '',
    this.charChapters = '',
    this.charStory = '',
    this.traits = '',
    this.charVerses = '',
    this.charLearn = '',
    this.charApply = '',
    this.charChallenges = '',
    this.charGodUsed = '',
    this.charTakeaway = '',
    this.charPrayer = '',
    this.summary = '',
    this.chapterCharacters = '',
    this.concepts = '',
    this.chapterChallenge = '',
    this.chapterVerse = '',
    this.noticed = '',
    this.remember = '',
    this.aboutGod = '',
    this.aboutChrist = '',
    this.aboutHumans = '',
    this.response = '',
    this.questions = '',
    this.lifeApplication = '',
    this.studyFurther = '',
    this.teaching = '',
    this.memoryVerse = '',
    this.reflectionPrayer = '',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'book': book,
        'chapter': chapter,
        'passage': passage,
        'completed': completed,
        'character': character,
        'knownFor': knownFor,
        'charBooks': charBooks,
        'charChapters': charChapters,
        'charStory': charStory,
        'traits': traits,
        'charVerses': charVerses,
        'charLearn': charLearn,
        'charApply': charApply,
        'charChallenges': charChallenges,
        'charGodUsed': charGodUsed,
        'charTakeaway': charTakeaway,
        'charPrayer': charPrayer,
        'summary': summary,
        'chapterCharacters': chapterCharacters,
        'concepts': concepts,
        'chapterChallenge': chapterChallenge,
        'chapterVerse': chapterVerse,
        'noticed': noticed,
        'remember': remember,
        'aboutGod': aboutGod,
        'aboutChrist': aboutChrist,
        'aboutHumans': aboutHumans,
        'response': response,
        'questions': questions,
        'lifeApplication': lifeApplication,
        'studyFurther': studyFurther,
        'teaching': teaching,
        'memoryVerse': memoryVerse,
        'reflectionPrayer': reflectionPrayer,
      };

  factory ChapterStudy.fromJson(Map<String, dynamic> j) {
    String s(String key) => j[key]?.toString() ?? '';

    return ChapterStudy(
      id: s('id'),
      book: s('book'),
      chapter: s('chapter'),
      passage: s('passage'),
      completed: j['completed'] == true,
      character: s('character'),
      knownFor: s('knownFor'),
      charBooks: s('charBooks'),
      charChapters: s('charChapters'),
      charStory: s('charStory'),
      traits: s('traits'),
      charVerses: s('charVerses'),
      charLearn: s('charLearn'),
      charApply: s('charApply'),
      charChallenges: s('charChallenges'),
      charGodUsed: s('charGodUsed'),
      charTakeaway: s('charTakeaway'),
      charPrayer: s('charPrayer'),
      summary: s('summary'),
      chapterCharacters: s('chapterCharacters'),
      concepts: s('concepts'),
      chapterChallenge: s('chapterChallenge'),
      chapterVerse: s('chapterVerse'),
      noticed: s('noticed'),
      remember: s('remember'),
      aboutGod: s('aboutGod'),
      aboutChrist: s('aboutChrist'),
      aboutHumans: s('aboutHumans'),
      response: s('response'),
      questions: s('questions'),
      lifeApplication: s('lifeApplication'),
      studyFurther: s('studyFurther'),
      teaching: s('teaching'),
      memoryVerse: s('memoryVerse'),
      reflectionPrayer: s('reflectionPrayer'),
    );
  }
}

class DailyStudy {
  String id;
  String date;
  int goal;
  List<ChapterStudy> chapters;

  DailyStudy({
    required this.id,
    required this.date,
    this.goal = 3,
    List<ChapterStudy>? chapters,
  }) : chapters = chapters ?? [];

  int get completedCount =>
      chapters.where((chapter) => chapter.completed).length;

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date,
        'goal': goal,
        'chapters': chapters.map((e) => e.toJson()).toList(),
      };

  factory DailyStudy.fromJson(Map<String, dynamic> j) {
    final raw = j['chapters'];

    return DailyStudy(
      id: j['id']?.toString() ?? '',
      date: j['date']?.toString() ?? '',
      goal: int.tryParse(j['goal']?.toString() ?? '') ?? 3,
      chapters: raw is List
          ? raw
              .map((e) =>
                  ChapterStudy.fromJson(Map<String, dynamic>.from(e)))
              .toList()
          : [],
    );
  }
}

// ============================================================
// STORAGE
// ============================================================

class Store {
  static const String newKey = 'bitaniya_daily_studies_v3';
  static const String oldKey = 'bitaniya_bible_studies_v2';

  static Future<List<DailyStudy>> load() async {
    final prefs = await SharedPreferences.getInstance();

    final raw = prefs.getString(newKey);

    if (raw != null) {
      try {
        final decoded = jsonDecode(raw) as List;

        return decoded
            .map((e) => DailyStudy.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      } catch (_) {}
    }

    // Migrate the previous version automatically.
    final oldRaw = prefs.getString(oldKey);

    if (oldRaw != null) {
      try {
        final oldList = jsonDecode(oldRaw) as List;

        final converted = <DailyStudy>[];

        for (final item in oldList) {
          final j = Map<String, dynamic>.from(item);

          final chapter = ChapterStudy.fromJson({
            ...j,
            'id': '${j['id']}_chapter',
          });

          converted.add(
            DailyStudy(
              id: j['id']?.toString() ??
                  DateTime.now().microsecondsSinceEpoch.toString(),
              date: j['date']?.toString() ?? fmt(DateTime.now()),
              goal: 3,
              chapters: [chapter],
            ),
          );
        }

        await save(converted);
        return converted;
      } catch (_) {}
    }

    return [];
  }

  static Future<void> save(List<DailyStudy> studies) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      newKey,
      jsonEncode(studies.map((e) => e.toJson()).toList()),
    );
  }
}

// ============================================================
// HOME
// ============================================================

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<DailyStudy> studies = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final result = await Store.load();

    result.sort((a, b) => b.date.compareTo(a.date));

    if (!mounted) return;

    setState(() {
      studies = result;
      loading = false;
    });
  }

  Future<void> _createDailyStudy() async {
    final daily = DailyStudy(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      date: fmt(DateTime.now()),
      goal: 3,
    );

    final result = await Navigator.push<DailyStudy>(
      context,
      MaterialPageRoute(
        builder: (_) => DailyStudyPage(daily: daily),
      ),
    );

    if (result == null) return;

    setState(() {
      studies.add(result);
      studies.sort((a, b) => b.date.compareTo(a.date));
    });

    await Store.save(studies);
  }

  Future<void> _open(DailyStudy daily) async {
    final result = await Navigator.push<DailyStudy>(
      context,
      MaterialPageRoute(
        builder: (_) => DailyStudyPage(daily: daily),
      ),
    );

    if (result == null) return;

    setState(() {
      final index = studies.indexWhere((e) => e.id == result.id);

      if (index >= 0) {
        studies[index] = result;
      }

      studies.sort((a, b) => b.date.compareTo(a.date));
    });

    await Store.save(studies);
  }

  Future<void> _delete(DailyStudy daily) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete daily study?'),
        content: Text(
          'Delete the complete study for ${daily.date}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (yes != true) return;

    setState(() {
      studies.removeWhere((e) => e.id == daily.id);
    });

    await Store.save(studies);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bitaniya Bible Study'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.brown.shade800,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.pink.shade50,
                        Colors.orange.shade50,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.pink.shade100,
                    ),
                  ),
                  child: const Column(
                    children: [
                      Text('📖', style: TextStyle(fontSize: 42)),
                      SizedBox(height: 6),
                      Text(
                        'BITANIYA BIBLE STUDY',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Study multiple Bible chapters every day in one organized journal.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                FilledButton.icon(
                  onPressed: _createDailyStudy,
                  icon: const Icon(Icons.add),
                  label: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      'CREATE NEW DAILY STUDY',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                const Heading('MY DAILY STUDIES'),

                const SizedBox(height: 8),

                if (studies.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.grey.shade300,
                      ),
                    ),
                    child: const Column(
                      children: [
                        Icon(
                          Icons.calendar_month_outlined,
                          size: 48,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'No daily studies yet.',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Create your first daily study. '
                          'You can add as many chapters as you want.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                  )
                else
                  ...studies.map(
                    (daily) => Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: CircleAvatar(
                          backgroundColor: Colors.pink.shade50,
                          child: Icon(
                            Icons.menu_book,
                            color: Colors.pink.shade700,
                          ),
                        ),
                        title: Text(
                          daily.date,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            '${daily.chapters.length} '
                            '${daily.chapters.length == 1 ? 'chapter' : 'chapters'} • '
                            '${daily.completedCount} completed • '
                            'Goal: ${daily.goal}',
                          ),
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'open') {
                              _open(daily);
                            }

                            if (value == 'delete') {
                              _delete(daily);
                            }
                          },
                          itemBuilder: (_) => const [
                            PopupMenuItem(
                              value: 'open',
                              child: Text('Open / Edit'),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete'),
                            ),
                          ],
                        ),
                        onTap: () => _open(daily),
                      ),
                    ),
                  ),

                const SizedBox(height: 24),

                const Heading('TOOLS'),

                ToolCard(
                  'New Testament Reading Tracker',
                  'Track every New Testament chapter. Progress saves automatically.',
                  Icons.check_circle_outline,
                  const TrackerPage(),
                ),
              ],
            ),
    );
  }
}

// ============================================================
// DAILY STUDY PAGE
// ============================================================

class DailyStudyPage extends StatefulWidget {
  final DailyStudy daily;

  const DailyStudyPage({
    super.key,
    required this.daily,
  });

  @override
  State<DailyStudyPage> createState() => _DailyStudyPageState();
}

class _DailyStudyPageState extends State<DailyStudyPage> {
  late DailyStudy daily;
  late TextEditingController dateController;
  late TextEditingController goalController;

  @override
  void initState() {
    super.initState();

    daily = widget.daily;

    dateController = TextEditingController(
      text: daily.date,
    );

    goalController = TextEditingController(
      text: daily.goal.toString(),
    );
  }

  @override
  void dispose() {
    dateController.dispose();
    goalController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final current =
        DateTime.tryParse(dateController.text) ?? DateTime.now();

    final selected = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selected != null) {
      setState(() {
        dateController.text = fmt(selected);
        daily.date = fmt(selected);
      });
    }
  }

  void _updateGoal() {
    final value = int.tryParse(goalController.text.trim());

    setState(() {
      daily.goal = value == null || value < 0 ? 3 : value;
    });
  }

  Future<void> _addChapter() async {
    final chapter = ChapterStudy(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
    );

    final result = await Navigator.push<ChapterStudy>(
      context,
      MaterialPageRoute(
        builder: (_) => ChapterStudyPage(chapter: chapter),
      ),
    );

    if (result == null) return;

    setState(() {
      daily.chapters.add(result);
    });
  }

  Future<void> _editChapter(ChapterStudy chapter) async {
    final result = await Navigator.push<ChapterStudy>(
      context,
      MaterialPageRoute(
        builder: (_) => ChapterStudyPage(chapter: chapter),
      ),
    );

    if (result == null) return;

    setState(() {
      final index =
          daily.chapters.indexWhere((e) => e.id == result.id);

      if (index >= 0) {
        daily.chapters[index] = result;
      }
    });
  }

  void _toggleComplete(ChapterStudy chapter, bool value) {
    setState(() {
      chapter.completed = value;
    });
  }

  void _removeChapter(ChapterStudy chapter) {
    setState(() {
      daily.chapters.removeWhere((e) => e.id == chapter.id);
    });
  }

  void _saveDaily() {
    daily.date = dateController.text.trim();

    final goal = int.tryParse(goalController.text.trim());

    if (goal != null && goal >= 0) {
      daily.goal = goal;
    }

    Navigator.pop(context, daily);
  }

  @override
  Widget build(BuildContext context) {
    final total = daily.chapters.length;
    final completed = daily.completedCount;

    final progress = total == 0 ? 0.0 : completed / total;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Bible Study'),
        backgroundColor: Colors.pink.shade50,
        foregroundColor: Colors.brown.shade800,
        actions: [
          IconButton(
            tooltip: 'Save',
            onPressed: _saveDaily,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Heading('📅 DAILY BIBLE STUDY'),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.pink.shade100,
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: dateController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: 'DATE',
                          prefixIcon:
                              Icon(Icons.calendar_today),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filledTonal(
                      onPressed: _pickDate,
                      icon: const Icon(Icons.edit_calendar),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: goalController,
                        keyboardType: TextInputType.number,
                        onChanged: (_) => _updateGoal(),
                        decoration: const InputDecoration(
                          labelText: 'DAILY CHAPTER GOAL',
                          helperText:
                              '3 is the default. Change it or use 0 for no goal.',
                          prefixIcon:
                              Icon(Icons.flag_outlined),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.pink.shade50,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'TODAY\'S PROGRESS',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$completed / $total',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.pink.shade800,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                LinearProgressIndicator(
                  value: progress,
                  minHeight: 9,
                ),

                const SizedBox(height: 8),

                Text(
                  total == 0
                      ? 'Add your first chapter below.'
                      : '$completed of $total chapters completed',
                  style: const TextStyle(
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              const Expanded(
                child: Heading('📚 TODAY\'S CHAPTERS'),
              ),
              FilledButton.icon(
                onPressed: _addChapter,
                icon: const Icon(Icons.add),
                label: const Text('Add Chapter'),
              ),
            ],
          ),

          const SizedBox(height: 8),

          if (daily.chapters.isEmpty)
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.grey.shade300,
                ),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.library_add_outlined,
                    size: 42,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'No chapters added yet.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Tap "Add Chapter" to add Matthew 1, '
                    'Matthew 2, Matthew 3, or as many chapters '
                    'as you want.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            )
          else
            ...daily.chapters.asMap().entries.map(
              (entry) {
                final index = entry.key;
                final chapter = entry.value;

                final title = chapter.book.isEmpty
                    ? 'Chapter ${index + 1}'
                    : '${chapter.book} ${chapter.chapter}'.trim();

                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Checkbox(
                          value: chapter.completed,
                          onChanged: (value) {
                            _toggleComplete(
                              chapter,
                              value ?? false,
                            );
                          },
                        ),
                        Expanded(
                          child: ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(
                              horizontal: 4,
                            ),
                            title: Text(
                              title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration:
                                    chapter.completed
                                        ? TextDecoration
                                            .lineThrough
                                        : null,
                              ),
                            ),
                            subtitle: Text(
                              chapter.passage.isEmpty
                                  ? 'Tap to open the complete study'
                                  : chapter.passage,
                              maxLines: 2,
                              overflow:
                                  TextOverflow.ellipsis,
                            ),
                            onTap: () =>
                                _editChapter(chapter),
                          ),
                        ),
                        PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'edit') {
                              _editChapter(chapter);
                            }

                            if (value == 'delete') {
                              _removeChapter(chapter);
                            }
                          },
                          itemBuilder: (_) => const [
                            PopupMenuItem(
                              value: 'edit',
                              child: Text('Open / Edit'),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Text('Remove'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

          const SizedBox(height: 20),

          FilledButton.icon(
            onPressed: _saveDaily,
            icon: const Icon(Icons.save),
            label: const Padding(
              padding: EdgeInsets.all(14),
              child: Text(
                'SAVE DAILY STUDY',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

// ============================================================
// CHAPTER STUDY PAGE
// ============================================================

class ChapterStudyPage extends StatefulWidget {
  final ChapterStudy chapter;

  const ChapterStudyPage({
    super.key,
    required this.chapter,
  });

  @override
  State<ChapterStudyPage> createState() =>
      _ChapterStudyPageState();
}

class _ChapterStudyPageState
    extends State<ChapterStudyPage> {
  late final Map<String, TextEditingController> c;

  @override
  void initState() {
    super.initState();

    final e = widget.chapter;

    c = {
      'book': TextEditingController(text: e.book),
      'chapter': TextEditingController(text: e.chapter),
      'passage': TextEditingController(text: e.passage),

      'character': TextEditingController(text: e.character),
      'knownFor': TextEditingController(text: e.knownFor),
      'charBooks': TextEditingController(text: e.charBooks),
      'charChapters': TextEditingController(text: e.charChapters),
      'charStory': TextEditingController(text: e.charStory),
      'traits': TextEditingController(text: e.traits),
      'charVerses': TextEditingController(text: e.charVerses),
      'charLearn': TextEditingController(text: e.charLearn),
      'charApply': TextEditingController(text: e.charApply),
      'charChallenges':
          TextEditingController(text: e.charChallenges),
      'charGodUsed':
          TextEditingController(text: e.charGodUsed),
      'charTakeaway':
          TextEditingController(text: e.charTakeaway),
      'charPrayer':
          TextEditingController(text: e.charPrayer),

      'summary': TextEditingController(text: e.summary),
      'chapterCharacters':
          TextEditingController(text: e.chapterCharacters),
      'concepts':
          TextEditingController(text: e.concepts),
      'chapterChallenge':
          TextEditingController(text: e.chapterChallenge),
      'chapterVerse':
          TextEditingController(text: e.chapterVerse),

      'noticed':
          TextEditingController(text: e.noticed),
      'remember':
          TextEditingController(text: e.remember),
      'aboutGod':
          TextEditingController(text: e.aboutGod),
      'aboutChrist':
          TextEditingController(text: e.aboutChrist),
      'aboutHumans':
          TextEditingController(text: e.aboutHumans),
      'response':
          TextEditingController(text: e.response),

      'questions':
          TextEditingController(text: e.questions),
      'lifeApplication':
          TextEditingController(text: e.lifeApplication),
      'studyFurther':
          TextEditingController(text: e.studyFurther),
      'teaching':
          TextEditingController(text: e.teaching),
      'memoryVerse':
          TextEditingController(text: e.memoryVerse),
      'reflectionPrayer':
          TextEditingController(text: e.reflectionPrayer),
    };
  }

  @override
  void dispose() {
    for (final controller in c.values) {
      controller.dispose();
    }

    super.dispose();
  }

  String value(String key) => c[key]!.text.trim();

  Widget field(
    String key,
    String label, {
    int lines = 3,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: c[key],
        maxLines: lines,
        decoration: InputDecoration(
          labelText: label,
          alignLabelWithHint: true,
        ),
      ),
    );
  }

  void save() {
    final e = widget.chapter;

    e.book = value('book');
    e.chapter = value('chapter');
    e.passage = value('passage');

    e.character = value('character');
    e.knownFor = value('knownFor');
    e.charBooks = value('charBooks');
    e.charChapters = value('charChapters');
    e.charStory = value('charStory');
    e.traits = value('traits');
    e.charVerses = value('charVerses');
    e.charLearn = value('charLearn');
    e.charApply = value('charApply');
    e.charChallenges = value('charChallenges');
    e.charGodUsed = value('charGodUsed');
    e.charTakeaway = value('charTakeaway');
    e.charPrayer = value('charPrayer');

    e.summary = value('summary');
    e.chapterCharacters = value('chapterCharacters');
    e.concepts = value('concepts');
    e.chapterChallenge = value('chapterChallenge');
    e.chapterVerse = value('chapterVerse');

    e.noticed = value('noticed');
    e.remember = value('remember');
    e.aboutGod = value('aboutGod');
    e.aboutChrist = value('aboutChrist');
    e.aboutHumans = value('aboutHumans');
    e.response = value('response');

    e.questions = value('questions');
    e.lifeApplication = value('lifeApplication');
    e.studyFurther = value('studyFurther');
    e.teaching = value('teaching');
    e.memoryVerse = value('memoryVerse');
    e.reflectionPrayer = value('reflectionPrayer');

    Navigator.pop(context, e);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chapter Bible Study'),
        backgroundColor: Colors.pink.shade50,
        foregroundColor: Colors.brown.shade800,
        actions: [
          IconButton(
            onPressed: save,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Heading('📖 CHAPTER STUDY'),

          Responsive([
            field('book', 'BOOK', lines: 1),
            field('chapter', 'CHAPTER', lines: 1),
          ]),

          field(
            'passage',
            'TODAY\'S PASSAGE / REFERENCE',
            lines: 3,
          ),

          Section(
            '1',
            'BIBLE CHARACTER STUDY',
            'Learning from their story. Growing in our faith.',
            Colors.pink,
            [
              Responsive([
                field('character', 'CHARACTER', lines: 1),
                field('knownFor', 'KNOWN FOR', lines: 1),
              ]),
              Responsive([
                field('charBooks', 'BOOK(S)', lines: 1),
                field('charChapters', 'CHAPTER(S)', lines: 1),
              ]),
              field(
                'charStory',
                'TELL THEIR STORY IN YOUR OWN WORDS',
                lines: 6,
              ),
              Responsive([
                field(
                  'traits',
                  'TRAITS — WHAT WORDS DESCRIBE THIS PERSON?',
                  lines: 5,
                ),
                field(
                  'charVerses',
                  'KEY VERSE(S)',
                  lines: 5,
                ),
              ]),
              field(
                'charLearn',
                'WHAT CAN WE LEARN FROM THEIR LIFE?',
                lines: 5,
              ),
              field(
                'charApply',
                'HOW CAN WE APPLY THIS TO OUR LIFE TODAY?',
                lines: 5,
              ),
              Responsive([
                field(
                  'charChallenges',
                  'CHALLENGES — STRUGGLES, MISTAKES, OR HARD MOMENTS',
                  lines: 5,
                ),
                field(
                  'charGodUsed',
                  'HOW GOD USED THEM',
                  lines: 5,
                ),
              ]),
              field(
                'charTakeaway',
                'BIGGEST TAKEAWAY',
                lines: 4,
              ),
              field(
                'charPrayer',
                'A PRAYER',
                lines: 5,
              ),
            ],
          ),

          Section(
            '2',
            'CHAPTER STUDY',
            'Passage summary, key concepts, and challenges.',
            Colors.brown,
            [
              field('summary', 'SUMMARY', lines: 6),
              Responsive([
                field(
                  'chapterCharacters',
                  'CHARACTERS',
                  lines: 5,
                ),
                field(
                  'concepts',
                  'KEY CONCEPTS',
                  lines: 5,
                ),
              ]),
              field(
                'chapterChallenge',
                'SOMETHING THAT CHALLENGED ME',
                lines: 5,
              ),
              field(
                'chapterVerse',
                'A VERSE THAT STOOD OUT',
                lines: 4,
              ),
            ],
          ),

          Section(
            '3',
            'QUIET TIME NOTES',
            'What this says about God, Christ, humans, and response.',
            Colors.teal,
            [
              Responsive([
                field(
                  'noticed',
                  '3 THINGS I NOTICED',
                  lines: 5,
                ),
                field(
                  'remember',
                  '3 THINGS TO REMEMBER',
                  lines: 5,
                ),
              ]),
              Responsive([
                field(
                  'aboutGod',
                  'WHAT DOES THIS SAY ABOUT GOD?',
                  lines: 5,
                ),
                field(
                  'aboutChrist',
                  'WHAT DOES THIS SAY ABOUT CHRIST?',
                  lines: 5,
                ),
              ]),
              Responsive([
                field(
                  'aboutHumans',
                  'WHAT DOES THIS SAY ABOUT HUMANS?',
                  lines: 5,
                ),
                field(
                  'response',
                  'HOW SHOULD WE RESPOND?',
                  lines: 5,
                ),
              ]),
            ],
          ),

          Section(
            '4',
            'REFLECTION JOURNAL',
            'Questions, application, memory verse, and prayer.',
            Colors.indigo,
            [
              Responsive([
                field(
                  'questions',
                  'WHAT QUESTIONS DO I HAVE?',
                  lines: 5,
                ),
                field(
                  'lifeApplication',
                  'HOW DOES THIS APPLY TO MY LIFE?',
                  lines: 5,
                ),
              ]),
              field(
                'studyFurther',
                'WHAT DO I NEED TO STUDY FURTHER?',
                lines: 5,
              ),
              field(
                'teaching',
                'WHAT IS THIS CHAPTER TEACHING ME?',
                lines: 7,
              ),
              field(
                'memoryVerse',
                'MEMORY VERSE',
                lines: 4,
              ),
              field(
                'reflectionPrayer',
                'PRAYER',
                lines: 6,
              ),
            ],
          ),

          FilledButton.icon(
            onPressed: save,
            icon: const Icon(Icons.save),
            label: const Padding(
              padding: EdgeInsets.all(14),
              child: Text(
                'SAVE CHAPTER STUDY',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

// ============================================================
// REUSABLE UI
// ============================================================

class Heading extends StatelessWidget {
  final String text;

  const Heading(
    this.text, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.brown,
        ),
      ),
    );
  }
}

class ToolCard extends StatelessWidget {
  final String title;
  final String sub;
  final IconData icon;
  final Widget page;

  const ToolCard(
    this.title,
    this.sub,
    this.icon,
    this.page, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.brown.shade500,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(sub),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 15,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => page,
            ),
          );
        },
      ),
    );
  }
}

class Section extends StatelessWidget {
  final String number;
  final String title;
  final String subtitle;
  final MaterialColor color;
  final List<Widget> children;

  const Section(
    this.number,
    this.title,
    this.subtitle,
    this.color,
    this.children, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.shade50.withOpacity(.45),
        border: Border.all(
          color: color.shade200,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 17,
                backgroundColor: color.shade100,
                foregroundColor: color.shade800,
                child: Text(
                  number,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: color.shade800,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class Responsive extends StatelessWidget {
  final List<Widget> children;

  const Responsive(
    this.children, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 720) {
          return Column(
            children: children,
          );
        }

        return Row(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Expanded(child: children[0]),
            const SizedBox(width: 12),
            Expanded(child: children[1]),
          ],
        );
      },
    );
  }
}

// ============================================================
// NEW TESTAMENT TRACKER
// ============================================================

class TrackerPage extends StatefulWidget {
  const TrackerPage({super.key});

  @override
  State<TrackerPage> createState() =>
      _TrackerPageState();
}

class _TrackerPageState extends State<TrackerPage> {
  static const String storageKey =
      'bitaniya_nt_tracker_v2';

  final Map<String, int> books = const {
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

  final Map<String, Set<int>> read = {};

  bool loading = true;
  bool saving = false;

  int get total =>
      books.values.fold(0, (a, b) => a + b);

  int get done =>
      read.values.fold(0, (a, b) => a + b.length);

  @override
  void initState() {
    super.initState();
    _loadTracker();
  }

  Future<void> _loadTracker() async {
    final prefs =
        await SharedPreferences.getInstance();

    final saved =
        prefs.getStringList(storageKey) ??
            <String>[];

    for (final item in saved) {
      final parts = item.split('|');

      if (parts.length != 2) continue;

      final chapter = int.tryParse(parts[1]);

      if (chapter == null ||
          !books.containsKey(parts[0])) {
        continue;
      }

      read
          .putIfAbsent(
            parts[0],
            () => <int>{},
          )
          .add(chapter);
    }

    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> _saveTracker() async {
    if (mounted) {
      setState(() {
        saving = true;
      });
    }

    final all = <String>[];

    for (final entry in read.entries) {
      for (final chapter in entry.value) {
        all.add('${entry.key}|$chapter');
      }
    }

    all.sort();

    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setStringList(
      storageKey,
      all,
    );

    if (mounted) {
      setState(() {
        saving = false;
      });
    }
  }

  Future<void> _toggle(
    String book,
    int chapter,
    bool selected,
  ) async {
    final set =
        read.putIfAbsent(book, () => <int>{});

    setState(() {
      if (selected) {
        set.add(chapter);
      } else {
        set.remove(chapter);
      }
    });

    await _saveTracker();
  }

  Future<void> _reset() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          'Reset reading progress?',
        ),
        content: const Text(
          'This will uncheck every New Testament chapter.',
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
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (ok != true) return;

    read.clear();

    final prefs =
        await SharedPreferences.getInstance();

    await prefs.remove(storageKey);

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress =
        total == 0 ? 0.0 : done / total;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'New Testament Reading Tracker',
        ),
        backgroundColor:
            Colors.blue.shade100,
        foregroundColor:
            Colors.blue.shade900,
        actions: [
          IconButton(
            tooltip: 'Reset progress',
            onPressed:
                loading ? null : _reset,
            icon: const Icon(
              Icons.restart_alt,
            ),
          ),
        ],
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              padding:
                  const EdgeInsets.all(16),
              children: [
                const Text(
                  'NEW TESTAMENT BIBLE READING TRACKER',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.blue,
                  ),
                ),

                const SizedBox(height: 6),

                const Text(
                  'Your chapter progress is saved automatically on this device/browser.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                ),

                const SizedBox(height: 16),

                LinearProgressIndicator(
                  value: progress,
                  minHeight: 10,
                ),

                const SizedBox(height: 8),

                Text(
                  '$done of $total chapters completed '
                  '(${(progress * 100).round()}%)',
                  textAlign: TextAlign.center,
                ),

                if (saving)
                  const Padding(
                    padding:
                        EdgeInsets.only(top: 6),
                    child: Text(
                      'Saving…',
                      textAlign:
                          TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ),

                const SizedBox(height: 16),

                ...books.entries.map(
                  (entry) {
                    final completed =
                        read[entry.key]
                                ?.length ??
                            0;

                    final set =
                        read.putIfAbsent(
                      entry.key,
                      () => <int>{},
                    );

                    return Card(
                      margin:
                          const EdgeInsets.only(
                        bottom: 8,
                      ),
                      child: ExpansionTile(
                        title: Text(
                          entry.key,
                          style: const TextStyle(
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          '$completed/${entry.value} chapters completed',
                        ),
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(
                              12,
                              0,
                              12,
                              14,
                            ),
                            child: Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children:
                                  List.generate(
                                entry.value,
                                (index) {
                                  final chapter =
                                      index + 1;

                                  return FilterChip(
                                    label: Text(
                                      '$chapter',
                                    ),
                                    selected:
                                        set.contains(
                                      chapter,
                                    ),
                                    onSelected:
                                        (value) =>
                                            _toggle(
                                      entry.key,
                                      chapter,
                                      value,
                                    ),
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

                const SizedBox(height: 20),
              ],
            ),
    );
  }
}

// ============================================================
// DATE
// ============================================================

String fmt(DateTime d) {
  return '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';
}
