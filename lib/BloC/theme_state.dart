import 'package:flutter/material.dart';

@immutable
sealed class ThemeState {}

final class ThemeInitial extends ThemeState {}

final class ThemeLightMode extends ThemeState {}

final class ThemeDarkMode extends ThemeState {}
