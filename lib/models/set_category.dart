import 'course.dart';
import 'set.dart';
import 'user.dart';

class SetCategory {
  final int id;
  final String title;
  final String? description;
  final String? tags;
  final String code;
  final List<Set>? sets;
  final User publisher;
  final Course? course;

  SetCategory(
      {required this.id,
      required this.title,
      this.description,
      this.tags,
      required this.code,
      required this.publisher,
      this.course,
      this.sets = const []});

  SetCategory.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        description = json['description'],
        tags = json['tags'],
        code = json['code'],
        sets = json['sets'] != null
            ? json['sets'].map<Set>((set) => Set.fromJson(set)).toList()
            : [],
        publisher = User.fromJson(json['publisher']),
        course =
            json['course'] != null ? Course.fromJson(json['course']) : null;
}
