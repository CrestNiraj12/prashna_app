class SummaryFile {
  final int id;
  final String file;

  SummaryFile({required this.id, required this.file});

  SummaryFile.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        file = json["file"];
}
