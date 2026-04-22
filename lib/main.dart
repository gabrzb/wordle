import 'package:flutter/material.dart';
import 'package:wordle/app/app.dart';
import 'package:wordle/wordle/data/word_list.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadFiveLetterWords();
  runApp(const App());
}
