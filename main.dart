
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
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF5D4037),
          elevation: 1,
        ),
      ),
      home: const BibleStudyHub(),
    );
  }
}

class BibleStudyHub extends StatelessWidget {
  const BibleStudyHub({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Everyday Bible Study Journal')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const SizedBox(height: 10),
              const Icon(Icons.menu_book_rounded, size: 62, color: Colors.pink),
              const SizedBox(height: 12),
              const Text(
                'Everyday Bible Study',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xFF5D4037)),
              ),
              const SizedBox(height: 6),
              const Text(
                'Study. Reflect. Apply. Grow.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 30),
              _MenuCard(
                title: '1. Bible Character Study',
                subtitle: 'Learning from their story. Growing in our faith.',
                icon: Icons.person_outline,
                color: Colors.pink.shade50,
                borderColor: Colors.pink.shade200,
                destination: const BibleCharacterStudyPage(),
              ),
              _MenuCard(
                title: '2. Chapter Study',
                subtitle: 'Passage summary, key concepts, and challenges.',
                icon: Icons.menu_book,
                color: Colors.white,
                borderColor: Colors.brown.shade200,
                destination: const ChapterStudyPage(),
              ),
              _MenuCard(
                title: '3. Quiet Time Notes',
                subtitle: 'What this says about God, Christ, and humans.',
                icon: Icons.spa_outlined,
                color: Colors.white,
                borderColor: Colors.brown.shade200,
                destination: const QuietTimeNotesPage(),
              ),
              _MenuCard(
                title: '4. Reflection Journal',
                subtitle: 'Questions, life application, memory verse, and prayer.',
                icon: Icons.edit_note,
                color: Colors.white,
                borderColor: Colors.brown.shade200,
                destination: const ReflectionPage(),
              ),
              _MenuCard(
                title: '5. New Testament Reading Tracker',
                subtitle: 'Track your chapter-by-chapter reading progress.',
                icon: Icons.check_circle_outline,
                color: Colors.blue.shade50,
                borderColor: Colors.blue.shade200,
                destination: const NewTestamentTrackerPage(),
              ),
              const SizedBox(height: 25),
              const Text(
                'Your studies are saved in this browser.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black45, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final String title, subtitle;
  final IconData icon;
  final Color color, borderColor;
  final Widget destination;

  const _MenuCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.borderColor,
    required this.destination,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 7),
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: borderColor),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Icon(icon, size: 38, color: Colors.brown.shade400),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF5D4037))),
        subtitle: Padding(padding: const EdgeInsets.only(top: 6), child: Text(subtitle)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 17),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => destination)),
      ),
    );
  }
}

class StudyField extends StatelessWidget {
  final String label;
  final int maxLines;
  final TextEditingController controller;

  const StudyField({super.key, required this.label, required this.controller, this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        alignLabelWithHint: maxLines > 1,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}

class SaveButton extends StatelessWidget {
  final VoidCallback onPressed;
  const SaveButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.save),
        label: const Text('SAVE STUDY'),
      ),
    );
  }
}

Widget responsiveRow(Widget first, Widget second) {
  return LayoutBuilder(
    builder: (context, constraints) {
      if (constraints.maxWidth < 600) {
        return Column(children: [first, const SizedBox(height: 12), second]);
      }
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Expanded(child: first), const SizedBox(width: 12), Expanded(child: second)],
      );
    },
  );
}

class BibleCharacterStudyPage extends StatefulWidget {
  const BibleCharacterStudyPage({super.key});
  @override
  State<BibleCharacterStudyPage> createState() => _BibleCharacterStudyPageState();
}

class _BibleCharacterStudyPageState extends State<BibleCharacterStudyPage> {
  final fields = <String, TextEditingController>{
    'character': TextEditingController(),
    'knownFor': TextEditingController(),
    'books': TextEditingController(),
    'chapters': TextEditingController(),
    'story': TextEditingController(),
    'traits': TextEditingController(),
    'keyVerses': TextEditingController(),
    'lessons': TextEditingController(),
    'application': TextEditingController(),
    'challenges': TextEditingController(),
    'godUsed': TextEditingController(),
    'takeaway': TextEditingController(),
    'prayer': TextEditingController(),
  };

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    for (final entry in fields.entries) {
      entry.value.text = prefs.getString('character_${entry.key}') ?? '';
    }
    if (mounted) setState(() {});
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    for (final entry in fields.entries) {
      await prefs.setString('character_${entry.key}', entry.value.text);
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Character study saved.')));
    }
  }

  Widget box(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.pink.shade50.withOpacity(.5),
        border: Border.all(color: Colors.pink.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.pink)),
        const SizedBox(height: 12),
        ...children,
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bible Character Study'), backgroundColor: Colors.pink.shade50),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(18),
            child: Column(children: [
              const Text('✨ BIBLE CHARACTER STUDY ✨', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.pink)),
              const SizedBox(height: 5),
              const Text('Learning from their story. Growing in our faith.', style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)),
              const SizedBox(height: 20),
              responsiveRow(
                StudyField(label: 'CHARACTER', controller: fields['character']!),
                StudyField(label: 'KNOWN FOR', controller: fields['knownFor']!),
              ),
              const SizedBox(height: 15),
              box('1. THEIR STORY', [
                StudyField(label: 'Book(s)', controller: fields['books']!),
                const SizedBox(height: 10),
                StudyField(label: 'Chapter(s)', controller: fields['chapters']!),
                const SizedBox(height: 10),
                StudyField(label: 'Tell their story in your own words', controller: fields['story']!, maxLines: 5),
              ]),
              const SizedBox(height: 15),
              responsiveRow(
                box('2. TRAITS ⭐', [StudyField(label: 'What words describe this person?', controller: fields['traits']!, maxLines: 6)]),
                box('3. KEY VERSE(S)', [StudyField(label: 'Write verse(s) that stand out', controller: fields['keyVerses']!, maxLines: 6)]),
              ),
              const SizedBox(height: 15),
              box('4. WHAT CAN WE LEARN?', [
                StudyField(label: 'What can we learn from their life?', controller: fields['lessons']!, maxLines: 4),
                const SizedBox(height: 10),
                StudyField(label: 'How can we apply this to our life today?', controller: fields['application']!, maxLines: 4),
              ]),
              const SizedBox(height: 15),
              responsiveRow(
                box('5. CHALLENGES', [StudyField(label: 'Struggles, mistakes, or hard moments?', controller: fields['challenges']!, maxLines: 5)]),
                box('6. HOW GOD USED THEM', [StudyField(label: 'How did God work in their life?', controller: fields['godUsed']!, maxLines: 5)]),
              ),
              const SizedBox(height: 15),
              box('7. BIGGEST TAKEAWAY', [StudyField(label: 'What is your biggest takeaway?', controller: fields['takeaway']!, maxLines: 4)]),
              const SizedBox(height: 15),
              box('8. A PRAYER', [StudyField(label: 'Pray about what you learned', controller: fields['prayer']!, maxLines: 5)]),
              const SizedBox(height: 20),
              SaveButton(onPressed: _save),
            ]),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (final c in fields.values) {
      c.dispose();
    }
    super.dispose();
  }
}

class ChapterStudyPage extends StatefulWidget {
  const ChapterStudyPage({super.key});
  @override
  State<ChapterStudyPage> createState() => _ChapterStudyPageState();
}

class _ChapterStudyPageState extends State<ChapterStudyPage> {
  final fields = <String, TextEditingController>{
    'date': TextEditingController(),
    'passage': TextEditingController(),
    'author': TextEditingController(),
    'audience': TextEditingController(),
    'summary': TextEditingController(),
    'characters': TextEditingController(),
    'concepts': TextEditingController(),
    'challenge': TextEditingController(),
    'verse': TextEditingController(),
  };

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    for (final entry in fields.entries) {
      entry.value.text = prefs.getString('chapter_${entry.key}') ?? '';
    }
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    for (final entry in fields.entries) {
      await prefs.setString('chapter_${entry.key}', entry.value.text);
    }
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Chapter study saved.')));
  }

  Widget outline(String title, String key, {int lines = 3}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(border: Border.all(color: Colors.black54), color: Colors.white),
      child: StudyField(label: title, controller: fields[key]!, maxLines: lines),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chapter Study')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(18),
            child: Column(children: [
              const Text('CHAPTER STUDY', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w300)),
              const SizedBox(height: 20),
              responsiveRow(
                StudyField(label: 'Date', controller: fields['date']!),
                StudyField(label: 'Passage', controller: fields['passage']!),
              ),
              const SizedBox(height: 12),
              responsiveRow(
                StudyField(label: 'Author', controller: fields['author']!),
                StudyField(label: 'Audience', controller: fields['audience']!),
              ),
              const SizedBox(height: 18),
              outline('Summary', 'summary', lines: 6),
              const SizedBox(height: 12),
              responsiveRow(
                outline('Characters', 'characters', lines: 6),
                outline('Key concepts', 'concepts', lines: 6),
              ),
              const SizedBox(height: 12),
              outline('Something that challenged me', 'challenge', lines: 5),
              const SizedBox(height: 12),
              outline('A verse that stood out', 'verse', lines: 4),
              const SizedBox(height: 20),
              SaveButton(onPressed: _save),
            ]),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (final c in fields.values) c.dispose();
    super.dispose();
  }
}

class QuietTimeNotesPage extends StatefulWidget {
  const QuietTimeNotesPage({super.key});
  @override
  State<QuietTimeNotesPage> createState() => _QuietTimeNotesPageState();
}

class _QuietTimeNotesPageState extends State<QuietTimeNotesPage> {
  final fields = <String, TextEditingController>{
    'date': TextEditingController(),
    'passage': TextEditingController(),
    'noticed': TextEditingController(),
    'remember': TextEditingController(),
    'god': TextEditingController(),
    'christ': TextEditingController(),
    'humans': TextEditingController(),
    'response': TextEditingController(),
  };

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    for (final e in fields.entries) e.value.text = prefs.getString('quiet_${e.key}') ?? '';
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    for (final e in fields.entries) await prefs.setString('quiet_${e.key}', e.value.text);
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Quiet time notes saved.')));
  }

  Widget lined(String title, String key, {int lines = 4}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400), color: Colors.white),
      child: StudyField(label: title, controller: fields[key]!, maxLines: lines),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiet Time Notes')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(18),
            child: Column(children: [
              Row(children: [
                const Expanded(child: Text('QUIET TIME NOTES', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold))),
                SizedBox(width: 180, child: StudyField(label: 'DATE', controller: fields['date']!)),
              ]),
              const SizedBox(height: 15),
              lined("TODAY'S PASSAGE", 'passage', lines: 4),
              const SizedBox(height: 12),
              responsiveRow(lined('3 THINGS I NOTICED', 'noticed', lines: 5), lined('3 THINGS TO REMEMBER', 'remember', lines: 5)),
              const SizedBox(height: 12),
              responsiveRow(lined('WHAT DOES THIS SAY ABOUT GOD?', 'god', lines: 5), lined('WHAT DOES THIS SAY ABOUT CHRIST?', 'christ', lines: 5)),
              const SizedBox(height: 12),
              responsiveRow(lined('WHAT DOES THIS SAY ABOUT HUMANS?', 'humans', lines: 5), lined('HOW SHOULD WE RESPOND?', 'response', lines: 5)),
              const SizedBox(height: 20),
              SaveButton(onPressed: _save),
            ]),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (final c in fields.values) c.dispose();
    super.dispose();
  }
}

class ReflectionPage extends StatefulWidget {
  const ReflectionPage({super.key});
  @override
  State<ReflectionPage> createState() => _ReflectionPageState();
}

class _ReflectionPageState extends State<ReflectionPage> {
  final fields = <String, TextEditingController>{
    'date': TextEditingController(),
    'book': TextEditingController(),
    'chapter': TextEditingController(),
    'questions': TextEditingController(),
    'application': TextEditingController(),
    'furtherStudy': TextEditingController(),
    'teaching': TextEditingController(),
    'memoryVerse': TextEditingController(),
    'prayer': TextEditingController(),
  };

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    for (final e in fields.entries) e.value.text = prefs.getString('reflection_${e.key}') ?? '';
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    for (final e in fields.entries) await prefs.setString('reflection_${e.key}', e.value.text);
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reflection saved.')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reflection Journal')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(18),
            child: Column(children: [
              Row(children: [
                const Expanded(child: Text('Reflection', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w300))),
                SizedBox(width: 160, child: Column(children: [
                  StudyField(label: 'DATE', controller: fields['date']!),
                  const SizedBox(height: 7),
                  StudyField(label: 'BOOK', controller: fields['book']!),
                  const SizedBox(height: 7),
                  StudyField(label: 'CHAPTER', controller: fields['chapter']!),
                ])),
              ]),
              const Divider(thickness: 2),
              const SizedBox(height: 15),
              responsiveRow(
                Column(children: [
                  StudyField(label: 'WHAT QUESTIONS DO I HAVE?', controller: fields['questions']!, maxLines: 4),
                  const SizedBox(height: 12),
                  StudyField(label: 'HOW DOES THIS APPLY TO MY LIFE?', controller: fields['application']!, maxLines: 4),
                  const SizedBox(height: 12),
                  StudyField(label: 'WHAT DO I NEED TO STUDY FURTHER?', controller: fields['furtherStudy']!, maxLines: 4),
                ]),
                StudyField(label: 'WHAT IS THIS CHAPTER TEACHING ME?', controller: fields['teaching']!, maxLines: 13),
              ),
              const SizedBox(height: 15),
              StudyField(label: 'MEMORY VERSE', controller: fields['memoryVerse']!, maxLines: 3),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(12)),
                child: StudyField(label: 'PRAYER', controller: fields['prayer']!, maxLines: 6),
              ),
              const SizedBox(height: 20),
              SaveButton(onPressed: _save),
            ]),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (final c in fields.values) c.dispose();
    super.dispose();
  }
}

class NewTestamentTrackerPage extends StatefulWidget {
  const NewTestamentTrackerPage({super.key});
  @override
  State<NewTestamentTrackerPage> createState() => _NewTestamentTrackerPageState();
}

class _NewTestamentTrackerPageState extends State<NewTestamentTrackerPage> {
  final Map<String, int> ntBooks = {
    'Matthew': 28, 'Mark': 16, 'Luke': 24, 'John': 21, 'Acts': 28, 'Romans': 16,
    '1 Corinthians': 16, '2 Corinthians': 13, 'Galatians': 6, 'Ephesians': 6,
    'Philippians': 4, 'Colossians': 4, '1 Thessalonians': 5, '2 Thessalonians': 3,
    '1 Timothy': 6, '2 Timothy': 4, 'Titus': 3, 'Philemon': 1, 'Hebrews': 13,
    'James': 5, '1 Peter': 5, '2 Peter': 3, '1 John': 5, '2 John': 1,
    '3 John': 1, 'Jude': 1, 'Revelation': 22,
  };

  final Map<String, Set<int>> readChapters = {};

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('nt_read_chapters');
    if (saved == null) return;
    final Map<String, dynamic> data = jsonDecode(saved);
    for (final e in data.entries) {
      readChapters[e.key] = Set<int>.from((e.value as List).map((x) => x as int));
    }
    if (mounted) setState(() {});
  }

  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final data = <String, List<int>>{};
    for (final e in readChapters.entries) data[e.key] = e.value.toList()..sort();
    await prefs.setString('nt_read_chapters', jsonEncode(data));
  }

  int get totalChapters => ntBooks.values.fold(0, (a, b) => a + b);
  int get completedChapters => readChapters.values.fold(0, (a, b) => a + b.length);
  double get progress => totalChapters == 0 ? 0 : completedChapters / totalChapters;

  Future<void> toggle(String book, int chapter) async {
    setState(() {
      readChapters.putIfAbsent(book, () => <int>{});
      final set = readChapters[book]!;
      if (!set.add(chapter)) set.remove(chapter);
    });
    await _saveProgress();
  }

  Future<void> reset() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Reset reading progress?'),
        content: const Text('All New Testament chapter checkmarks will be removed.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('CANCEL')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('RESET')),
        ],
      ),
    );
    if (ok != true) return;
    setState(() => readChapters.clear());
    await _saveProgress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Testament Reading Tracker'),
        backgroundColor: Colors.blue.shade100,
        foregroundColor: Colors.blue.shade900,
        actions: [IconButton(onPressed: reset, icon: const Icon(Icons.restart_alt), tooltip: 'Reset progress')],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: ListView(
            padding: const EdgeInsets.all(18),
            children: [
              const Text('NEW TESTAMENT BIBLE READING TRACKER', textAlign: TextAlign.center, style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Colors.blue)),
              const SizedBox(height: 8),
              const Text(
                '"All Scripture is God-breathed and is useful for teaching, rebuking, correcting and training in righteousness..." — 2 Timothy 3:16–17',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      const Text('Overall Progress', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                      Text('$completedChapters / $totalChapters chapters', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ]),
                    const SizedBox(height: 10),
                    LinearProgressIndicator(value: progress, minHeight: 10),
                    const SizedBox(height: 8),
                    Text('${(progress * 100).toStringAsFixed(1)}% complete'),
                  ]),
                ),
              ),
              const SizedBox(height: 15),
              ...ntBooks.entries.map((entry) {
                final book = entry.key;
                final count = entry.value;
                final done = readChapters[book]?.length ?? 0;
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: ExpansionTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.shade100,
                      child: Text('$done', style: TextStyle(color: Colors.blue.shade900, fontWeight: FontWeight.bold)),
                    ),
                    title: Text(book, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('$done / $count chapters'),
                      const SizedBox(height: 4),
                      LinearProgressIndicator(value: done / count),
                    ]),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: List.generate(count, (i) {
                            final chapter = i + 1;
                            final selected = readChapters[book]?.contains(chapter) ?? false;
                            return FilterChip(
                              label: Text('$chapter'),
                              selected: selected,
                              avatar: selected ? const Icon(Icons.check, size: 17) : null,
                              onSelected: (_) => toggle(book, chapter),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
