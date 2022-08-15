class Organization {
  String id;
  String name;
  String email;
  String location;
  String phone;
  String description;
  String services;
  String userId;
  bool? emailVerified;
  String logo;

  Organization({
    required this.id,
    required this.name,
    required this.email,
    required this.logo,
    required this.userId,
    this.location = "",
    this.description = "",
    this.services = "",
    this.phone = "",
  });

  Organization.fromJson(Map<String, dynamic> json)
      : id = json['organization']['id'].toString(),
        name = json['name'],
        email = json['email'],
        location = json['organization']['location'] ?? "Not available",
        phone = json['organization']['phone'] ?? "Not available",
        description = json['organization']['description'] ?? "Not available",
        services = json['organization']['services'] ?? "Not available",
        userId = json['id'].toString(),
        emailVerified = json['email_verified_at'] != null ? true : false,
        logo = json['avatar'] != null
            ? json['avatar']
            : "https://ui-avatars.com/api/?background=random&size=500&name=" +
                json['name'].toString().trim().toLowerCase();
}
