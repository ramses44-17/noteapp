import 'package:hive/hive.dart';
import 'package:noteapp/utils/noteclass.dart';

class Database {
  Box<Note> notesBox = Hive.box('notesBox');

  void addData(Note note) {
    notesBox.put(note.id, note);
  }

  void deleteData(String id) {
    notesBox.delete(id);
  }

  void updateData(String id, Note note) {
    notesBox.put(id, note);
  }

  void initialize() {
    Note note1 = Note(
        id: '1',
        content:
            "Welcome to your note-taking app! Here you can easily organize and store your thoughts, ideas and memories. Don't hesitate to create new notes to keep them close at hand.you can modify the title and content of this initial note as you see fit. Add details, lists, or anything else you think will be useful in your day-to-day life.Happy note-taking !",
        title: 'Welcome !',
        createdAt: DateTime.now(),
        isPinned: false);
    Note note2 = Note(
        id: '2',
        content:
            "Bienvenue dans votre application de prise de notes ! Ici, vous pourrez facilement organiser et stocker vos pensées, idées et souvenirs. N'hésitez pas à créer de nouvelles notes pour les garder à portée de main.Vous pouvez modifier le titre et le contenu de cette note de départ comme bon vous semble. Ajoutez des détails,des listes, ou tout ce qui vous sera utile au quotidien.Bonne prise de notes !",
        title: 'Bienvenue !',
        createdAt: DateTime.now(),
        isPinned: false);
    if (notesBox.values.isEmpty) {
      notesBox.putAll({
        note2.id: note2,
        note1.id: note1
      });
    }
  }
}
