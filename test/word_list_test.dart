import 'package:flutter_test/flutter_test.dart';
import 'package:wordle/wordle/data/word_list.dart';

void main() {
  test('normaliza palavras removendo acentos para o jogo', () {
    expect(normalizeFiveLetterWord('aarão'), 'AARAO');
    expect(normalizeFiveLetterWord('cação'), 'CACAO');
  });

  test('mantém forma acentuada para revelar no resultado final', () async {
    await loadFiveLetterWords();

    expect(isValidFiveLetterWord('AARAO'), isTrue);
    expect(getDisplayWordForResult('AARAO'), 'AARÃO');
  });
}
