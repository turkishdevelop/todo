
import 'package:hive/hive.dart';

part '../adapters/note_helper.g.dart';

@HiveType(typeId: 1)
class Note{

  @HiveField(0)
  String note;

  Note({this.note});
}