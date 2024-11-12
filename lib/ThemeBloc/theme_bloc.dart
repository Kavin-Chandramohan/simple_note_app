import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ThemeEvent
sealed class ThemeEvent extends Equatable {
  const ThemeEvent();
}

// Event for toggling the theme
class ToggleThemeEvent extends ThemeEvent {
  @override
  List<Object?> get props => [];
}

// ThemeState
sealed class ThemeState extends Equatable {
  final ThemeData themeData;
  const ThemeState(this.themeData);

  @override
  List<Object?> get props => [themeData];
}

// Light Theme State
final class LightThemeState extends ThemeState {
  LightThemeState() : super(ThemeData.light());
}

// Dark Theme State
final class DarkThemeState extends ThemeState {
  DarkThemeState() : super(ThemeData.dark());
}

// ThemeBloc
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(LightThemeState()) {
    _loadThemePreference();

    on<ToggleThemeEvent>((event, emit) {
      if (state is LightThemeState) {
        emit(DarkThemeState());
        _saveThemePreference(false); // false for dark theme
      } else {
        emit(LightThemeState());
        _saveThemePreference(true); // true for light theme
      }
    });
  }

  // Load the theme preference
  void _loadThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLightTheme = prefs.getBool('isLightTheme') ?? true; // Default to light theme

    // Emit the initial state based on the saved preference
    if (isLightTheme) {
      emit(LightThemeState()); // Directly emit LightThemeState
    } else {
      emit(DarkThemeState()); // Directly emit DarkThemeState
    }
  }

  // Save the theme preference
  Future<void> _saveThemePreference(bool isLightTheme) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLightTheme', isLightTheme);
  }
}
