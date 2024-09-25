import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:noteapp/notebuilder.dart';
import 'package:noteapp/providers/notesprovider.dart';
import 'package:noteapp/utils/database.dart';
import 'package:noteapp/utils/noteclass.dart';
import 'package:provider/provider.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(NoteAdapter());
  await Hive.openBox<Note>('notesBox');
  await Hive.openBox('state');
  runApp(ChangeNotifierProvider(
    create: (context) => NotesProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Database db = Database();

  @override
  void initState() {
    db.initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData.dark(useMaterial3: true),
        debugShowCheckedModeBanner: false,
        home: NotesBuilder());
  }
}
