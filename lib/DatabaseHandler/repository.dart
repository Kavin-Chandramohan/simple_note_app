
import 'package:simple_note_app/DatabaseHandler/connection.dart';
import 'package:simple_note_app/DatabaseHandler/tables.dart';
import 'package:simple_note_app/Models/notes.dart';


class Repository {

  final DatabaseHandler databaseHandler = DatabaseHandler();

  // Get Notes
  Future<List<Notes>> getNotes() async {
    final db = await databaseHandler.initDatabase();
    final List<Map<String, Object?>> notes = await db.query(Tables.noteTableName);
    // Convert the result into a list of Notes
    return notes.map((e) => Notes.fromMap(e)).toList();
  }

  // Add Note
  Future<int> addNote(Notes notes) async {
    final db = await databaseHandler.initDatabase();
    return db.insert(Tables.noteTableName, notes.toMap());
  }

  // Update Note
  Future<int> updateNote (Notes notes) async {
    final db = await databaseHandler.initDatabase();
    return db.update(
        Tables.noteTableName,
        notes.toMap(),
        where: "id = ?",
        whereArgs: [notes.id]
    );
  }

  // Delete Note
  Future<int> deleteNote(int id) async {
    final db = await databaseHandler.initDatabase();
    return db.delete(
        Tables.noteTableName,
        where: "id = ?",
        whereArgs: [id]
    );
  }

  // Get Note by ID
  Future<Notes> getNoteById(int id) async {
    final db = await databaseHandler.initDatabase();
    final note = await db.query(
        Tables.noteTableName,
        where: "id = ?",
        whereArgs: [id]
    );

    if(note.isNotEmpty) {
      return Notes.fromMap(note.first);
    } else {
      throw Exception("Note $id not found");
    }
  }

}
