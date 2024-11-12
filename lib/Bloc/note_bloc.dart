
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_note_app/DatabaseHandler/repository.dart';
import 'package:simple_note_app/Models/notes.dart';

part 'note_event.dart';
part 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final Repository repository;
  NoteBloc(this.repository) : super(NoteInitial()) {

    // Event controllers
    on<GetAllNoteEvent>((event, emit) async {
      emit(LoadingState());

      try{
        final notes = await repository.getNotes();
        emit(LoadedState(notes));

      } catch (e) {
        emit(FailureState(e.toString()));
      }
    });

    // Add note
    on<AddNoteEvent>((event, emit) async {
      emit(LoadingState());
      try {
        // 1 sec delay
        Future.delayed(const Duration(seconds: 1));
        int res = await repository.addNote(
            Notes(
                title: event.notes.title,
                content: event.notes.content,
                createdAt: event.notes.createdAt
            )
        );
        if (res > 0) {
          emit(SuccessNoteInsertion());
          // Call fetch note event, once there is a new note
          add(GetAllNoteEvent());
        }
      } catch (e) {
        emit(FailureState(e.toString()));
      }
    });

    // Get note by ID
    on<GetNoteByIdEvent>((event, emit) async {
      final notes = await repository.getNoteById(event.id);
      emit(GetNoteByIdState(notes));
    });

    // Update
    on<UpdateNoteEvent>((event, emit) async {
      try {
        final updatedNote = Notes(
          id: event.notes.id,
          title: event.notes.title,
          content: event.notes.content,
          createdAt: event.notes.createdAt,
        );

        final res = await repository.updateNote(updatedNote);

        if (res > 0) {
          emit(SuccessNoteUpdate(updatedNote));  // Pass the updated note here
          add(GetAllNoteEvent());
        }
      } catch (e) {
        emit(FailureState(e.toString()));
      }
    });


    // Delete
    on<DeleteNoteEvent>((event, emit) async {
      try {
        final res = await repository.deleteNote(event.id);
        if (res > 0) {
          emit(SuccessNoteDelete());
          add(GetAllNoteEvent());
        }
      } catch (e) {
        emit(FailureState(e.toString()));
      }
    });

    // Search Notes
    on<SearchNotesEvent>((event, emit) async {
      try {
        // Fetch all notes from the repository or filter from the current list
        final notes = await repository.getNotes();

        // Filter notes by title based on the search query
        final filteredNotes = notes.where((note) {
          return note.title.toLowerCase().contains(event.query.toLowerCase());
        }).toList();

        // Emit the LoadedState with filtered notes
        emit(LoadedState(filteredNotes));
      } catch (e) {
        emit(FailureState(e.toString()));
      }
    });
  }
}
