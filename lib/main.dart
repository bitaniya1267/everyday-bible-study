import 'dart:convert';
import 'dart:html' as html;

import 'package:flutter/material.dart';

void main() {
  runApp(const BitaniyaBibleStudyApp());
}

// ============================================================
// APP
// ============================================================

class BitaniyaBibleStudyApp extends StatelessWidget {
  const BitaniyaBibleStudyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bitaniya Bible Study',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF9A5C78),
        ),
        scaffoldBackgroundColor: const Color(0xFFFCF9F6),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color(0xFF9A5C78),
              width: 2,
            ),
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}

// ============================================================
// STORAGE
// ============================================================

class AppStorage {
  static const studiesKey = 'bitaniya_daily_studies';
  static const trackerKey = 'bitaniya_nt_tracker';

  static List<Map<String, dynamic>> studies() {
    final raw = html.window.localStorage[studiesKey];

    if (raw == null || raw.isEmpty) return [];

    try {
      final decoded = jsonDecode(raw);

      if (decoded is List) {
        return decoded
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      }
    } catch (_) {}

    return [];
  }

  static void saveStudies(List<Map<String, dynamic>> data) {
    html.window.localStorage[studiesKey] = jsonEncode(data);
  }

  static Set<String> tracker() {
    final raw = html.window.localStorage[trackerKey];

    if (raw == null || raw.isEmpty) return {};

    try {
      final decoded = jsonDecode(raw);

      if (decoded is List) {
        return decoded.map((e) => e.toString()).toSet();
      }
    } catch (_) {}

    return {};
  }

  static void saveTracker(Set<String> data) {
    html.window.localStorage[trackerKey] =
        jsonEncode(data.toList());
  }

  static Map<String, dynamic> backup() {
    return {
      'app': 'Bitaniya Bible Study',
      'version': 3,
      'created': DateTime.now().toIso8601String(),
      'studies': studies(),
      'tracker': tracker().toList(),
    };
  }

  static bool restore(Map<String, dynamic> data) {
    try {
      final savedStudies = data['studies'];

      if (savedStudies is List) {
        saveStudies(
          savedStudies
              .map((e) => Map<String, dynamic>.from(e))
              .toList(),
        );
      }

      final savedTracker = data['tracker'];

      if (savedTracker is List) {
        saveTracker(
          savedTracker.map((e) => e.toString()).toSet(),
        );
      }

      return true;
    } catch (_) {
      return false;
    }
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
  void refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final studies = AppStorage.studies();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bitaniya Bible Study',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'Backup & Restore',
            icon: const Icon(Icons.backup_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const BackupPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 900,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Bitaniya Bible Study',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF74455A),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Read. Study. Understand. Apply.',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade700,
                      ),
                    ),

                    const SizedBox(height: 22),

                    _mainCard(
                      context,
                      icon: Icons.today_outlined,
                      title: 'Daily Study',
                      subtitle:
                          'Study one or several chapters today.',
                      color: const Color(0xFFFFEAF2),
                      page: const DailyStudyPage(),
                    ),

                    const SizedBox(height: 12),

                    _mainCard(
                      context,
                      icon: Icons.menu_book_outlined,
                      title: 'Chapter Study',
                      subtitle:
                          'Go deeper into one chapter using the complete study questions.',
                      color: Colors.white,
                      page: const ChapterStudyPage(),
                    ),

                    const SizedBox(height: 12),

                    _mainCard(
                      context,
                      icon: Icons.check_circle_outline,
                      title: 'New Testament Tracker',
                      subtitle:
                          'Track your progress chapter by chapter.',
                      color: const Color(0xFFEAF2FF),
                      page: const TrackerPage(),
                    ),

                    const SizedBox(height: 25),

                    const Text(
                      'Recent Daily Studies',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    if (studies.isEmpty)
                      _emptyCard()
                    else
                      ...studies.reversed.take(5).map(
                            (study) => _recentStudy(
                              context,
                              study,
                            ),
                          ),

                    const SizedBox(height: 20),

                    _mainCard(
                      context,
                      icon: Icons.backup_outlined,
                      title: 'Backup & Restore',
                      subtitle:
                          'Save all your studies and tracker progress.',
                      color: Colors.white,
                      page: const BackupPage(),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _mainCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required Widget page,
  }) {
    return Card(
      color: color,
      elevation: 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => page,
            ),
          );

          refresh();
        },
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              CircleAvatar(
                radius: 27,
                backgroundColor: Colors.white,
                child: Icon(
                  icon,
                  color: const Color(0xFF9A5C78),
                  size: 28,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(subtitle),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emptyCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.menu_book_outlined,
                size: 40,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 8),
              const Text(
                'No daily studies yet.',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Start your first study from Daily Study.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _recentStudy(
    BuildContext context,
    Map<String, dynamic> study,
  ) {
    final chapters = study['chapters'] as List? ?? [];

    return Card(
      child: ListTile(
        leading: const Icon(Icons.book_outlined),
        title: Text(
          study['date']?.toString() ?? 'Study',
        ),
        subtitle: Text(
          '${chapters.length} chapter'
          '${chapters.length == 1 ? '' : 's'}',
        ),
        trailing: const Icon(
          Icons.chevron_right,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DailyStudyPage(
                existingStudy: study,
              ),
            ),
          );
        },
      ),
    );
  }
}

// ============================================================
// DAILY STUDY
// ============================================================

class DailyStudyPage extends StatefulWidget {
  final Map<String, dynamic>? existingStudy;

  const DailyStudyPage({
    super.key,
    this.existingStudy,
  });

  @override
  State<DailyStudyPage> createState() =>
      _DailyStudyPageState();
}

class _DailyStudyPageState
    extends State<DailyStudyPage> {
  late DateTime date;

  final List<ChapterEntry> chapters = [];

  final overall = TextEditingController();
  final memoryVerse = TextEditingController();
  final prayer = TextEditingController();

  @override
  void initState() {
    super.initState();

    final existing = widget.existingStudy;

    date = existing == null
        ? DateTime.now()
        : DateTime.tryParse(
              existing['date']?.toString() ?? '',
            ) ??
            DateTime.now();

    if (existing != null) {
      final savedChapters =
          existing['chapters'] as List? ?? [];

      for (final item in savedChapters) {
        chapters.add(
          ChapterEntry.fromMap(
            Map<String, dynamic>.from(item),
          ),
        );
      }

      overall.text =
          existing['overall']?.toString() ?? '';

      memoryVerse.text =
          existing['memoryVerse']?.toString() ?? '';

      prayer.text =
          existing['prayer']?.toString() ?? '';
    }

    // Default to three chapters.
    if (chapters.isEmpty) {
      addChapter();
      addChapter();
      addChapter();
    }
  }

  @override
  void dispose() {
    for (final chapter in chapters) {
      chapter.dispose();
    }

    overall.dispose();
    memoryVerse.dispose();
    prayer.dispose();

    super.dispose();
  }

  void addChapter() {
    setState(() {
      chapters.add(ChapterEntry());
    });
  }

  void removeChapter(int index) {
    if (chapters.length == 1) return;

    final removed = chapters.removeAt(index);
    removed.dispose();

    setState(() {});
  }

  Future<void> chooseDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        date = picked;
      });
    }
  }

  void save() {
    final all = AppStorage.studies();

    final study = {
      'date': date.toIso8601String(),
      'chapters':
          chapters.map((e) => e.toMap()).toList(),
      'overall': overall.text,
      'memoryVerse': memoryVerse.text,
      'prayer': prayer.text,
    };

    final index = all.indexWhere(
      (item) => item['date'] == study['date'],
    );

    if (index >= 0) {
      all[index] = study;
    } else {
      all.add(study);
    }

    AppStorage.saveStudies(all);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Daily study saved.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Study'),
        actions: [
          IconButton(
            tooltip: 'Save',
            onPressed: save,
            icon: const Icon(Icons.save_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 850,
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Card(
                  color: const Color(0xFFFFF0F5),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Today\'s Bible Study',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          'Choose any number of chapters. '
                          'Three is only the suggested starting point.',
                        ),
                        const SizedBox(height: 15),

                        InkWell(
                          onTap: chooseDate,
                          child: InputDecorator(
                            decoration:
                                const InputDecoration(
                              labelText: 'Study Date',
                              prefixIcon:
                                  Icon(Icons.calendar_today),
                            ),
                            child: Text(
                              _dateText(date),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Chapters',
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    FilledButton.icon(
                      onPressed: addChapter,
                      icon: const Icon(Icons.add),
                      label: const Text('Add'),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                Text(
                  '${chapters.length} chapter'
                  '${chapters.length == 1 ? '' : 's'} today',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                  ),
                ),

                const SizedBox(height: 12),

                ...List.generate(
                  chapters.length,
                  (index) => _chapterCard(index),
                ),

                const SizedBox(height: 15),

                _simpleSection(
                  title: 'Overall Takeaway',
                  icon: Icons.lightbulb_outline,
                  controller: overall,
                  hint:
                      'What is the biggest thing you learned today?',
                  lines: 5,
                ),

                _simpleSection(
                  title: 'Memory Verse',
                  icon: Icons.bookmark_outline,
                  controller: memoryVerse,
                  hint:
                      'Write a verse you want to remember.',
                  lines: 3,
                ),

                _simpleSection(
                  title: 'Prayer',
                  icon: Icons.favorite_border,
                  controller: prayer,
                  hint:
                      'Respond to what you learned in prayer.',
                  lines: 5,
                ),

                const SizedBox(height: 15),

                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: save,
                    icon: const Icon(Icons.save),
                    label: const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 14,
                      ),
                      child: Text(
                        'SAVE DAILY STUDY',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _chapterCard(int index) {
    final chapter = chapters[index];

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 17,
                  child: Text('${index + 1}'),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Chapter ${index + 1}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: chapters.length > 1
                      ? () => removeChapter(index)
                      : null,
                  icon: const Icon(
                    Icons.delete_outline,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            _field(
              chapter.reference,
              'Book / Chapter',
              'Example: Romans 8',
              1,
            ),

            const SizedBox(height: 10),

            _field(
              chapter.summary,
              'What is happening?',
              'Briefly summarize the chapter.',
              4,
            ),

            const SizedBox(height: 10),

            _field(
              chapter.noticed,
              'What stood out to me?',
              'Important details, repeated ideas, commands, promises...',
              4,
            ),

            const SizedBox(height: 10),

            _field(
              chapter.keyVerse,
              'Key Verse',
              'Verse or reference that stood out.',
              3,
            ),

            const SizedBox(height: 10),

            _field(
              chapter.application,
              'How can I apply this?',
              'How should this change my thinking or actions?',
              4,
            ),

            const SizedBox(height: 8),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ChapterStudyPage(
                        initialReference:
                            chapter.reference.text,
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.open_in_new,
                  size: 18,
                ),
                label: const Text(
                  'Open detailed Chapter Study',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label,
    String hint,
    int lines,
  ) {
    return TextField(
      controller: controller,
      maxLines: lines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        alignLabelWithHint: true,
      ),
    );
  }

  Widget _simpleSection({
    required String title,
    required IconData icon,
    required TextEditingController controller,
    required String hint,
    required int lines,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controller,
              maxLines: lines,
              decoration: InputDecoration(
                hintText: hint,
                alignLabelWithHint: true,
                border: InputBorder.none,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _dateText(DateTime d) {
    return '${d.year}-'
        '${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')}';
  }
}

// ============================================================
// CHAPTER ENTRY
// ============================================================

class ChapterEntry {
  final reference = TextEditingController();
  final summary = TextEditingController();
  final noticed = TextEditingController();
  final keyVerse = TextEditingController();
  final application = TextEditingController();

  ChapterEntry();

  ChapterEntry.fromMap(Map<String, dynamic> map) {
    reference.text =
        map['reference']?.toString() ?? '';
    summary.text =
        map['summary']?.toString() ?? '';
    noticed.text =
        map['noticed']?.toString() ?? '';
    keyVerse.text =
        map['keyVerse']?.toString() ?? '';
    application.text =
        map['application']?.toString() ?? '';
  }

  Map<String, dynamic> toMap() {
    return {
      'reference': reference.text,
      'summary': summary.text,
      'noticed': noticed.text,
      'keyVerse': keyVerse.text,
      'application': application.text,
    };
  }

  void dispose() {
    reference.dispose();
    summary.dispose();
    noticed.dispose();
    keyVerse.dispose();
    application.dispose();
  }
}

// ============================================================
// CHAPTER STUDY
// ============================================================

class ChapterStudyPage extends StatefulWidget {
  final String? initialReference;

  const ChapterStudyPage({
    super.key,
    this.initialReference,
  });

  @override
  State<ChapterStudyPage> createState() =>
      _ChapterStudyPageState();
}

class _ChapterStudyPageState
    extends State<ChapterStudyPage> {
  final book = TextEditingController();
  final chapter = TextEditingController();
  final date = TextEditingController();
  final passage = TextEditingController();

  final happening = TextEditingController();
  final people = TextEditingController();
  final context = TextEditingController();

  final details = TextEditingController();
  final repeated = TextEditingController();
  final important = TextEditingController();

  final mainPoint = TextEditingController();
  final god = TextEditingController();
  final christ = TextEditingController();
  final peopleMeaning = TextEditingController();
  final difficult = TextEditingController();

  final command = TextEditingController();
  final example = TextEditingController();
  final promise = TextEditingController();
  final application = TextEditingController();

  final keyVerse = TextEditingController();
  final takeaway = TextEditingController();
  final furtherStudy = TextEditingController();
  final prayer = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.initialReference != null &&
        widget.initialReference!.isNotEmpty) {
      passage.text = widget.initialReference!;
    }
  }

  @override
  void dispose() {
    for (final c in [
      book,
      chapter,
      date,
      passage,
      happening,
      people,
      context,
      details,
      repeated,
      important,
      mainPoint,
      god,
      christ,
      peopleMeaning,
      difficult,
      command,
      example,
      promise,
      application,
      keyVerse,
      takeaway,
      furtherStudy,
      prayer,
    ]) {
      c.dispose();
    }

    super.dispose();
  }

  Widget field(
    TextEditingController controller,
    String label,
    String hint, {
    int lines = 4,
  }) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 13,
      ),
      child: TextField(
        controller: controller,
        maxLines: lines,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          alignLabelWithHint: true,
        ),
      ),
    );
  }

  Widget section({
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Widget> children,
    bool initiallyExpanded = true,
  }) {
    return Card(
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      child: ExpansionTile(
        initiallyExpanded: initiallyExpanded,
        leading: CircleAvatar(
          backgroundColor:
              const Color(0xFFF4E8ED),
          child: Icon(
            icon,
            color: const Color(0xFF74455A),
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        subtitle: Text(subtitle),
        childrenPadding: const EdgeInsets.fromLTRB(
          16,
          0,
          16,
          10,
        ),
        children: children,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chapter Study',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 850,
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  '📖 CHAPTER STUDY',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF74455A),
                  ),
                ),

                const SizedBox(height: 5),

                const Text(
                  'Observe → Understand → Apply → Remember',
                ),

                const SizedBox(height: 18),

                // ------------------------------------------------
                // INFORMATION
                // ------------------------------------------------

                section(
                  title: 'Chapter Information',
                  subtitle:
                      'Start with the basic information.',
                  icon: Icons.menu_book_outlined,
                  children: [
                    field(
                      book,
                      'Book',
                      'Example: Romans',
                      lines: 1,
                    ),
                    field(
                      chapter,
                      'Chapter',
                      'Example: 8',
                      lines: 1,
                    ),
                    field(
                      date,
                      'Date',
                      'When did you study it?',
                      lines: 1,
                    ),
                    field(
                      passage,
                      'Passage',
                      'Optional verses or section.',
                      lines: 1,
                    ),
                  ],
                ),

                // ------------------------------------------------
                // WHAT IS HAPPENING
                // ------------------------------------------------

                section(
                  title: '1. What Is Happening?',
                  subtitle:
                      'Understand the chapter in its context.',
                  icon: Icons.visibility_outlined,
                  children: [
                    field(
                      happening,
                      'What is the main story, argument, or message?',
                      'Summarize what is happening.',
                      lines: 5,
                    ),
                    field(
                      people,
                      'Who are the important people?',
                      'Who speaks, acts, teaches, or responds?',
                      lines: 4,
                    ),
                    field(
                      context,
                      'What is happening before and after this chapter?',
                      'Think about the surrounding context.',
                      lines: 4,
                    ),
                  ],
                ),

                // ------------------------------------------------
                // WHAT DOES TEXT SAY
                // ------------------------------------------------

                section(
                  title: '2. What Does the Text Say?',
                  subtitle:
                      'Look carefully at the details.',
                  icon: Icons.search_outlined,
                  children: [
                    field(
                      details,
                      'What words, ideas, commands, promises, or warnings stand out?',
                      'Write down important observations.',
                      lines: 5,
                    ),
                    field(
                      repeated,
                      'What is repeated or emphasized?',
                      'Notice repeated words, ideas, or themes.',
                      lines: 4,
                    ),
                    field(
                      important,
                      'What important details might I otherwise overlook?',
                      'Slow down and look carefully.',
                      lines: 4,
                    ),
                  ],
                ),

                // ------------------------------------------------
                // WHAT DOES IT MEAN
                // ------------------------------------------------

                section(
                  title: '3. What Does It Mean?',
                  subtitle:
                      'Think about the meaning of the passage.',
                  icon: Icons.lightbulb_outline,
                  children: [
                    field(
                      mainPoint,
                      'What is the main point the author is making?',
                      'What is the central message?',
                      lines: 5,
                    ),
                    field(
                      god,
                      'What does this teach about God?',
                      'His character, works, promises, holiness, etc.',
                      lines: 4,
                    ),
                    field(
                      christ,
                      'What does this teach about Christ?',
                      'His identity, work, words, example, etc.',
                      lines: 4,
                    ),
                    field(
                      peopleMeaning,
                      'What does this teach about people?',
                      'Human nature, sin, faith, obedience, relationships, etc.',
                      lines: 4,
                    ),
                    field(
                      difficult,
                      'Is there anything difficult or confusing to investigate?',
                      'Write questions instead of guessing the answer.',
                      lines: 4,
                    ),
                  ],
                ),

                // ------------------------------------------------
                // APPLY
                // ------------------------------------------------

                section(
                  title: '4. What Should I Do With It?',
                  subtitle:
                      'Turn understanding into action.',
                  icon: Icons.directions_outlined,
                  children: [
                    field(
                      command,
                      'Is there a command I should obey?',
                      'What does the passage tell me to do?',
                      lines: 4,
                    ),
                    field(
                      example,
                      'Is there an example I should follow or avoid?',
                      'Consider both positive and negative examples.',
                      lines: 4,
                    ),
                    field(
                      promise,
                      'Is there a promise or truth I should trust?',
                      'What should I believe or remember?',
                      lines: 4,
                    ),
                    field(
                      application,
                      'How should this change the way I think or live?',
                      'Give yourself a specific application.',
                      lines: 5,
                    ),
                  ],
                ),

                // ------------------------------------------------
                // REMEMBER
                // ------------------------------------------------

                section(
                  title: '5. Remember',
                  subtitle:
                      'Keep the most important things.',
                  icon: Icons.bookmark_outline,
                  children: [
                    field(
                      keyVerse,
                      'Key Verse',
                      'Verse or passage you want to remember.',
                      lines: 3,
                    ),
                    field(
                      takeaway,
                      'Biggest Takeaway',
                      'If you could remember one thing, what would it be?',
                      lines: 4,
                    ),
                    field(
                      furtherStudy,
                      'Questions for Further Study',
                      'Things you want to investigate later.',
                      lines: 4,
                    ),
                  ],
                ),

                // ------------------------------------------------
                // RESPONSE
                // ------------------------------------------------

                section(
                  title: '6. Personal Response',
                  subtitle:
                      'Respond to what you learned.',
                  icon: Icons.favorite_border,
                  children: [
                    field(
                      prayer,
                      'Prayer',
                      'Talk to God about what you learned.',
                      lines: 6,
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                const Card(
                  color: Color(0xFFFFF1F5),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Not every question needs an answer for every chapter. '
                            'Skip anything that does not apply and focus on what the text actually says.',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
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

class _TrackerPageState
    extends State<TrackerPage> {
  final Map<String, int> books = {
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

  late Set<String> completed;

  @override
  void initState() {
    super.initState();
    completed = AppStorage.tracker();
  }

  int get total =>
      books.values.fold(
        0,
        (sum, chapters) => sum + chapters,
      );

  double get progress =>
      total == 0 ? 0 : completed.length / total;

  void toggle(
    String book,
    int chapter,
  ) {
    final key = '$book|$chapter';

    setState(() {
      if (completed.contains(key)) {
        completed.remove(key);
      } else {
        completed.add(key);
      }
    });

    AppStorage.saveTracker(completed);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'New Testament Tracker',
        ),
        actions: [
          IconButton(
            tooltip: 'Reset',
            icon: const Icon(
              Icons.refresh,
            ),
            onPressed: reset,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          Card(
            color: const Color(0xFFEAF2FF),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  const Text(
                    'NEW TESTAMENT PROGRESS',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 14),
                  LinearProgressIndicator(
                    value: progress,
                    minHeight: 10,
                    borderRadius:
                        BorderRadius.circular(10),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${completed.length} / $total chapters '
                    '(${(progress * 100).toStringAsFixed(1)}%)',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          ...books.entries.map(
            (entry) => bookCard(
              entry.key,
              entry.value,
            ),
          ),
        ],
      ),
    );
  }

  Widget bookCard(
    String book,
    int chapterCount,
  ) {
    final finished = List.generate(
      chapterCount,
      (i) => i + 1,
    ).where(
      (chapter) =>
          completed.contains('$book|$chapter'),
    ).length;

    return Card(
      margin: const EdgeInsets.only(
        bottom: 10,
      ),
      child: ExpansionTile(
        title: Text(
          book,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '$finished / $chapterCount completed',
        ),
        childrenPadding:
            const EdgeInsets.all(12),
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(
              chapterCount,
              (i) {
                final chapter = i + 1;
                final done = completed.contains(
                  '$book|$chapter',
                );

                return InkWell(
                  onTap: () =>
                      toggle(book, chapter),
                  borderRadius:
                      BorderRadius.circular(10),
                  child: Container(
                    width: 48,
                    height: 48,
                    alignment:
                        Alignment.center,
                    decoration: BoxDecoration(
                      color: done
                          ? Colors.green.shade100
                          : Colors.grey.shade100,
                      borderRadius:
                          BorderRadius.circular(
                        10,
                      ),
                      border: Border.all(
                        color: done
                            ? Colors.green
                            : Colors.grey.shade400,
                      ),
                    ),
                    child: done
                        ? const Icon(
                            Icons.check,
                            color: Colors.green,
                          )
                        : Text('$chapter'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void reset() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          'Reset tracker?',
        ),
        content: const Text(
          'All completed chapters will be unmarked.',
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              setState(() {
                completed.clear();
              });

              AppStorage.saveTracker(
                completed,
              );

              Navigator.pop(context);
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// BACKUP & RESTORE
// ============================================================

class BackupPage extends StatefulWidget {
  const BackupPage({super.key});

  @override
  State<BackupPage> createState() =>
      _BackupPageState();
}

class _BackupPageState
    extends State<BackupPage> {
  void downloadBackup() {
    final data = AppStorage.backup();

    final json = const JsonEncoder
        .withIndent('  ')
        .convert(data);

    final blob = html.Blob(
      [json],
      'application/json',
    );

    final url =
        html.Url.createObjectUrlFromBlob(
      blob,
    );

    final anchor =
        html.AnchorElement(href: url)
          ..setAttribute(
            'download',
            'bitaniya_bible_study_backup.json',
          )
          ..click();

    html.Url.revokeObjectUrl(url);

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          'Backup downloaded.',
        ),
      ),
    );
  }

  void restoreBackup() {
    final input =
        html.FileUploadInputElement();

    input.accept = '.json,application/json';
    input.click();

    input.onChange.listen((event) {
      final files = input.files;

      if (files == null ||
          files.isEmpty) {
        return;
      }

      final reader = html.FileReader();

      reader.readAsText(files.first);

      reader.onLoadEnd.listen((event) {
        try {
          final result = reader.result;

          if (result is! String) {
            throw Exception();
          }

          final decoded =
              jsonDecode(result);

          if (decoded is! Map) {
            throw Exception();
          }

          final success =
              AppStorage.restore(
            Map<String, dynamic>.from(
              decoded,
            ),
          );

          if (!mounted) return;

          ScaffoldMessenger.of(context)
              .showSnackBar(
            SnackBar(
              content: Text(
                success
                    ? 'Backup restored successfully. '
                        'Return to the home page to see your data.'
                    : 'Could not restore the backup.',
              ),
            ),
          );
        } catch (_) {
          if (!mounted) return;

          ScaffoldMessenger.of(context)
              .showSnackBar(
            const SnackBar(
              content: Text(
                'This backup file could not be read.',
              ),
            ),
          );
        }
      });
    });
  }

  void deleteEverything() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          'Delete everything?',
        ),
        content: const Text(
          'This removes all daily studies and tracker progress '
          'from this browser. Make a backup first if you need it.',
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style:
                FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              html.window.localStorage
                  .remove(
                AppStorage.studiesKey,
              );

              html.window.localStorage
                  .remove(
                AppStorage.trackerKey,
              );

              Navigator.pop(context);

              setState(() {});

              ScaffoldMessenger.of(context)
                  .showSnackBar(
                const SnackBar(
                  content: Text(
                    'All local data deleted.',
                  ),
                ),
              );
            },
            child: const Text(
              'Delete',
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final studies =
        AppStorage.studies();

    final tracker =
        AppStorage.tracker();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Backup & Restore',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Backup & Restore',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Your studies are saved in this browser. '
            'Use Backup to create a file you can keep safely '
            'or move to another device.',
          ),

          const SizedBox(height: 20),

          Card(
            child: ListTile(
              leading: const Icon(
                Icons.today,
              ),
              title: const Text(
                'Daily Studies',
              ),
              subtitle: Text(
                '${studies.length} saved',
              ),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(
                Icons.check_circle_outline,
              ),
              title: const Text(
                'Tracker Progress',
              ),
              subtitle: Text(
                '${tracker.length} chapters completed',
              ),
            ),
          ),

          const SizedBox(height: 20),

          FilledButton.icon(
            onPressed: downloadBackup,
            icon: const Icon(
              Icons.download,
            ),
            label: const Padding(
              padding: EdgeInsets.all(14),
              child: Text(
                'DOWNLOAD BACKUP',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          OutlinedButton.icon(
            onPressed: restoreBackup,
            icon: const Icon(
              Icons.upload,
            ),
            label: const Padding(
              padding: EdgeInsets.all(14),
              child: Text(
                'RESTORE BACKUP',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),

          const Divider(),

          const SizedBox(height: 20),

          OutlinedButton.icon(
            style:
                OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            onPressed: deleteEverything,
            icon: const Icon(
              Icons.delete_forever,
            ),
            label: const Text(
              'DELETE ALL LOCAL DATA',
            ),
          ),

          const SizedBox(height: 15),

          Text(
            'Important: your data is stored locally in the browser. '
            'Make regular backups so you do not lose your studies '
            'if browser storage is cleared.',
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
