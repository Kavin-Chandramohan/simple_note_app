import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:simple_note_app/Bloc/note_bloc.dart';
import 'package:simple_note_app/Views/themes.dart';
import 'package:simple_note_app/Views/update_note.dart';

import '../ThemeBloc/theme_bloc.dart';

class ShowNote extends StatelessWidget {
  const ShowNote({super.key});

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<NoteBloc, NoteState>(
      listener: (context, state) {
        if (state is SuccessNoteDelete) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Note deleted successfully')),
          );
          Navigator.pop(context);
        }
        if (state is SuccessNoteUpdate) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Note updated successfully')),
          );
          context.read<NoteBloc>().add(GetNoteByIdEvent(state.note.id!));
        }
      },
      builder: (context, state) {
        // Retrieve the current theme state
        final themeState = context.read<ThemeBloc>().state;

        // Access colors from your theme
        final textColor = themeState is LightThemeState
            ? lightTheme.primaryColor
            : darkTheme.primaryColor;
        final appBarBackgroundColor = themeState is LightThemeState
            ? lightTheme.appBarTheme.backgroundColor
            : darkTheme.appBarTheme.backgroundColor;
        final backgroundColor = themeState is LightThemeState
            ? lightTheme.scaffoldBackgroundColor
            : darkTheme.scaffoldBackgroundColor;
        final fillColor = themeState is LightThemeState
            ? lightTheme.inputDecorationTheme.fillColor
            : darkTheme.inputDecorationTheme.fillColor;
        final hintTextColor = themeState is LightThemeState
            ? lightTheme.inputDecorationTheme.hintStyle
            : darkTheme.inputDecorationTheme.hintStyle;
        final iconThemeColor = themeState is LightThemeState
            ? lightTheme.appBarTheme.iconTheme
            : darkTheme.appBarTheme.iconTheme;

        if (state is GetNoteByIdState || state is SuccessNoteUpdate) {
          final note = state is GetNoteByIdState
              ? state.notes
              : (state as SuccessNoteUpdate).note;

          return Scaffold(
            appBar: AppBar(
              backgroundColor: appBarBackgroundColor,
              iconTheme: iconThemeColor,
              leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  icon: const Icon(Icons.arrow_back)),
              title: Text(
                note.title,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontFamily: 'Lora'
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.edit_note, color: Colors.blueAccent),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UpdateNote(),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text(
                            'Delete Note',
                            style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Lora'),
                          ),
                          content: const Text(
                            'Are you sure you want to delete this note?',
                            style: TextStyle(color: Colors.grey),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: const Text('Delete',
                                  style: TextStyle(color: Colors.redAccent)),
                              onPressed: () {
                                context
                                    .read<NoteBloc>()
                                    .add(DeleteNoteEvent(note.id!));
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dateFormat(note.createdAt),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    note.content,
                    style: TextStyle(
                      fontSize: 18,
                      color: textColor,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            backgroundColor: backgroundColor,
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  String dateFormat(String date) {
    final DateFormat dateFormat = DateFormat("MMM d, yyyy hh:mm a");
    return dateFormat.format(DateTime.parse(date));
  }
}
