import 'setCategory.dart';
import 'user.dart';

class Course {
  final int id;
  final String title;
  final String? description;
  final String? tags;
  final String code;
  final List<SetCategory>? subjects;
  final User publisher;

  Course(
      {required this.id,
      required this.title,
      this.description,
      this.tags,
      required this.code,
      required this.publisher,
      this.subjects = const []});

  Course.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        description = json['description'],
        tags = json['tags'],
        code = json['code'],
        subjects = json['subjects'] != null
            ? json['subjects']
                .map<SetCategory>((subject) => SetCategory.fromJson(subject))
                .toList()
            : [],
        publisher = User.fromJson(json['publisher']);
}
