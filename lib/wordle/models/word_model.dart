import 'package:equatable/equatable.dart';
import 'package:wordle/wordle/models/letter_model.dart';

class Word extends Equatable {
  const Word({ required this.letters });

  factory Word.fromString(String word) {
    return Word(
      letters: word.split('').map((e) => Letter(val: e)).toList(),
    );
  }

  final List<Letter> letters;
  
  String get wordString => letters.map((e) => e.val).join();

  void addLetter(String letter) {
    final currentIndex = letters.indexWhere((e) => e.val.isEmpty);
    if (currentIndex != -1) {
      letters[currentIndex] = Letter(val: letter);
    }
  }

  void removeLetter() {
    final lastIndex = letters.lastIndexWhere((e) => e.val.isNotEmpty);
    if (lastIndex != -1) {
      letters[lastIndex] = Letter.empty();
    }
  }

  @override
  List<Object?> get props => [letters];
}
