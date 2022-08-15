class QuizQuestion {
  final int id;
  final int index;
  final String question;
  final String? questionImage;
  final String correctOption;
  final List<String> options;
  final String? hint;
  final String? hintImage;
  final double marksPerQuestion;
  final bool richText;

  QuizQuestion(
      {required this.id,
      required this.index,
      required this.question,
      required this.correctOption,
      required this.options,
      this.hint,
      this.questionImage,
      this.hintImage,
      required this.marksPerQuestion,
      this.richText = false});

  QuizQuestion.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        index = json['index'],
        question = json['question'],
        questionImage = json['questionImage'],
        correctOption = json['correctOption'],
        options = [
          json['option1'],
          json['option2'],
          json['option3'],
          json['correctOption']
        ],
        hint = json['hint'],
        hintImage = json['hintImage'],
        marksPerQuestion = json['marksPerQuestion'].toDouble(),
        richText = json['richText'] == 1;
}
