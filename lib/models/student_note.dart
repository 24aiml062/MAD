/// Data model representing an academic note in the SQLite Database.
class StudentNote {
  final int? id;
  final String title;
  final String description;
  final String subject;
  final String createdDate;

  const StudentNote({
    this.id,
    required this.title,
    required this.description,
    required this.subject,
    required this.createdDate,
  });

  /// Converts StudentNote object to Map for SQLite database insertion/updating.
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'title': title,
      'description': description,
      'subject': subject,
      'created_date': createdDate,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  /// Constructs StudentNote object from SQLite query Map result.
  factory StudentNote.fromMap(Map<String, dynamic> map) {
    return StudentNote(
      id: map['id'] as int?,
      title: map['title'] as String,
      description: map['description'] as String,
      subject: map['subject'] as String,
      createdDate: map['created_date'] as String,
    );
  }

  /// Creates a modified copy of the current note.
  StudentNote copyWith({
    int? id,
    String? title,
    String? description,
    String? subject,
    String? createdDate,
  }) {
    return StudentNote(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      subject: subject ?? this.subject,
      createdDate: createdDate ?? this.createdDate,
    );
  }
}
