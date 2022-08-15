import 'oldIsGoldCategory.dart';

class OldIsGold {
  final int id;
  final String title;
  final String description;
  final List<OldIsGoldCategory> categories;
  final String? facebook;
  final String? whatsapp;
  final String? instagram;
  final String? twitter;

  OldIsGold(
      {required this.id,
      required this.title,
      required this.description,
      required this.categories,
      this.facebook,
      this.whatsapp,
      this.instagram,
      this.twitter});

  OldIsGold.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        description = json['description'],
        categories = json['categories'] != null
            ? json['categories']
                .map<OldIsGoldCategory>(
                    (cat) => OldIsGoldCategory.fromJson(cat))
                .toList()
            : [],
        facebook = json['facebook'],
        whatsapp = json['whatsapp'],
        instagram = json['instagram'],
        twitter = json['twitter'];
}
