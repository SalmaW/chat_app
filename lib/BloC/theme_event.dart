import 'package:flutter/material.dart';

@immutable
sealed class ThemeEvent {}

final class ToggleThemeEvent extends ThemeEvent {}
