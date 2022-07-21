class Daily {
  final int id;
  final String date;
  final String word;
  final bool? success;
  final List<String>? words;

  Daily({
    required this.id,
    required this.date,
    required this.word,
    required this.success,
    required this.words,
  });

  Daily.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        date = res['date'],
        word = res['word'],
        success = res['success'] == 1
            ? true
            : res['success'] == 0
                ? false
                : null,
        words = res['words']?.split(',');

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'date': date,
      'word': word,
      'success': success == true
          ? '1'
          : success == false
              ? '0'
              : null,
      'words': words?.join(',')
    };
  }
}
