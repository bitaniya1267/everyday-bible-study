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
  Widget build(BuildContext context) => MaterialApp(
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
        home: const HomePage(),
      );
}

class StudyEntry {
  String id, date, book, chapter, passage;
  String character, knownFor, charBooks, charChapters, charStory, traits;
  String charVerses, charLearn, charApply, charChallenges, charGodUsed;
  String charTakeaway, charPrayer;
  String summary, chapterCharacters, concepts, chapterChallenge, chapterVerse;
  String noticed, remember, aboutGod, aboutChrist, aboutHumans, response;
  String questions, lifeApplication, studyFurther, teaching, memoryVerse, reflectionPrayer;

  StudyEntry({
    required this.id, required this.date, this.book = '', this.chapter = '', this.passage = '',
    this.character = '', this.knownFor = '', this.charBooks = '', this.charChapters = '',
    this.charStory = '', this.traits = '', this.charVerses = '', this.charLearn = '',
    this.charApply = '', this.charChallenges = '', this.charGodUsed = '', this.charTakeaway = '',
    this.charPrayer = '', this.summary = '', this.chapterCharacters = '', this.concepts = '',
    this.chapterChallenge = '', this.chapterVerse = '', this.noticed = '', this.remember = '',
    this.aboutGod = '', this.aboutChrist = '', this.aboutHumans = '', this.response = '',
    this.questions = '', this.lifeApplication = '', this.studyFurther = '', this.teaching = '',
    this.memoryVerse = '', this.reflectionPrayer = '',
  });

  Map<String, dynamic> toJson() => {
        'id': id, 'date': date, 'book': book, 'chapter': chapter, 'passage': passage,
        'character': character, 'knownFor': knownFor, 'charBooks': charBooks,
        'charChapters': charChapters, 'charStory': charStory, 'traits': traits,
        'charVerses': charVerses, 'charLearn': charLearn, 'charApply': charApply,
        'charChallenges': charChallenges, 'charGodUsed': charGodUsed,
        'charTakeaway': charTakeaway, 'charPrayer': charPrayer, 'summary': summary,
        'chapterCharacters': chapterCharacters, 'concepts': concepts,
        'chapterChallenge': chapterChallenge, 'chapterVerse': chapterVerse,
        'noticed': noticed, 'remember': remember, 'aboutGod': aboutGod,
        'aboutChrist': aboutChrist, 'aboutHumans': aboutHumans, 'response': response,
        'questions': questions, 'lifeApplication': lifeApplication, 'studyFurther': studyFurther,
        'teaching': teaching, 'memoryVerse': memoryVerse, 'reflectionPrayer': reflectionPrayer,
      };

  factory StudyEntry.fromJson(Map<String, dynamic> j) => StudyEntry(
        id: j['id'] ?? '', date: j['date'] ?? '', book: j['book'] ?? '', chapter: j['chapter'] ?? '',
        passage: j['passage'] ?? '', character: j['character'] ?? '', knownFor: j['knownFor'] ?? '',
        charBooks: j['charBooks'] ?? '', charChapters: j['charChapters'] ?? '', charStory: j['charStory'] ?? '',
        traits: j['traits'] ?? '', charVerses: j['charVerses'] ?? '', charLearn: j['charLearn'] ?? '',
        charApply: j['charApply'] ?? '', charChallenges: j['charChallenges'] ?? '', charGodUsed: j['charGodUsed'] ?? '',
        charTakeaway: j['charTakeaway'] ?? '', charPrayer: j['charPrayer'] ?? '', summary: j['summary'] ?? '',
        chapterCharacters: j['chapterCharacters'] ?? '', concepts: j['concepts'] ?? '',
        chapterChallenge: j['chapterChallenge'] ?? '', chapterVerse: j['chapterVerse'] ?? '',
        noticed: j['noticed'] ?? '', remember: j['remember'] ?? '', aboutGod: j['aboutGod'] ?? '',
        aboutChrist: j['aboutChrist'] ?? '', aboutHumans: j['aboutHumans'] ?? '', response: j['response'] ?? '',
        questions: j['questions'] ?? '', lifeApplication: j['lifeApplication'] ?? '', studyFurther: j['studyFurther'] ?? '',
        teaching: j['teaching'] ?? '', memoryVerse: j['memoryVerse'] ?? '', reflectionPrayer: j['reflectionPrayer'] ?? '',
      );
}

class Store {
  static const key = 'everyday_bible_studies_complete_v1';
  static Future<List<StudyEntry>> load() async {
    final p = await SharedPreferences.getInstance();
    final raw = p.getString(key);
    if (raw == null) return [];
    try {
      return (jsonDecode(raw) as List).map((e) => StudyEntry.fromJson(Map<String, dynamic>.from(e))).toList();
    } catch (_) { return []; }
  }
  static Future<void> save(List<StudyEntry> list) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(key, jsonEncode(list.map((e) => e.toJson()).toList()));
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  List<StudyEntry> studies = [];
  bool loading = true;
  @override void initState() { super.initState(); _load(); }
  Future<void> _load() async {
    final x = await Store.load(); x.sort((a,b) => b.date.compareTo(a.date));
    if (mounted) setState(() { studies = x; loading = false; });
  }
  Future<void> _new() async {
    final e = StudyEntry(id: DateTime.now().microsecondsSinceEpoch.toString(), date: fmt(DateTime.now()));
    final r = await Navigator.push<StudyEntry>(context, MaterialPageRoute(builder: (_) => DailyStudyPage(entry: e)));
    if (r != null) { setState(() { studies.removeWhere((x) => x.id == r.id); studies.add(r); studies.sort((a,b)=>b.date.compareTo(a.date)); }); await Store.save(studies); }
  }
  Future<void> _edit(StudyEntry e) async {
    final r = await Navigator.push<StudyEntry>(context, MaterialPageRoute(builder: (_) => DailyStudyPage(entry: e)));
    if (r != null) { setState(() { final i=studies.indexWhere((x)=>x.id==r.id); if(i>=0) studies[i]=r; studies.sort((a,b)=>b.date.compareTo(a.date)); }); await Store.save(studies); }
  }
  Future<void> _delete(StudyEntry e) async {
    final ok = await showDialog<bool>(context: context, builder: (_) => AlertDialog(
      title: const Text('Delete daily study?'), content: Text('Delete the study dated ${e.date}?'),
      actions: [TextButton(onPressed:()=>Navigator.pop(context,false), child:const Text('Cancel')), FilledButton(onPressed:()=>Navigator.pop(context,true), child:const Text('Delete'))],
    ));
    if(ok==true){ setState(()=>studies.removeWhere((x)=>x.id==e.id)); await Store.save(studies); }
  }
  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Everyday Bible Study'), backgroundColor: Colors.white, foregroundColor: Colors.brown.shade800),
    body: loading ? const Center(child:CircularProgressIndicator()) : ListView(padding: const EdgeInsets.all(16), children: [
      Container(padding: const EdgeInsets.all(22), decoration: BoxDecoration(
        gradient: LinearGradient(colors:[Colors.pink.shade50,Colors.orange.shade50]), borderRadius: BorderRadius.circular(20), border: Border.all(color:Colors.pink.shade100)),
        child: const Column(children:[Text('📖',style:TextStyle(fontSize:42)), SizedBox(height:6), Text('EVERYDAY BIBLE STUDY',style:TextStyle(fontSize:24,fontWeight:FontWeight.bold,color:Colors.brown)), SizedBox(height:6), Text('A complete daily Bible study journal with all four study formats in one saved page.',textAlign:TextAlign.center,style:TextStyle(color:Colors.black54))])),
      const SizedBox(height:16), FilledButton.icon(onPressed:_new, icon:const Icon(Icons.add), label:const Padding(padding:EdgeInsets.all(12),child:Text('CREATE NEW DAILY STUDY',style:TextStyle(fontWeight:FontWeight.bold)))),
      const SizedBox(height:24), const Heading('MY DAILY STUDIES'), const SizedBox(height:8),
      if(studies.isEmpty) Container(padding:const EdgeInsets.all(24),decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(14),border:Border.all(color:Colors.grey.shade300)),child:const Column(children:[Icon(Icons.calendar_month_outlined,size:48,color:Colors.grey),SizedBox(height:8),Text('No daily studies yet.',style:TextStyle(fontWeight:FontWeight.bold)),SizedBox(height:4),Text('Create your first study. All four study sections will be saved together.',textAlign:TextAlign.center,style:TextStyle(color:Colors.black54))]))
      else ...studies.map((e)=>Card(child:ListTile(
        leading:CircleAvatar(backgroundColor:Colors.pink.shade50,child:Icon(Icons.menu_book,color:Colors.pink.shade700)),
        title:Text(e.book.isEmpty?'Bible Study — ${e.date}':'${e.book}${e.chapter.isEmpty?'':' ${e.chapter}'}',style:const TextStyle(fontWeight:FontWeight.bold)),
        subtitle:Text(e.passage.isEmpty?e.date:'${e.date} • ${e.passage}',maxLines:2,overflow:TextOverflow.ellipsis),
        trailing:PopupMenuButton<String>(onSelected:(v){if(v=='open')_edit(e);if(v=='delete')_delete(e);},itemBuilder:(_)=>const[PopupMenuItem(value:'open',child:Text('Open / Edit')),PopupMenuItem(value:'delete',child:Text('Delete'))]), onTap:()=>_edit(e)))) ,
      const SizedBox(height:24), const Heading('STUDY TOOLS'),
      ToolCard('Bible Character Study','Standalone character study worksheet.',Icons.person_outline,const CharacterPage()),
      ToolCard('Chapter Study','Standalone chapter study worksheet.',Icons.menu_book,const ChapterPage()),
      ToolCard('Quiet Time Notes','Standalone quiet time worksheet.',Icons.spa_outlined,const QuietPage()),
      ToolCard('Reflection Journal','Standalone reflection worksheet.',Icons.edit_note,const ReflectionPage()),
      ToolCard('New Testament Reading Tracker','Track every New Testament chapter.',Icons.check_circle_outline,const TrackerPage()),
    ]),
  );
}

class Heading extends StatelessWidget { final String text; const Heading(this.text,{super.key}); @override Widget build(BuildContext c)=>Padding(padding:const EdgeInsets.only(bottom:8),child:Text(text,style:const TextStyle(fontSize:20,fontWeight:FontWeight.bold,color:Colors.brown))); }
class ToolCard extends StatelessWidget { final String title,sub; final IconData icon; final Widget page; const ToolCard(this.title,this.sub,this.icon,this.page,{super.key}); @override Widget build(BuildContext c)=>Card(child:ListTile(leading:Icon(icon,color:Colors.brown.shade500),title:Text(title,style:const TextStyle(fontWeight:FontWeight.bold)),subtitle:Text(sub),trailing:const Icon(Icons.arrow_forward_ios,size:15),onTap:()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>page)))); }

// ============================================================
// COMPLETE DAILY PAGE: 1 CHARACTER + 2 CHAPTER + 3 QUIET TIME + 4 REFLECTION
// ============================================================
class DailyStudyPage extends StatefulWidget {
  final StudyEntry entry; const DailyStudyPage({super.key,required this.entry});
  @override State<DailyStudyPage> createState()=>_DailyStudyPageState();
}
class _DailyStudyPageState extends State<DailyStudyPage> {
  late final Map<String,TextEditingController> c;
  @override void initState(){super.initState(); final e=widget.entry; c={
    'date':TextEditingController(text:e.date),'book':TextEditingController(text:e.book),'chapter':TextEditingController(text:e.chapter),'passage':TextEditingController(text:e.passage),
    'character':TextEditingController(text:e.character),'knownFor':TextEditingController(text:e.knownFor),'charBooks':TextEditingController(text:e.charBooks),'charChapters':TextEditingController(text:e.charChapters),'charStory':TextEditingController(text:e.charStory),'traits':TextEditingController(text:e.traits),'charVerses':TextEditingController(text:e.charVerses),'charLearn':TextEditingController(text:e.charLearn),'charApply':TextEditingController(text:e.charApply),'charChallenges':TextEditingController(text:e.charChallenges),'charGodUsed':TextEditingController(text:e.charGodUsed),'charTakeaway':TextEditingController(text:e.charTakeaway),'charPrayer':TextEditingController(text:e.charPrayer),
    'summary':TextEditingController(text:e.summary),'chapterCharacters':TextEditingController(text:e.chapterCharacters),'concepts':TextEditingController(text:e.concepts),'chapterChallenge':TextEditingController(text:e.chapterChallenge),'chapterVerse':TextEditingController(text:e.chapterVerse),
    'noticed':TextEditingController(text:e.noticed),'remember':TextEditingController(text:e.remember),'aboutGod':TextEditingController(text:e.aboutGod),'aboutChrist':TextEditingController(text:e.aboutChrist),'aboutHumans':TextEditingController(text:e.aboutHumans),'response':TextEditingController(text:e.response),
    'questions':TextEditingController(text:e.questions),'lifeApplication':TextEditingController(text:e.lifeApplication),'studyFurther':TextEditingController(text:e.studyFurther),'teaching':TextEditingController(text:e.teaching),'memoryVerse':TextEditingController(text:e.memoryVerse),'reflectionPrayer':TextEditingController(text:e.reflectionPrayer),
  };}
  @override void dispose(){for(final x in c.values)x.dispose();super.dispose();}
  Future<void> pickDate() async {final d=await showDatePicker(context:context,initialDate:DateTime.tryParse(c['date']!.text)??DateTime.now(),firstDate:DateTime(2000),lastDate:DateTime(2100));if(d!=null)setState(()=>c['date']!.text=fmt(d));}
  void save(){String g(String k)=>c[k]!.text.trim(); final e=StudyEntry(
    id:widget.entry.id,date:g('date').isEmpty?fmt(DateTime.now()):g('date'),book:g('book'),chapter:g('chapter'),passage:g('passage'),character:g('character'),knownFor:g('knownFor'),charBooks:g('charBooks'),charChapters:g('charChapters'),charStory:g('charStory'),traits:g('traits'),charVerses:g('charVerses'),charLearn:g('charLearn'),charApply:g('charApply'),charChallenges:g('charChallenges'),charGodUsed:g('charGodUsed'),charTakeaway:g('charTakeaway'),charPrayer:g('charPrayer'),summary:g('summary'),chapterCharacters:g('chapterCharacters'),concepts:g('concepts'),chapterChallenge:g('chapterChallenge'),chapterVerse:g('chapterVerse'),noticed:g('noticed'),remember:g('remember'),aboutGod:g('aboutGod'),aboutChrist:g('aboutChrist'),aboutHumans:g('aboutHumans'),response:g('response'),questions:g('questions'),lifeApplication:g('lifeApplication'),studyFurther:g('studyFurther'),teaching:g('teaching'),memoryVerse:g('memoryVerse'),reflectionPrayer:g('reflectionPrayer'));
    Navigator.pop(context,e);
  }
  Widget f(String key,String label,{int lines=2})=>Field(c[key]!,label,lines:lines);
  @override Widget build(BuildContext context)=>Scaffold(
    appBar:AppBar(title:const Text('Complete Daily Study'),backgroundColor:Colors.pink.shade50,foregroundColor:Colors.brown.shade800,actions:[IconButton(onPressed:save,icon:const Icon(Icons.save))]),
    body:ListView(padding:const EdgeInsets.all(16),children:[
      const Heading('📅 DAILY BIBLE STUDY'),
      Row(children:[Expanded(child:TextField(controller:c['date'],readOnly:true,decoration:const InputDecoration(labelText:'DATE',prefixIcon:Icon(Icons.calendar_today)))),const SizedBox(width:8),IconButton.filledTonal(onPressed:pickDate,icon:const Icon(Icons.edit_calendar))]),
      const SizedBox(height:10), Responsive([f('book','BOOK'),f('chapter','CHAPTER')]), Box('📖 TODAY’S PASSAGE',f('passage','Passage / reference',lines:4)),
      Section('1','BIBLE CHARACTER STUDY','Learning from their story. Growing in our faith.',Colors.pink,[
        Responsive([f('character','CHARACTER'),f('knownFor','KNOWN FOR')]), Responsive([f('charBooks','BOOK(S)'),f('charChapters','CHAPTER(S)')]), f('charStory','TELL THEIR STORY IN YOUR OWN WORDS',lines:6), Responsive([f('traits','TRAITS — What words describe this person?',lines:5),f('charVerses','KEY VERSE(S)',lines:5)]), f('charLearn','WHAT CAN WE LEARN FROM THEIR LIFE?',lines:5), f('charApply','HOW CAN WE APPLY THIS TO OUR LIFE TODAY?',lines:5), Responsive([f('charChallenges','CHALLENGES — Struggles, mistakes, or hard moments',lines:5),f('charGodUsed','HOW GOD USED THEM',lines:5)]), f('charTakeaway','BIGGEST TAKEAWAY',lines:4), f('charPrayer','A PRAYER',lines:5)
      ]),
      Section('2','CHAPTER STUDY','Passage summary, key concepts, and challenges.',Colors.brown,[
        f('summary','SUMMARY',lines:6), Responsive([f('chapterCharacters','CHARACTERS',lines:5),f('concepts','KEY CONCEPTS',lines:5)]), f('chapterChallenge','SOMETHING THAT CHALLENGED ME',lines:5), f('chapterVerse','A VERSE THAT STOOD OUT',lines:4)
      ]),
      Section('3','QUIET TIME NOTES','What this says about God, Christ, humans, and response.',Colors.teal,[
        Responsive([f('noticed','3 THINGS I NOTICED',lines:5),f('remember','3 THINGS TO REMEMBER',lines:5)]), Responsive([f('aboutGod','WHAT DOES THIS SAY ABOUT GOD?',lines:5),f('aboutChrist','WHAT DOES THIS SAY ABOUT CHRIST?',lines:5)]), Responsive([f('aboutHumans','WHAT DOES THIS SAY ABOUT HUMANS?',lines:5),f('response','HOW SHOULD WE RESPOND?',lines:5)])
      ]),
      Section('4','REFLECTION JOURNAL','Questions, application, memory verse, and prayer.',Colors.indigo,[
        Responsive([f('questions','WHAT QUESTIONS DO I HAVE?',lines:5),f('lifeApplication','HOW DOES THIS APPLY TO MY LIFE?',lines:5)]), f('studyFurther','WHAT DO I NEED TO STUDY FURTHER?',lines:5), f('teaching','WHAT IS THIS CHAPTER TEACHING ME?',lines:7), f('memoryVerse','MEMORY VERSE',lines:4), f('reflectionPrayer','PRAYER',lines:6)
      ]),
      const SizedBox(height:8), FilledButton.icon(onPressed:save,icon:const Icon(Icons.save),label:const Padding(padding:EdgeInsets.all(14),child:Text('SAVE COMPLETE DAILY STUDY',style:TextStyle(fontWeight:FontWeight.bold)))), const SizedBox(height:30)
    ]),
  );
}

class Field extends StatelessWidget {final TextEditingController controller;final String label;final int lines;const Field(this.controller,this.label,{this.lines=2,super.key});@override Widget build(BuildContext c)=>Padding(padding:const EdgeInsets.only(bottom:10),child:TextField(controller:controller,maxLines:lines,decoration:InputDecoration(labelText:label,alignLabelWithHint:true)));}
class Box extends StatelessWidget {final String title;final Widget child;const Box(this.title,this.child,{super.key});@override Widget build(BuildContext c)=>Container(margin:const EdgeInsets.symmetric(vertical:8),padding:const EdgeInsets.all(12),decoration:BoxDecoration(color:Colors.white,border:Border.all(color:Colors.pink.shade100),borderRadius:BorderRadius.circular(12)),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(title,style:const TextStyle(fontWeight:FontWeight.bold)),const SizedBox(height:8),child]));}
class Section extends StatelessWidget {final String n,title,sub;final MaterialColor color;final List<Widget> children;const Section(this.n,this.title,this.sub,this.color,this.children,{super.key});@override Widget build(BuildContext c)=>Container(margin:const EdgeInsets.symmetric(vertical:10),padding:const EdgeInsets.all(14),decoration:BoxDecoration(color:color.shade50.withOpacity(.45),border:Border.all(color:color.shade200),borderRadius:BorderRadius.circular(14)),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Row(crossAxisAlignment:CrossAxisAlignment.start,children:[CircleAvatar(radius:17,backgroundColor:color.shade100,foregroundColor:color.shade800,child:Text(n,style:const TextStyle(fontWeight:FontWeight.bold))),const SizedBox(width:10),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(title,style:TextStyle(fontSize:17,fontWeight:FontWeight.bold,color:color.shade800)),Text(sub,style:const TextStyle(fontSize:12,color:Colors.black54))]))]),const SizedBox(height:12),...children]));}
class Responsive extends StatelessWidget {final List<Widget> children;const Responsive(this.children,{super.key});@override Widget build(BuildContext c)=>LayoutBuilder(builder:(c,con)=>con.maxWidth<720?Column(children:children):Row(crossAxisAlignment:CrossAxisAlignment.start,children:[Expanded(child:children[0]),const SizedBox(width:12),Expanded(child:children[1])]));}

// Standalone versions of the original worksheets.
class CharacterPage extends StatelessWidget {const CharacterPage({super.key});@override Widget build(BuildContext c)=>Worksheet('Bible Character Study','Learning from their story. Growing in our faith.',Colors.pink,const ['CHARACTER','KNOWN FOR','BOOK(S)','CHAPTER(S)','TELL THEIR STORY IN YOUR OWN WORDS','TRAITS — What words describe this person?','KEY VERSE(S)','WHAT CAN WE LEARN?','HOW CAN WE APPLY THIS TODAY?','CHALLENGES — Struggles, mistakes, or hard moments','HOW GOD USED THEM','BIGGEST TAKEAWAY','A PRAYER']);}
class ChapterPage extends StatelessWidget {const ChapterPage({super.key});@override Widget build(BuildContext c)=>Worksheet('Chapter Study','Passage summary, key concepts, and challenges.',Colors.brown,const ['DATE','PASSAGE','AUTHOR','AUDIENCE','SUMMARY','CHARACTERS','KEY CONCEPTS','SOMETHING THAT CHALLENGED ME','A VERSE THAT STOOD OUT']);}
class QuietPage extends StatelessWidget {const QuietPage({super.key});@override Widget build(BuildContext c)=>Worksheet('Quiet Time Notes','What this says about God, Christ, and humans.',Colors.teal,const ['DATE','TODAY’S PASSAGE','3 THINGS I NOTICED','3 THINGS TO REMEMBER','WHAT DOES THIS SAY ABOUT GOD?','WHAT DOES THIS SAY ABOUT CHRIST?','WHAT DOES THIS SAY ABOUT HUMANS?','HOW SHOULD WE RESPOND?']);}
class ReflectionPage extends StatelessWidget {const ReflectionPage({super.key});@override Widget build(BuildContext c)=>Worksheet('Reflection Journal','Questions, life application, memory verse, and prayer.',Colors.indigo,const ['DATE','BOOK','CHAPTER','WHAT QUESTIONS DO I HAVE?','HOW DOES THIS APPLY TO MY LIFE?','WHAT DO I NEED TO STUDY FURTHER?','WHAT IS THIS CHAPTER TEACHING ME?','MEMORY VERSE','PRAYER']);}
class Worksheet extends StatelessWidget {final String title,intro;final MaterialColor color;final List<String> sections;const Worksheet(this.title,this.intro,this.color,this.sections,{super.key});@override Widget build(BuildContext c)=>Scaffold(appBar:AppBar(title:Text(title),backgroundColor:color.shade50,foregroundColor:color.shade900),body:ListView(padding:const EdgeInsets.all(16),children:[Text(title,style:const TextStyle(fontSize:25,fontWeight:FontWeight.bold)),Text(intro,style:const TextStyle(color:Colors.black54)),const SizedBox(height:16),...sections.map((s)=>Container(margin:const EdgeInsets.symmetric(vertical:6),padding:const EdgeInsets.all(10),decoration:BoxDecoration(color:Colors.white,border:Border.all(color:color.shade200),borderRadius:BorderRadius.circular(10)),child:TextField(maxLines:longField(s)?5:2,decoration:InputDecoration(labelText:s,border:InputBorder.none,alignLabelWithHint:true))),),const SizedBox(height:20)]));}
bool longField(String s){final x=s.toUpperCase();return x.contains('STORY')||x.contains('SUMMARY')||x.contains('PRAYER')||x.contains('APPLY')||x.contains('PASSAGE')||x.contains('TEACHING')||x.contains('CHALLENGED');}

class TrackerPage extends StatefulWidget {const TrackerPage({super.key});@override State<TrackerPage> createState()=>_TrackerPageState();}
class _TrackerPageState extends State<TrackerPage>{final Map<String,int> books=const {'Matthew':28,'Mark':16,'Luke':24,'John':21,'Acts':28,'Romans':16,'1 Corinthians':16,'2 Corinthians':13,'Galatians':6,'Ephesians':6,'Philippians':4,'Colossians':4,'1 Thessalonians':5,'2 Thessalonians':3,'1 Timothy':6,'2 Timothy':4,'Titus':3,'Philemon':1,'Hebrews':13,'James':5,'1 Peter':5,'2 Peter':3,'1 John':5,'2 John':1,'3 John':1,'Jude':1,'Revelation':22};final Map<String,Set<int>> read={};int get total=>books.values.fold(0,(a,b)=>a+b);int get done=>read.values.fold(0,(a,b)=>a+b.length);@override Widget build(BuildContext c){final p=done/total;return Scaffold(appBar:AppBar(title:const Text('New Testament Reading Tracker'),backgroundColor:Colors.blue.shade100),body:ListView(padding:const EdgeInsets.all(16),children:[const Text('NEW TESTAMENT BIBLE READING TRACKER',textAlign:TextAlign.center,style:TextStyle(fontWeight:FontWeight.bold,fontSize:18)),const SizedBox(height:12),LinearProgressIndicator(value:p),const SizedBox(height:8),Text('$done of $total chapters completed',textAlign:TextAlign.center),const SizedBox(height:16),...books.entries.map((e){final s=read.putIfAbsent(e.key,()=>{});return Card(child:ExpansionTile(title:Text(e.key,style:const TextStyle(fontWeight:FontWeight.bold)),subtitle:Text('${s.length}/${e.value} chapters'),children:[Padding(padding:const EdgeInsets.all(10),child:Wrap(spacing:6,runSpacing:6,children:List.generate(e.value,(i){final n=i+1;return FilterChip(label:Text('$n'),selected:s.contains(n),onSelected:(v){setState((){v?s.add(n):s.remove(n);});});})))]));})]));}}

String fmt(DateTime d)=>'${d.year.toString().padLeft(4,'0')}-${d.month.toString().padLeft(2,'0')}-${d.day.toString().padLeft(2,'0')}';
