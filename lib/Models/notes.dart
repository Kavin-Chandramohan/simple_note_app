import 'package:equatable/equatable.dart';

class Notes extends Equatable {
  final int? id;
  final String title;
  final String content;
  final String createdAt;

  const Notes({
    this.id,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  // Corrected fromMap constructor
  Notes.fromMap(Map<String, dynamic> json)
      : id = json["id"],
        title = json["title"],
        content = json["content"],
        createdAt = json["createdAt"];

  // Correct toMap method
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt,
    };
  }

  @override
  List<Object?> get props => [id, title, content, createdAt];
}
