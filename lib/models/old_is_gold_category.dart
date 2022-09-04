import 'old_is_gold_question.dart';

class OldIsGoldCategory {
  final int id;
  final String title;
  final List<OldIsGoldQuestion> questions;

  OldIsGoldCategory(
      {required this.id, required this.title, required this.questions});

  OldIsGoldCategory.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        questions = json['questions'] != null
            ? json['questions']
                .map<OldIsGoldQuestion>(
                    (question) => OldIsGoldQuestion.fromJson(question))
                .toList()
            : [];
}
