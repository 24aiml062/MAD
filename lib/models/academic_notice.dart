/// Data model representing an Academic Notice / University Announcement
/// retrieved dynamically from a remote RESTful API.
class AcademicNotice {
  final int id;
  final String title;
  final String body;
  final String category;
  final String date;
  final String author;
  final String? imageUrl;

  const AcademicNotice({
    required this.id,
    required this.title,
    required this.body,
    required this.category,
    required this.date,
    required this.author,
    this.imageUrl,
  });

  /// Constructs an AcademicNotice from JSON response payload.
  factory AcademicNotice.fromJson(Map<String, dynamic> json) {
    // Map remote API fields (e.g. from jsonplaceholder or dummyjson)
    final id = json['id'] as int? ?? 1;
    final rawTitle = json['title'] as String? ?? 'University Announcement';
    final rawBody = json['body'] as String? ?? '';

    // Assign realistic academic categories based on ID or keywords
    final categories = [
      'Exam',
      'Placement',
      'Academic',
      'Tech Fest',
      'Workshop',
    ];
    final category = categories[id % categories.length];

    final dates = [
      '25 Oct 2026',
      '24 Oct 2026',
      '22 Oct 2026',
      '20 Oct 2026',
      '18 Oct 2026',
    ];
    final date = dates[id % dates.length];

    final authors = [
      'CHARUSAT Examination Cell',
      'Training & Placement Cell (T&P)',
      'Department of AI & ML',
      'Student Affairs Council',
      'Academic Section - FTE',
    ];
    final author = authors[id % authors.length];

    // Clean and capitalize title for academic presentation
    final formattedTitle = rawTitle.length > 50
        ? '${rawTitle.substring(0, 48)}...'
        : rawTitle[0].toUpperCase() + rawTitle.substring(1);

    return AcademicNotice(
      id: id,
      title: formattedTitle,
      body: rawBody,
      category: category,
      date: date,
      author: author,
    );
  }

  /// Converts AcademicNotice to JSON Map for serialization or local cache.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'category': category,
      'date': date,
      'author': author,
      if (imageUrl != null) 'image_url': imageUrl,
    };
  }
}

/// Data model representing student feedback or event registration submitted via HTTP POST.
class StudentFeedbackSubmission {
  final String studentName;
  final String email;
  final String category;
  final String message;

  const StudentFeedbackSubmission({
    required this.studentName,
    required this.email,
    required this.category,
    required this.message,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': 'Feedback: $category from $studentName',
      'body': message,
      'userId': 1,
      'studentName': studentName,
      'email': email,
      'category': category,
    };
  }
}
