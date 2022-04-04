class Sprint {
  final String date;
  final List<String> words;
  final int? score;
  final List<String>? wordsInProgress;
  final int? timeLeftInSeconds;

  Sprint({
    required this.date,
    required this.words,
    required this.score,
    required this.wordsInProgress,
    required this.timeLeftInSeconds,
  });

  Sprint.fromMap(Map<String, dynamic> res)
      : date = res['date'],
        words = res['words'].split(','),
        score = res['score'],
        timeLeftInSeconds = res['timeLeftInSeconds'],
        wordsInProgress = res['wordsInProgress']?.split(',');

  Map<String, Object?> toMap() {
    return {
      'date': date,
      'words': words.join(','),
      'score': score,
      'timeLeftInSeconds': timeLeftInSeconds,
      'wordsInProgress': wordsInProgress?.join(',')
    };
  }
}
