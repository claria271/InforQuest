class QuestionModel {
  final String id;
  final int levelId;
  final String type;
  final String text;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  const QuestionModel({
    required this.id,
    required this.levelId,
    required this.type,
    required this.text,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'] as String,
      levelId: json['levelId'] as int,
      type: json['type'] as String? ?? 'multiple_choice',
      text: json['text'] as String,
      options: List<String>.from(json['options'] as List),
      correctIndex: json['correctIndex'] as int,
      explanation: json['explanation'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'levelId': levelId,
      'type': type,
      'text': text,
      'options': options,
      'correctIndex': correctIndex,
      'explanation': explanation,
    };
  }
}
