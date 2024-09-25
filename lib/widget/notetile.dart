import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:noteapp/providers/notesprovider.dart';
import 'package:noteapp/routes/animatedroute.dart';
import 'package:noteapp/widget/addtodoview.dart';
import 'package:provider/provider.dart';

class NoteTile extends StatefulWidget {
  String title;
  var createdAt;
  String content;
  String id;
  NoteTile(
      {super.key,
      required this.title,
      required this.createdAt,
      required this.content,
      required this.id});

  @override
  State<NoteTile> createState() => _NoteTileState();
}

class _NoteTileState extends State<NoteTile> {
  @override
  Widget build(BuildContext context) {
    final notesProvider = Provider.of<NotesProvider>(context);
    final bool isPinned =
        notesProvider.notes.firstWhere((note) => note.id == widget.id).isPinned;
    final String title =
        notesProvider.notes.firstWhere((note) => note.id == widget.id).title;
    final String content =
        notesProvider.notes.firstWhere((note) => note.id == widget.id).content;
    return Slidable(
        key: ValueKey(0),
        endActionPane: ActionPane(motion: ScrollMotion(), children: [
          SlidableAction(
            onPressed: (context) {
              notesProvider.togglePinned(widget.id);
            },
            icon: isPinned ? Icons.push_pin : Icons.push_pin_outlined,
            backgroundColor: Colors.grey,
          ),
          SlidableAction(
            onPressed: (context) {
              notesProvider.deleteNote(widget.id);
            },
            icon: Icons.delete,
            backgroundColor: Colors.red,
          )
        ]),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(createRoute(AddTodoView(
              id: widget.id,
              titleToUpdate: title,
              contentToUpdate: content,
            )));
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
                side: BorderSide(
                  color: Colors.white24,
                ),
              ),
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      widget.title,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(widget.content,
                        overflow: TextOverflow.ellipsis, maxLines: 7),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6.0, right: 6.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${DateFormat('yyyy-MM-dd HH:mm:ss').format(widget.createdAt)}',
                          style: TextStyle(color: Colors.white38),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
