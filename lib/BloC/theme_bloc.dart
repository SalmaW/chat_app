import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  bool isDarkMode = false;

  ThemeBloc() : super(ThemeLightMode()) {
    on<ToggleThemeEvent>((event, emit) {
      isDarkMode = !isDarkMode;
      if (isDarkMode) {
        emit(ThemeDarkMode());
      } else {
        emit(ThemeLightMode());
      }
    });
  }
}
