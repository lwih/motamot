class Daily {
  final String date;
  final String word;
  final bool? success;
  final List<String>? words;

  Daily({
    required this.date,
    required this.word,
    required this.success,
    required this.words,
  });

  Daily.fromMap(Map<String, dynamic> res)
      : date = res['date'],
        word = res['word'],
        success = res['success'] == 1
            ? true
            : res['success'] == 0
                ? false
                : null,
        words = res['words']?.split(',');

  Map<String, Object?> toMap() {
    return {
      'date': date,
      'word': word,
      'success': success == true ? '1' : '0',
      'attempts': words.toString()
    };
  }
}
