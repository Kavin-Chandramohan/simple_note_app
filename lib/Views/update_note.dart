import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_note_app/Bloc/note_bloc.dart';
import 'package:simple_note_app/Models/notes.dart';
import 'package:simple_note_app/Views/themes.dart';

import '../ThemeBloc/theme_bloc.dart';

class UpdateNote extends StatefulWidget {
  const UpdateNote({super.key});

  @override
  State<UpdateNote> createState() => _UpdateNoteState();
}

class _UpdateNoteState extends State<UpdateNote> {
  final title = TextEditingController();
  final content = TextEditingController();
  String createdAt = DateTime.now().toIso8601String();
  bool _validateTitle = false;
  bool _validateContent = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NoteBloc, NoteState>(
      listener: (context, state) {
        if (state is SuccessNoteUpdate) {
          // Go back to the ShowNote page on a successful update
          Navigator.popUntil(context, (route) => route.isFirst);
          // Reload the updated note details
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

        if (state is GetNoteByIdState) {
          title.text = state.notes.title;
          content.text = state.notes.content;

          return Scaffold(
            appBar: AppBar(
              backgroundColor: appBarBackgroundColor,
              iconTheme: iconThemeColor,
              title: Text(
                "Edit Note",
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Lora',
                ),
              ),
              actions: [
                state is LoadingState
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child:
                            CircularProgressIndicator(color: Colors.blueAccent),
                      )
                    : IconButton(
                        onPressed: () {
                          setState(() {
                            _validateTitle = title.text.isEmpty;
                            _validateContent = content.text.isEmpty;
                          });

                          if (!_validateTitle && !_validateContent) {
                            context.read<NoteBloc>().add(UpdateNoteEvent(Notes(
                                id: state.notes.id,
                                title: title.text,
                                content: content.text,
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
                    controller: title,
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
                      controller: content,
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
        }
        return Container();
      },
    );
  }
}
