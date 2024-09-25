import 'package:flutter/material.dart';
import 'package:noteapp/providers/notesprovider.dart';
import 'package:noteapp/utils/noteclass.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddTodoView extends StatefulWidget {
  String? titleToUpdate;
  String? contentToUpdate;
  var id;
  AddTodoView({super.key, this.titleToUpdate, this.contentToUpdate, this.id});

  @override
  State<AddTodoView> createState() => _AddTodoViewState();
}

class _AddTodoViewState extends State<AddTodoView> {
  late final title = TextEditingController(text: widget.titleToUpdate);
  late final content = TextEditingController(text: widget.contentToUpdate);

  bool isEmpty = false;

  void handleEmpty(String value) {
    setState(() {
      isEmpty = content.text.trim().isNotEmpty || title.text.trim().isNotEmpty;
    });
  }

  late bool condition = widget.contentToUpdate == null ||
      widget.titleToUpdate == null ||
      widget.id == null;

  @override
  Widget build(BuildContext context) {
    final notesProvider = Provider.of<NotesProvider>(context);
    return MaterialApp(
      theme: ThemeData.dark(useMaterial3: true),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          actions: [
            Visibility(
                visible: isEmpty,
                child: IconButton(
                    onPressed: () {
                      const Uuid uuid = Uuid();
                      if (condition) {
                        notesProvider.addNotes(Note(
                            id: uuid.v4(),
                            title: title.text,
                            content: content.text,
                            createdAt: DateTime.now(),
                            isPinned: false));
                      } else {
                        notesProvider.updateNote(
                            widget.id, content.text, title.text);
                      }
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.check)))
          ],
          leading: InkWell(
            child: Icon(Icons.arrow_back),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                onChanged: handleEmpty,
                controller: title,
                autofocus: condition,
                decoration: InputDecoration(
                    hintText: 'Title',
                    border: InputBorder.none,
                    hintStyle:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: TextField(
                    onChanged: handleEmpty,
                    controller: content,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: 'Note',
                      border: InputBorder.none,
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
