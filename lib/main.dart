import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const EverydayBibleStudyApp());
}

class EverydayBibleStudyApp extends StatelessWidget {
  const EverydayBibleStudyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Everyday Bible Study',
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
      home: const BibleStudyHomePage(),
    );
  }
}

class StudyEntry {
  final String id;
  String date;
  String book;
  String chapter;
  String passage;
  String says;
  String learned;
  String aboutGod;
  String aboutChrist;
  String aboutHumans;
  String response;
  String verse;
  String prayer;

  StudyEntry({
    required this.id,
    required this.date,
    this.book = '',
    this.chapter = '',
    this.passage = '',
    this.says = '',
    this.learned = '',
    this.aboutGod = '',
    this.aboutChrist = '',
    this.aboutHumans = '',
    this.response = '',
    this.verse = '',
    this.prayer = '',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date,
        'book': book,
        'chapter': chapter,
        'passage': passage,
        'says': says,
        'learned': learned,
        'aboutGod': aboutGod,
        'aboutChrist': aboutChrist,
        'aboutHumans': aboutHumans,
        'response': response,
        'verse': verse,
        'prayer': prayer,
      };

  factory StudyEntry.fromJson(Map<String, dynamic> j) => StudyEntry(
        id: j['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
        date: j['date'] ?? '',
        book: j['book'] ?? '',
        chapter: j['chapter'] ?? '',
        passage: j['passage'] ?? '',
        says: j['says'] ?? '',
        learned: j['learned'] ?? '',
        aboutGod: j['aboutGod'] ?? '',
        aboutChrist: j['aboutChrist'] ?? '',
        aboutHumans: j['aboutHumans'] ?? '',
        response: j['response'] ?? '',
        verse: j['verse'] ?? '',
        prayer: j['prayer'] ?? '',
      );
}

class StudyStorage {
  static const key = 'everyday_bible_studies';

  static Future<List<StudyEntry>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(key);
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List;
      return list
          .map((e) => StudyEntry.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> save(List<StudyEntry> studies) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      key,
      jsonEncode(studies.map((e) => e.toJson()).toList()),
    );
  }
}

class BibleStudyHomePage extends StatefulWidget {
  const BibleStudyHomePage({super.key});

  @override
  State<BibleStudyHomePage> createState() => _BibleStudyHomePageState();
}

class _BibleStudyHomePageState extends State<BibleStudyHomePage> {
  List<StudyEntry> studies = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await StudyStorage.load();
    data.sort((a, b) => b.date.compareTo(a.date));
    if (mounted) {
      setState(() {
        studies = data;
        loading = false;
      });
    }
  }

  Future<void> _newStudy() async {
    final now = DateTime.now();
    final entry = StudyEntry(
      id: now.microsecondsSinceEpoch.toString(),
      date: _formatDate(now),
    );
    final result = await Navigator.push<StudyEntry>(
      context,
      MaterialPageRoute(builder: (_) => DailyStudyPage(entry: entry)),
    );
    if (result != null) {
      final index = studies.indexWhere((e) => e.id == result.id);
      setState(() {
        if (index >= 0) {
          studies[index] = result;
        } else {
          studies.add(result);
        }
        studies.sort((a, b) => b.date.compareTo(a.date));
      });
      await StudyStorage.save(studies);
    }
  }

  Future<void> _openStudy(StudyEntry entry) async {
    final result = await Navigator.push<StudyEntry>(
      context,
      MaterialPageRoute(
        builder: (_) => DailyStudyPage(entry: entry),
      ),
    );
    if (result != null) {
      final index = studies.indexWhere((e) => e.id == result.id);
      if (index >= 0) {
        setState(() => studies[index] = result);
        studies.sort((a, b) => b.date.compareTo(a.date));
        await StudyStorage.save(studies);
      }
    }
  }

  Future<void> _deleteStudy(StudyEntry entry) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete study?'),
        content: Text('Delete the study from ${entry.date}?'),
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
    if (yes == true) {
      setState(() => studies.removeWhere((e) => e.id == entry.id));
      await StudyStorage.save(studies);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Everyday Bible Study'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.brown.shade800,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _hero(),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: _newStudy,
                  icon: const Icon(Icons.add),
                  label: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Text('NEW DAILY STUDY',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'MY DAILY STUDIES',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                ),
                const SizedBox(height: 8),
                if (studies.isEmpty)
                  _emptyStudies()
                else
                  ...studies.map(
                    (study) => Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.pink.shade50,
                          child: Icon(Icons.menu_book,
                              color: Colors.pink.shade700),
                        ),
                        title: Text(
                          study.book.isEmpty
                              ? 'Untitled Bible Study'
                              : '${study.book}${study.chapter.isEmpty ? '' : ' ${study.chapter}'}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          '${study.date}\n${study.verse.isEmpty ? 'Tap to open this study' : study.verse}',
                          maxLines: 2,
                        ),
                        isThreeLine: true,
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'open') _openStudy(study);
                            if (value == 'delete') _deleteStudy(study);
                          },
                          itemBuilder: (_) => const [
                            PopupMenuItem(
                                value: 'open', child: Text('Open / Edit')),
                            PopupMenuItem(
                                value: 'delete', child: Text('Delete')),
                          ],
                        ),
                        onTap: () => _openStudy(study),
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
                const Text(
                  'STUDY TOOLS',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                ),
                const SizedBox(height: 8),
                _toolCard(
                  context,
                  'Bible Character Study',
                  'Learn from a person in Scripture.',
                  Icons.person_outline,
                  const BibleCharacterStudyPage(),
                ),
                _toolCard(
                  context,
                  'Chapter Study',
                  'Summary, characters, concepts and challenges.',
                  Icons.menu_book,
                  const ChapterStudyPage(),
                ),
                _toolCard(
                  context,
                  'Quiet Time Notes',
                  'What Scripture says about God, Christ and humans.',
                  Icons.spa_outlined,
                  const QuietTimeNotesPage(),
                ),
                _toolCard(
                  context,
                  'Reflection Journal',
                  'Questions, application, memory verse and prayer.',
                  Icons.edit_note,
                  const ReflectionPage(),
                ),
                _toolCard(
                  context,
                  'New Testament Reading Tracker',
                  'Track chapter-by-chapter progress.',
                  Icons.check_circle_outline,
                  const NewTestamentTrackerPage(),
                ),
              ],
            ),
    );
  }

  Widget _hero() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.pink.shade50, Colors.orange.shade50],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.pink.shade100),
      ),
      child: const Column(
        children: [
          Text('📖', style: TextStyle(fontSize: 40)),
          SizedBox(height: 6),
          Text(
            'EVERYDAY BIBLE STUDY',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              color: Colors.brown,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Create a study page for every day and keep your Bible journey in one place.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _emptyStudies() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: const Column(
        children: [
          Icon(Icons.calendar_month_outlined, size: 48, color: Colors.grey),
          SizedBox(height: 8),
          Text(
            'No daily studies yet.',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            'Tap “New Daily Study” to create your first page.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _toolCard(BuildContext context, String title, String subtitle,
      IconData icon, Widget page) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Colors.brown.shade500),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 15),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => page),
        ),
      ),
    );
  }
}

class DailyStudyPage extends StatefulWidget {
  final StudyEntry entry;
  const DailyStudyPage({super.key, required this.entry});

  @override
  State<DailyStudyPage> createState() => _DailyStudyPageState();
}

class _DailyStudyPageState extends State<DailyStudyPage> {
  late final TextEditingController date;
  late final TextEditingController book;
  late final TextEditingController chapter;
  late final TextEditingController passage;
  late final TextEditingController says;
  late final TextEditingController learned;
  late final TextEditingController aboutGod;
  late final TextEditingController aboutChrist;
  late final TextEditingController aboutHumans;
  late final TextEditingController response;
  late final TextEditingController verse;
  late final TextEditingController prayer;

  @override
  void initState() {
    super.initState();
    final e = widget.entry;
    date = TextEditingController(text: e.date);
    book = TextEditingController(text: e.book);
    chapter = TextEditingController(text: e.chapter);
    passage = TextEditingController(text: e.passage);
    says = TextEditingController(text: e.says);
    learned = TextEditingController(text: e.learned);
    aboutGod = TextEditingController(text: e.aboutGod);
    aboutChrist = TextEditingController(text: e.aboutChrist);
    aboutHumans = TextEditingController(text: e.aboutHumans);
    response = TextEditingController(text: e.response);
    verse = TextEditingController(text: e.verse);
    prayer = TextEditingController(text: e.prayer);
  }

  @override
  void dispose() {
    for (final c in [
      date,
      book,
      chapter,
      passage,
      says,
      learned,
      aboutGod,
      aboutChrist,
      aboutHumans,
      response,
      verse,
      prayer
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickDate() async {
    DateTime initial = DateTime.tryParse(date.text) ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      date.text = _formatDate(picked);
      setState(() {});
    }
  }

  void _save() {
    final e = StudyEntry(
      id: widget.entry.id,
      date: date.text.trim().isEmpty ? _formatDate(DateTime.now()) : date.text,
      book: book.text.trim(),
      chapter: chapter.text.trim(),
      passage: passage.text.trim(),
      says: says.text.trim(),
      learned: learned.text.trim(),
      aboutGod: aboutGod.text.trim(),
      aboutChrist: aboutChrist.text.trim(),
      aboutHumans: aboutHumans.text.trim(),
      response: response.text.trim(),
      verse: verse.text.trim(),
      prayer: prayer.text.trim(),
    );
    Navigator.pop(context, e);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Bible Study'),
        backgroundColor: Colors.pink.shade50,
        foregroundColor: Colors.brown.shade800,
        actions: [
          IconButton(
            tooltip: 'Save study',
            onPressed: _save,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SectionTitle('📅 DAILY BIBLE STUDY'),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: date,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'DATE',
                    prefixIcon: Icon(Icons.calendar_today),
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
                  controller: book,
                  decoration: const InputDecoration(labelText: 'BOOK'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: chapter,
                  decoration: const InputDecoration(labelText: 'CHAPTER'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          StudyBox(
            title: '📖 TODAY’S PASSAGE',
            child: TextField(
              controller: passage,
              maxLines: 4,
              decoration:
                  const InputDecoration(hintText: 'Write the passage or reference...'),
            ),
          ),
          StudyBox(
            title: '🔎 WHAT DOES THE PASSAGE SAY?',
            child: TextField(
              controller: says,
              maxLines: 5,
              decoration:
                  const InputDecoration(hintText: 'Summarize what you read...'),
            ),
          ),
          StudyBox(
            title: '💡 WHAT DID I LEARN?',
            child: TextField(
              controller: learned,
              maxLines: 5,
              decoration:
                  const InputDecoration(hintText: 'Write what you discovered...'),
            ),
          ),
          _twoBoxes(
            StudyBox(
              title: '🙏 WHAT DOES THIS SAY ABOUT GOD?',
              child: TextField(controller: aboutGod, maxLines: 5),
            ),
            StudyBox(
              title: '✝️ WHAT DOES THIS SAY ABOUT CHRIST?',
              child: TextField(controller: aboutChrist, maxLines: 5),
            ),
          ),
          _twoBoxes(
            StudyBox(
              title: '👤 WHAT DOES THIS SAY ABOUT HUMANS?',
              child: TextField(controller: aboutHumans, maxLines: 5),
            ),
            StudyBox(
              title: '❤️ HOW SHOULD I RESPOND?',
              child: TextField(controller: response, maxLines: 5),
            ),
          ),
          StudyBox(
            title: '⭐ VERSE THAT STOOD OUT',
            child: TextField(
              controller: verse,
              maxLines: 3,
              decoration:
                  const InputDecoration(hintText: 'Reference and/or verse...'),
            ),
          ),
          StudyBox(
            title: '🙏 PRAYER',
            child: TextField(
              controller: prayer,
              maxLines: 6,
              decoration:
                  const InputDecoration(hintText: 'Write your prayer...'),
            ),
          ),
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.save),
            label: const Padding(
              padding: EdgeInsets.all(12),
              child: Text('SAVE DAILY STUDY'),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _twoBoxes(Widget a, Widget b) => LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 700) {
            return Column(children: [a, b]);
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: a),
              const SizedBox(width: 12),
              Expanded(child: b),
            ],
          );
        },
      );
}

class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.brown,
          ),
        ),
      );
}

class StudyBox extends StatelessWidget {
  final String title;
  final Widget child;
  const StudyBox({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.pink.shade100),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            child,
          ],
        ),
      );
}

class BibleCharacterStudyPage extends StatelessWidget {
  const BibleCharacterStudyPage({super.key});

  @override
  Widget build(BuildContext context) => SimpleStudyPage(
        title: 'Bible Character Study',
        intro: 'Learning from their story. Growing in our faith.',
        sections: const [
          'CHARACTER',
          'KNOWN FOR',
          'BOOK(S)',
          'CHAPTER(S)',
          'TELL THEIR STORY IN YOUR OWN WORDS',
          'TRAITS — What words describe this person?',
          'KEY VERSE(S)',
          'WHAT CAN WE LEARN?',
          'HOW CAN WE APPLY THIS TODAY?',
          'CHALLENGES — Struggles, mistakes, or hard moments',
          'HOW GOD USED THEM',
          'BIGGEST TAKEAWAY',
          'A PRAYER',
        ],
        pink: true,
      );
}

class ChapterStudyPage extends StatelessWidget {
  const ChapterStudyPage({super.key});

  @override
  Widget build(BuildContext context) => SimpleStudyPage(
        title: 'Chapter Study',
        intro: 'Passage summary, key concepts, and challenges.',
        sections: const [
          'DATE',
          'PASSAGE',
          'AUTHOR',
          'AUDIENCE',
          'SUMMARY',
          'CHARACTERS',
          'KEY CONCEPTS',
          'SOMETHING THAT CHALLENGED ME',
          'A VERSE THAT STOOD OUT',
        ],
      );
}

class QuietTimeNotesPage extends StatelessWidget {
  const QuietTimeNotesPage({super.key});

  @override
  Widget build(BuildContext context) => SimpleStudyPage(
        title: 'Quiet Time Notes',
        intro: 'Slow down, notice, remember, and respond.',
        sections: const [
          'DATE',
          'TODAY’S PASSAGE',
          '3 THINGS I NOTICED',
          '3 THINGS TO REMEMBER',
          'WHAT DOES THIS SAY ABOUT GOD?',
          'WHAT DOES THIS SAY ABOUT CHRIST?',
          'WHAT DOES THIS SAY ABOUT HUMANS?',
          'HOW SHOULD WE RESPOND?',
        ],
      );
}

class ReflectionPage extends StatelessWidget {
  const ReflectionPage({super.key});

  @override
  Widget build(BuildContext context) => SimpleStudyPage(
        title: 'Reflection Journal',
        intro: 'Questions, life application, memory verse, and prayer.',
        sections: const [
          'DATE',
          'BOOK',
          'CHAPTER',
          'WHAT QUESTIONS DO I HAVE?',
          'HOW DOES THIS APPLY TO MY LIFE?',
          'WHAT DO I NEED TO STUDY FURTHER?',
          'WHAT IS THIS CHAPTER TEACHING ME?',
          'MEMORY VERSE',
          'PRAYER',
        ],
      );
}

class SimpleStudyPage extends StatelessWidget {
  final String title;
  final String intro;
  final List<String> sections;
  final bool pink;

  const SimpleStudyPage({
    super.key,
    required this.title,
    required this.intro,
    required this.sections,
    this.pink = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: pink ? Colors.pink.shade50 : Colors.white,
        foregroundColor: Colors.brown.shade800,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(intro, style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 16),
          ...sections.map(
            (s) => Container(
              margin: const EdgeInsets.symmetric(vertical: 7),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: pink ? Colors.pink.shade50.withOpacity(.35) : Colors.white,
                border: Border.all(
                  color: pink ? Colors.pink.shade200 : Colors.grey.shade400,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                maxLines: _large(s) ? 5 : 2,
                decoration: InputDecoration(
                  labelText: s,
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  bool _large(String s) =>
      s.contains('STORY') ||
      s.contains('SUMMARY') ||
      s.contains('TEACHING') ||
      s.contains('PRAYER') ||
      s.contains('APPLY') ||
      s.contains('CHALLENGED');
}

class NewTestamentTrackerPage extends StatefulWidget {
  const NewTestamentTrackerPage({super.key});

  @override
  State<NewTestamentTrackerPage> createState() =>
      _NewTestamentTrackerPageState();
}

class _NewTestamentTrackerPageState extends State<NewTestamentTrackerPage> {
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

  int get total =>
      books.values.fold<int>(0, (sum, chapters) => sum + chapters);

  int get completed =>
      read.values.fold<int>(0, (sum, chapters) => sum + chapters.length);

  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : completed / total;
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Testament Reading Tracker'),
        backgroundColor: Colors.blue.shade100,
        foregroundColor: Colors.blue.shade900,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'NEW TESTAMENT BIBLE READING TRACKER',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(value: progress),
          const SizedBox(height: 8),
          Text('$completed of $total chapters completed',
              textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ...books.entries.map((entry) {
            final set = read.putIfAbsent(entry.key, () => <int>{});
            return Card(
              child: ExpansionTile(
                title: Text(entry.key,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('${set.length}/${entry.value} chapters'),
                children: [
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: List.generate(entry.value, (i) {
                      final chapter = i + 1;
                      final checked = set.contains(chapter);
                      return FilterChip(
                        label: Text('$chapter'),
                        selected: checked,
                        onSelected: (value) {
                          setState(() {
                            if (value) {
                              set.add(chapter);
                            } else {
                              set.remove(chapter);
                            }
                          });
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

String _formatDate(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
