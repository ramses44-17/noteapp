

import 'package:hive/hive.dart';
part 'noteclass.g.dart';

@HiveType(typeId: 1)
class Note {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String content;

  @HiveField(3)
  DateTime createdAt;

  @HiveField(4)
  bool isPinned;
  Note(
      {required this.id,
      required this.content,
      required this.title,
      required this.createdAt,
      required this.isPinned});
}
