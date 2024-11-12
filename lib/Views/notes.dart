import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:simple_note_app/Bloc/note_bloc.dart';
import 'package:simple_note_app/ThemeBloc/theme_bloc.dart';
import 'package:simple_note_app/Views/add_note.dart';
import 'package:simple_note_app/Views/show_note.dart';

class AllNotes extends StatefulWidget {
  const AllNotes({super.key});

  @override
  State<AllNotes> createState() => _AllNotesState();
}

class _AllNotesState extends State<AllNotes> {
  String searchQuery = "";

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<NoteBloc>().add(GetAllNoteEvent());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddNote()));
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      appBar: AppBar(
        title: const Text(
          "My Notes",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, fontFamily: 'Lora'),
        ),
        centerTitle: true,
        actions: [
          BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, themeState) {
              return IconButton(
                  onPressed: () {
                    context.read<ThemeBloc>().add(ToggleThemeEvent());
                  },
                  icon: Icon(
                    themeState is LightThemeState
                        ? Icons.dark_mode
                        : Icons.light_mode,
                    color: themeState is LightThemeState
                        ? Colors.grey[700]
                        : Colors.yellow,
                  ));
            },
          )
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, themeState) {
              // Access colors from your theme
              final textColor = themeState is LightThemeState
                  ? Colors.grey[600]
                  : Colors.grey[400];
              final hintStyleColor = themeState is LightThemeState
                  ? Colors.grey[600]
                  : Colors.grey[400];
              final prefixIconColor = themeState is LightThemeState
                  ? Colors.grey[600]
                  : Colors.grey[400];
              final fillColor = themeState is LightThemeState
                  ? Colors.grey[300]
                  : Colors.grey[600];

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: TextField(
                  onChanged: (query) {
                    setState(() {
                      searchQuery = query;
                    });
                    context.read<NoteBloc>().add(SearchNotesEvent(query));
                  },
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textColor),
                  decoration: InputDecoration(
                    hintText: "Search notes by title...",
                    hintStyle: TextStyle(color: hintStyleColor),
                    prefixIcon: Icon(Icons.search, color: prefixIconColor),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: fillColor,
                  ),
                ),
              );
            },
          ),
          Expanded(
            child: BlocConsumer<NoteBloc, NoteState>(
              listener: (context, state) {
                if (state is GetNoteByIdState) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ShowNote()),
                  ).then((result) {
                    if (result == true) {
                      // Reload notes after returning from ShowNote page
                      context.read<NoteBloc>().add(GetAllNoteEvent());
                    }
                  });
                }
              },
              builder: (context, state) {
                if (state is LoadedState) {
                  return state.allNotes.isEmpty
                      ? const Center(
                          child: Text(
                            "No notes available.",
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          itemCount: state.allNotes.length,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                context.read<NoteBloc>().add(GetNoteByIdEvent(
                                    state.allNotes[index].id!));
                              },
                              child: Card(
                                elevation: 3,
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 16),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color:
                                            Colors.blueAccent.withOpacity(0.2),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.notes,
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                    title: Text(
                                      state.allNotes[index].title,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18),
                                    ),
                                    subtitle: Text(
                                      dateFormat(
                                          state.allNotes[index].createdAt),
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    ),
                                    trailing: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.grey[400],
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String dateFormat(String date) {
    final DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    return dateFormat.format(DateTime.parse(date));
  }
}
