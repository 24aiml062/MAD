enum AiPromptCategory {
  general,
  summarize,
  qa,
  studyPlan,
  resources,
  translate,
}

class AiMessage {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final AiPromptCategory category;
  final List<String> suggestedActions;
  final int? processingTimeMs;
  final int? tokenCount;
  final bool isOffline;

  AiMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.category = AiPromptCategory.general,
    this.suggestedActions = const [],
    this.processingTimeMs,
    this.tokenCount,
    this.isOffline = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'isUser': isUser ? 1 : 0,
      'timestamp': timestamp.toIso8601String(),
      'category': category.name,
      'processingTimeMs': processingTimeMs,
      'tokenCount': tokenCount,
      'isOffline': isOffline ? 1 : 0,
    };
  }

  factory AiMessage.fromMap(Map<String, dynamic> map) {
    return AiMessage(
      id: map['id'] as String,
      text: map['text'] as String,
      isUser: (map['isUser'] as int) == 1,
      timestamp: DateTime.parse(map['timestamp'] as String),
      category: AiPromptCategory.values.firstWhere(
        (e) => e.name == map['category'],
        orElse: () => AiPromptCategory.general,
      ),
      processingTimeMs: map['processingTimeMs'] as int?,
      tokenCount: map['tokenCount'] as int?,
      isOffline: (map['isOffline'] as int? ?? 1) == 1,
    );
  }
}
