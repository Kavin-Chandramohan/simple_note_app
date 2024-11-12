import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_note_app/Bloc/note_bloc.dart';
import 'package:simple_note_app/DatabaseHandler/repository.dart';
import 'package:simple_note_app/ThemeBloc/theme_bloc.dart';
import 'package:simple_note_app/Views/notes.dart';
import 'package:simple_note_app/Views/themes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NoteBloc(Repository())..add(GetAllNoteEvent()),
        ),
        BlocProvider(
          create: (context) => ThemeBloc(),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Note App',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: themeState is LightThemeState
                ? ThemeMode.light
                : ThemeMode.dark,
            home: const AllNotes(),
          );
        },
      ),
    );
  }
}
