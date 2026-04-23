import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

const String _wordsAssetPath = 'assets/words/five_letter_words.txt';
final RegExp _onlyLetters = RegExp(r'^[A-Z]{5}$');
final RegExp _diacriticRegex = RegExp(
  r'[ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÑÒÓÔÕÖÙÚÛÜÝŸŒ]',
);
const Map<String, String> _diacriticMap = <String, String>{
  'À': 'A',
  'Á': 'A',
  'Â': 'A',
  'Ã': 'A',
  'Ä': 'A',
  'Å': 'A',
  'Æ': 'AE',
  'Ç': 'C',
  'È': 'E',
  'É': 'E',
  'Ê': 'E',
  'Ë': 'E',
  'Ì': 'I',
  'Í': 'I',
  'Î': 'I',
  'Ï': 'I',
  'Ñ': 'N',
  'Ò': 'O',
  'Ó': 'O',
  'Ô': 'O',
  'Õ': 'O',
  'Ö': 'O',
  'Ù': 'U',
  'Ú': 'U',
  'Û': 'U',
  'Ü': 'U',
  'Ý': 'Y',
  'Ÿ': 'Y',
  'Œ': 'OE',
};
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
final Map<String, String> _displayWordByNormalized = <String, String>{};

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
    _displayWordByNormalized
      ..clear()
      ..addEntries(fiveLetterWords.map((word) => MapEntry(word, word)));
    _wordsLoaded = true;
    return;
  }

  final uniqueWords = <String>{};
  _displayWordByNormalized.clear();

  for (final line in rawWords.split(RegExp(r'\r?\n'))) {
    final displayWord = line.trim().toUpperCase();
    final normalized = normalizeFiveLetterWord(displayWord);
    if (_onlyLetters.hasMatch(normalized)) {
      uniqueWords.add(normalized);
      final existingDisplayWord = _displayWordByNormalized[normalized];
      if (existingDisplayWord == null ||
          (!_containsDiacritics(existingDisplayWord) &&
              _containsDiacritics(displayWord))) {
        _displayWordByNormalized[normalized] = displayWord;
      }
    }
  }

  if (uniqueWords.isEmpty) {
    fiveLetterWords
      ..clear()
      ..addAll(_fallbackFiveLetterWords);
    _fiveLetterWordsLookup
      ..clear()
      ..addAll(fiveLetterWords);
    _displayWordByNormalized
      ..clear()
      ..addEntries(fiveLetterWords.map((word) => MapEntry(word, word)));
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
  final normalized = normalizeFiveLetterWord(word);
  return _fiveLetterWordsLookup.contains(normalized);
}

String normalizeFiveLetterWord(String word) {
  final upperWord = word.trim().toUpperCase();
  return upperWord.replaceAllMapped(
    _diacriticRegex,
    (match) => _diacriticMap[match.group(0)!] ?? match.group(0)!,
  );
}

String getDisplayWordForResult(String normalizedWord) {
  final normalized = normalizeFiveLetterWord(normalizedWord);
  return _displayWordByNormalized[normalized] ?? normalized;
}

bool _containsDiacritics(String word) => _diacriticRegex.hasMatch(word);
