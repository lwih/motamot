class Lemme {
  final String lemme;

  Lemme({
    required this.lemme,
  });

  Lemme.fromMap(Map<String, dynamic> res) : lemme = res["lemme"];

  Map<String, Object?> toMap() {
    return {
      'lemme': lemme,
    };
  }
}
