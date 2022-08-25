import 'user.dart';
import 'package:timeago/timeago.dart' as timeago;

class Quiz {
  final int id;
  final String title;
  final String description;
  final double totalMarks, passMarks, negativeMarking;
  final User publisher;
  final List questions;
  final String createdAt;

  Quiz(
      {required this.id,
      required this.title,
      required this.description,
      required this.totalMarks,
      required this.passMarks,
      required this.negativeMarking,
      required this.questions,
      required this.publisher,
      required this.createdAt});

  Quiz.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        description = json['description'],
        totalMarks = json['totalMarks'].toDouble(),
        passMarks = json['passMarks'].toDouble(),
        negativeMarking = json['negativeMarking'].toDouble(),
        questions = json['quiz_questions'],
        publisher = User.fromJson(json['set']['category']['publisher']),
        createdAt = timeago.format(DateTime.parse(json['created_at']));
}
