import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

const String _wordsAssetPath = 'assets/words/five_letter_words.txt';
final RegExp _onlyLetters = RegExp(r'^[A-Z]{5}$');
const List<String> _fallbackFiveLetterWords = <String>[
  'AMIGO',
  'AMORA',
  'AREIA',
  'BOLSA',
  'BRISA',
  'CARRO',
  'CASAL',
  'CHAVE',
  'FESTA',
  'FOLHA',
  'FORTE',
  'FRUTA',
  'JOGAR',
  'LIVRO',
  'MUNDO',
  'NOITE',
  'PEDRA',
  'PLENO',
  'PRATO',
  'SABER',
  'SALTO',
  'SONHO',
  'TEMPO',
  'TERNO',
  'VIVER',
];

bool _wordsLoaded = false;

final List<String> fiveLetterWords = <String>[];
final Set<String> _fiveLetterWordsLookup = <String>{};

Future<void> loadFiveLetterWords() async {
  if (_wordsLoaded) return;

  String rawWords;
  try {
    rawWords = await rootBundle.loadString(_wordsAssetPath);
  } on FlutterError {
    fiveLetterWords
      ..clear()
      ..addAll(_fallbackFiveLetterWords);
    _fiveLetterWordsLookup
      ..clear()
      ..addAll(fiveLetterWords);
    _wordsLoaded = true;
    return;
  }

  final uniqueWords = <String>{};

  for (final line in rawWords.split(RegExp(r'\r?\n'))) {
    final normalized = line.trim().toUpperCase();
    if (_onlyLetters.hasMatch(normalized)) {
      uniqueWords.add(normalized);
    }
  }

  if (uniqueWords.isEmpty) {
    fiveLetterWords
      ..clear()
      ..addAll(_fallbackFiveLetterWords);
    _fiveLetterWordsLookup
      ..clear()
      ..addAll(fiveLetterWords);
    _wordsLoaded = true;
    return;
  }

  fiveLetterWords
    ..clear()
    ..addAll(uniqueWords);
  _fiveLetterWordsLookup
    ..clear()
    ..addAll(fiveLetterWords);
  _wordsLoaded = true;
}

bool isValidFiveLetterWord(String word) {
  final normalized = word.trim().toUpperCase();
  return _fiveLetterWordsLookup.contains(normalized);
}
