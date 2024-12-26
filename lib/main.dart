import 'package:chat_app/constant/themes/light_mode.dart';
import 'package:chat_app/services/auth/auth_gate.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'BloC/theme_bloc.dart';
import 'BloC/theme_state.dart';
import 'constant/themes/dark_mode.dart';
import 'constant/themes/theme_provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeBloc(),
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          ThemeData theme = state is ThemeDarkMode ? darkMode : lightMode;
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: theme,
            home: const AuthGate(),
          );
        },
      ),
    );
  }
}
