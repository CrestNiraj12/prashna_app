class OldIsGoldQuestion {
  final int id;
  final int index;
  final String question;
  final String? year;
  final String? questionNumber;
  final double? marks;
  final bool richText;

  OldIsGoldQuestion(
      {required this.id,
      required this.index,
      required this.question,
      this.year,
      this.questionNumber,
      this.marks,
      this.richText = false});

  OldIsGoldQuestion.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        index = json['index'],
        question = json['question'],
        year = json['year'],
        questionNumber = json['questionNumber'],
        marks = json['marks'] != null ? json['marks'].toDouble() : null,
        richText = json['richText'] == 1;
}
