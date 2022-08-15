import 'setCategory.dart';
import 'user.dart';

class Set {
  final int id;
  final String title;
  final String? description;
  final String? tags;
  final String? image;
  final List<dynamic>? terms;
  final List<dynamic>? flashCards;
  final SetCategory? category;
  final User? publisher;

  Set(
      {required this.id,
      required this.title,
      this.description,
      this.tags,
      this.image,
      this.terms,
      this.flashCards,
      this.publisher,
      required this.category});

  Set.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        description = json['description'],
        tags = json['tags'],
        image = json['image'],
        terms = json['terms'],
        flashCards = json['flash_cards'],
        publisher =
            json['publisher'] != null ? User.fromJson(json['publisher']) : null,
        category = json["category"] != null
            ? SetCategory.fromJson(json["category"])
            : null;
}
