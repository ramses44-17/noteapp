import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hive/hive.dart';
import 'package:noteapp/providers/notesprovider.dart';
import 'package:noteapp/routes/animatedroute.dart';
import 'package:noteapp/utils/database.dart';
import 'package:noteapp/utils/noteclass.dart';
import 'package:noteapp/widget/addTodoView.dart';
import 'package:noteapp/widget/notetile.dart';
import 'package:provider/provider.dart';

class NotesBuilder extends StatefulWidget {
  const NotesBuilder({super.key});

  @override
  State<NotesBuilder> createState() => _NotesBuilderState();
}

class _NotesBuilderState extends State<NotesBuilder> {
  late bool isGrid = state.get('isGrid') ?? false;
  Box state = Hive.box('state');
  Database db = Database();
  @override
  Widget build(BuildContext context) {
    final notesProvider = Provider.of<NotesProvider>(context);
    final notes = notesProvider.notes;
    final pinnedNotes = notes.where((note) => note.isPinned).toList();
    final unPinnedNotes = notes.where((note) => !note.isPinned).toList();
    unPinnedNotes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    pinnedNotes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(createRoute(AddTodoView()));
          },
          child: Icon(Icons.add),
        ),
        drawer: Drawer(),
        appBar: AppBar(
          title: Text('Note App'),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: InkWell(
                onTap: () {
                  setState(() {
                    isGrid = !isGrid;
                  });
                  state.put('isGrid', isGrid);
                },
                child: !isGrid
                    ? Icon(Icons.view_list_outlined)
                    : Icon(Icons.grid_view_outlined),
              ),
            )
          ],
        ),
        body: (notes.isEmpty)
            ? Center(
                child: Text('pas de liste note'),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Visibility(
                        visible: pinnedNotes.isNotEmpty,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text('notes épinglées'),
                            ),
                          ],
                        )),
                    !isGrid
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: pinnedNotes.length,
                            itemBuilder: (context, int index) {
                              return NoteTile(
                                title: pinnedNotes[index].title,
                                createdAt: pinnedNotes[index].createdAt,
                                content: pinnedNotes[index].content,
                                id: pinnedNotes[index].id,
                              );
                            })
                        : MasonryGridView.count(
                            itemCount: pinnedNotes.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            itemBuilder: (context, int index) {
                              return NoteTile(
                                title: pinnedNotes[index].title,
                                content: pinnedNotes[index].content,
                                createdAt: pinnedNotes[index].createdAt,
                                id: pinnedNotes[index].id,
                              );
                            }),
                    Visibility(
                        visible:
                            unPinnedNotes.isNotEmpty && pinnedNotes.isNotEmpty,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text('autres notes'),
                            ),
                          ],
                        )),
                    !isGrid
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: unPinnedNotes.length,
                            itemBuilder: (context, int index) {
                              return NoteTile(
                                title: unPinnedNotes[index].title,
                                content: unPinnedNotes[index].content,
                                createdAt: unPinnedNotes[index].createdAt,
                                id: unPinnedNotes[index].id,
                              );
                            })
                        : MasonryGridView.count(
                            itemCount: unPinnedNotes.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            itemBuilder: (context, int index) {
                              return NoteTile(
                                title: unPinnedNotes[index].title,
                                content: unPinnedNotes[index].content,
                                createdAt: unPinnedNotes[index].createdAt,
                                id: unPinnedNotes[index].id,
                              );
                            }),
                  ],
                ),
              ));
  }
}
