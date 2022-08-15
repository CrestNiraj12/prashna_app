class SummaryQuestion {
  final int id;
  final String question;
  final String answer;
  int action = 1;
  final bool isLiked;

  SummaryQuestion({
    required this.id,
    required this.question,
    required this.answer,
    required this.isLiked,
    this.action = 1,
  });

  SummaryQuestion.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        question = json['question'],
        answer = json['answer'],
        isLiked = false;
}
