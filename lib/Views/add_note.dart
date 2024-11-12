import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_note_app/Bloc/note_bloc.dart';
import 'package:simple_note_app/Models/notes.dart';
import 'package:simple_note_app/ThemeBloc/theme_bloc.dart';
import 'package:simple_note_app/Views/themes.dart';

class AddNote extends StatefulWidget {
  const AddNote({super.key});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  String createdAt = DateTime.now().toIso8601String();
  bool _validateTitle = false;
  bool _validateContent = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NoteBloc, NoteState>(
      listener: (context, state) {
        if (state is SuccessNoteInsertion) {
          Navigator.of(context).pop();
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

        return Scaffold(
          appBar: AppBar(
            backgroundColor: appBarBackgroundColor,
            iconTheme: iconThemeColor,
            title: Text(
              "Add Note",
              style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Lora'),
            ),
            actions: [
              state is LoadingState
                  ? const Padding(
                      padding: EdgeInsets.all(8),
                      child: CircularProgressIndicator(
                        color: Colors.blueAccent,
                      ),
                    )
                  : IconButton(
                      onPressed: () {
                        setState(() {
                          _validateTitle = titleController.text.isEmpty;
                          _validateContent = contentController.text.isEmpty;
                        });

                        if (!_validateTitle && !_validateContent) {
                          context.read<NoteBloc>().add(AddNoteEvent(Notes(
                              title: titleController.text,
                              content: contentController.text,
                              createdAt: createdAt)));
                        }
                      },
                      icon: const Icon(
                        Icons.check,
                        color: Colors.blueAccent,
                      ),
                    ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: titleController,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                      hintText: "Title",
                      hintStyle: hintTextColor,
                      filled: true,
                      fillColor: fillColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      errorText:
                          _validateTitle ? 'Title can\'t be Empty' : null),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: TextField(
                    controller: contentController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    style: const TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                        hintText: "Start writing...",
                        hintStyle: hintTextColor,
                        filled: true,
                        fillColor: fillColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.all(16),
                        errorText: _validateContent
                            ? 'Content can\'t be Empty'
                            : null),
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: backgroundColor,
        );
      },
    );
  }
}
