import 'summary_question.dart';

class Summary {
  final int id;
  final List<SummaryQuestion> questions;

  Summary({required this.id, required this.questions});

  Summary.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        questions = json["questions"]
            .map((question) => SummaryQuestion.fromJson(question))
            .toList()
            .cast<SummaryQuestion>();
}
