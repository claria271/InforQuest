class MaterialSection {
  final String id;
  final int levelId;
  final int order;
  final String title;
  final String content;

  const MaterialSection({
    required this.id,
    required this.levelId,
    required this.order,
    required this.title,
    required this.content,
  });

  factory MaterialSection.fromJson(Map<String, dynamic> json) {
    return MaterialSection(
      id: json['id'] as String,
      levelId: json['levelId'] as int,
      order: json['order'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'levelId': levelId,
      'order': order,
      'title': title,
      'content': content,
    };
  }
}
