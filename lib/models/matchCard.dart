class MatchCard {
  final int id;
  final String data;
  bool matched = false;
  String? bgImage;
  bool? incorrect;
  bool selected = false;

  MatchCard({required this.id, required this.data, this.bgImage});
  void setSelected(bool selected) {
    this.selected = selected;
  }

  void setMatched(bool isMatched) {
    this.matched = isMatched;
  }

  void setIncorrect(bool? incorrect) {
    this.incorrect = incorrect;
  }

  int getId() => id;
  String getData() => data;
  bool get isMatched => matched;
  String? get getBgImage => bgImage;
  bool? get isIncorrect => incorrect;
  bool get isSelected => selected;
}
