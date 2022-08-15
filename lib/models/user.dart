import 'course.dart';
import 'set.dart';
import 'setCategory.dart';

class User {
  String id;
  String name;
  String email;
  bool? emailVerified;
  String avatar;
  List<SetCategory?> followedSetCategories = [];
  List<Set?> followedSets = [];
  List<Course?> followedCourses = [];

  User(
      {required this.id,
      required this.name,
      required this.email,
      required this.avatar,
      this.followedSetCategories = const [],
      this.followedCourses = const [],
      this.followedSets = const []});

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'].toString(),
        name = json['name'],
        email = json['email'],
        emailVerified = json['email_verified_at'] != null ? true : false,
        avatar = json['avatar'] != null
            ? json['avatar']
            : "https://ui-avatars.com/api/?background=random&size=500&name=" +
                json['name'].toString().trim().toLowerCase(),
        followedSetCategories = json['set_categories'] != null
            ? json['set_categories']
                .map<SetCategory?>((cat) {
                  try {
                    return SetCategory.fromJson(cat);
                  } on Exception {
                    return null;
                  }
                })
                .where((cat) => cat != null)
                .toList()
            : [],
        followedSets = json['sets'] != null
            ? json['sets']
                .map<Set?>((cat) {
                  try {
                    return Set.fromJson(cat);
                  } on Exception {
                    return null;
                  }
                })
                .where((set) => set != null)
                .toList()
            : [],
        followedCourses = json['courses'] != null
            ? json['courses']
                .map<Course?>((course) {
                  try {
                    return Course.fromJson(course);
                  } on Exception {
                    return null;
                  }
                })
                .where((course) => course != null)
                .toList()
            : [];
}
