class Word {
  final String word;

  Word({
    required this.word,
  });

  Word.fromMap(Map<String, dynamic> res) : word = res["word"];

  Map<String, Object?> toMap() {
    return {
      'word': word,
    };
  }
}
