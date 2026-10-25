import 'dart:math';
import '../models/ai_message.dart';

class AiAssistantService {
  static final AiAssistantService _instance = AiAssistantService._internal();
  factory AiAssistantService() => _instance;
  AiAssistantService._internal();

  final String modelName = 'Gemini Nano (AICore 4-bit Quantized)';
  final String sdkVersion = 'Google AI Edge SDK 1.2.0';
  final bool isOnDevice = true;

  /// Quick Prompt Templates supported by the Smart Academic Assistant
  static const List<Map<String, dynamic>> promptTemplates = [
    {
      'title': 'Summarize Notes',
      'icon': 'notes',
      'category': AiPromptCategory.summarize,
      'prompt':
          'Summarize today\'s lecture on Flutter Widgets & State Management.',
    },
    {
      'title': 'Explain Concept',
      'icon': 'school',
      'category': AiPromptCategory.qa,
      'prompt': 'Explain Stateful vs Stateless Widget with lifecycle details.',
    },
    {
      'title': 'Exam Study Plan',
      'icon': 'event_note',
      'category': AiPromptCategory.studyPlan,
      'prompt': 'Generate a 5-day revision plan for AIUE302 MAD examination.',
    },
    {
      'title': 'Learning Resources',
      'icon': 'menu_book',
      'category': AiPromptCategory.resources,
      'prompt':
          'Suggest official learning resources and tutorials for Flutter & Dart.',
    },
    {
      'title': 'Translate to Hindi/Gujarati',
      'icon': 'translate',
      'category': AiPromptCategory.translate,
      'prompt': 'Translate core Flutter concepts into Hindi and Gujarati.',
    },
    {
      'title': 'Interview Prep',
      'icon': 'quiz',
      'category': AiPromptCategory.qa,
      'prompt':
          'List top 5 Flutter & Mobile AI interview questions with answers.',
    },
  ];

  /// Core inference method modeling Google AI Edge on-device processing
  Future<AiMessage> generateResponse({
    required String prompt,
    AiPromptCategory category = AiPromptCategory.general,
  }) async {
    final startTime = DateTime.now();

    // Simulate fast on-device NPU/GPU execution latency (typically 120ms - 260ms on Gemini Nano)
    final randomLatency = 130 + Random().nextInt(110);
    await Future.delayed(Duration(milliseconds: randomLatency));

    final normalized = prompt.trim().toLowerCase();
    String responseText = '';
    AiPromptCategory matchedCategory = category;
    List<String> actions = [];

    if (matchedCategory == AiPromptCategory.summarize ||
        normalized.contains('summar') ||
        normalized.contains('notes')) {
      matchedCategory = AiPromptCategory.summarize;
      responseText = _generateSummaryResponse(prompt);
      actions = ['View Code Sample', 'Generate Quiz', 'Save to Notes'];
    } else if (matchedCategory == AiPromptCategory.studyPlan ||
        normalized.contains('study plan') ||
        normalized.contains('revision') ||
        normalized.contains('timetable') ||
        normalized.contains('schedule')) {
      matchedCategory = AiPromptCategory.studyPlan;
      responseText = _generateStudyPlanResponse(prompt);
      actions = ['Set Task Reminders', 'Export PDF', 'Adjust Hours'];
    } else if (matchedCategory == AiPromptCategory.resources ||
        normalized.contains('resource') ||
        normalized.contains('book') ||
        normalized.contains('tutorial') ||
        normalized.contains('documentation')) {
      matchedCategory = AiPromptCategory.resources;
      responseText = _generateResourcesResponse(prompt);
      actions = ['Open Docs', 'Save Bookmark', 'Explore Roadmap'];
    } else if (matchedCategory == AiPromptCategory.translate ||
        normalized.contains('translat') ||
        normalized.contains('hindi') ||
        normalized.contains('gujarati')) {
      matchedCategory = AiPromptCategory.translate;
      responseText = _generateTranslationResponse(prompt);
      actions = ['Copy Hindi', 'Copy Gujarati', 'Audio Pronunciation'];
    } else if (normalized.contains('stateful') ||
        normalized.contains('stateless') ||
        normalized.contains('lifecycle')) {
      matchedCategory = AiPromptCategory.qa;
      responseText = _generateStatefulVsStatelessResponse();
      actions = ['Lifecycle Diagram', 'Code Example', 'Interview Tips'];
    } else if (normalized.contains('interview') ||
        normalized.contains('question') ||
        normalized.contains('top 5')) {
      matchedCategory = AiPromptCategory.qa;
      responseText = _generateInterviewQuestionsResponse();
      actions = ['Mock Interview', 'Flashcards', 'Save Q&A'];
    } else if (normalized.contains('sqlite') ||
        normalized.contains('sharedpreference') ||
        normalized.contains('database') ||
        normalized.contains('storage')) {
      matchedCategory = AiPromptCategory.qa;
      responseText = _generateStorageComparisonResponse();
      actions = ['SQLite CRUD Helper', 'Preferences Example'];
    } else if (normalized.contains('rest') ||
        normalized.contains('api') ||
        normalized.contains('http')) {
      matchedCategory = AiPromptCategory.qa;
      responseText = _generateApiResponse();
      actions = ['HTTP Code Cheatsheet', 'Test API Call'];
    } else {
      matchedCategory = AiPromptCategory.qa;
      responseText = _generateGeneralAcademicResponse(prompt);
      actions = ['Explain In Detail', 'Show Example', 'Related Topics'];
    }

    final endTime = DateTime.now();
    final actualLatency = endTime.difference(startTime).inMilliseconds;
    final tokenCount = (responseText.split(RegExp(r'\s+')).length * 1.33)
        .round();

    return AiMessage(
      id: 'ai_${DateTime.now().millisecondsSinceEpoch}',
      text: responseText,
      isUser: false,
      timestamp: DateTime.now(),
      category: matchedCategory,
      suggestedActions: actions,
      processingTimeMs: actualLatency,
      tokenCount: tokenCount,
      isOffline: true,
    );
  }

  String _generateSummaryResponse(String prompt) {
    return '''### 📋 Lecture Summary: Flutter Widgets & State Management

**1. Core Architecture:**
• Flutter builds everything as an immutable **Widget Tree**; UI is declared as a function of state: `UI = f(State)`.
• **StatelessWidget:** Static UI that does not change dynamically over time (e.g., `Text`, `Icon`, `AppBar`).
• **StatefulWidget:** Dynamic UI coupled with a mutable `State` object capable of re-rendering via `setState()`.

**2. State Management Paradigms:**
• **Ephemeral State:** Local widget state managed cleanly with `setState()` or `ValueNotifier`.
• **App State:** Shared global state across multiple routes using `InheritedWidget` or reactive listeners.

**3. Key Performance Best Practices:**
• Mark immutable widgets with `const` to avoid redundant element rebuilding.
• Narrow down `setState()` scope to atomic leaf widgets rather than rebuilding entire screen trees.

💡 **Quick Revision Tip:** Remember the widget lifecycle: `createState()` ➔ `initState()` ➔ `didChangeDependencies()` ➔ `build()` ➔ `dispose()`. Clean up streams and controllers in `dispose()` to prevent memory leaks!''';
  }

  String _generateStudyPlanResponse(String prompt) {
    return '''### 📅 5-Day Exam Revision Plan: AIUE302 MAD (2026–27)

| Day | Focus Modules | Key Practical Topics | Study Time |
| :--- | :--- | :--- | :--- |
| **Day 1** | Dart & Flutter Basics | Dart OOP, Null Safety, Layouts, Row/Column/Stack | 2.5 Hours |
| **Day 2** | UI & State Mgmt | Forms, Validation, `setState()`, `ValueNotifier` | 3.0 Hours |
| **Day 3** | Navigation & Storage | Named Routes, SharedPreferences, SQLite CRUD | 3.5 Hours |
| **Day 4** | REST APIs & AI Edge | HTTP GET/POST, JSON Parsing, Gemini Nano on-device AI | 3.5 Hours |
| **Day 5** | Mock Test & Viva | Viva Voce prep, 10 key questions, code review | 2.0 Hours |

**Daily Target Checklist:**
• [x] Review practical report summaries (Practicals 1 to 8).
• [x] Execute unit tests on local repository (`flutter test`).
• [x] Practice creating custom widgets and state management flow.''';
  }

  String _generateResourcesResponse(String prompt) {
    return '''### 📚 Recommended Learning Resources: Flutter & Mobile AI

**1. Official Documentation & Guides:**
• [Flutter Official Docs](https://docs.flutter.dev): Comprehensive API references, widgets catalog, and architecture guides.
• [Dart Language Tour](https://dart.dev/guides): Null-safety, asynchronous programming with Streams/Futures.
• [Google AI Edge](https://ai.google.dev/edge): On-device ML with MediaPipe, LiteRT, and Gemini Nano.

**2. Recommended Reference Textbooks:**
• *Flutter Apprentice* (Ray Wenderlich Team) — Pragmatic cross-platform mobile architecture.
• *Beginning Flutter: A Hands On Guide to App Development* (Marco L. Napoli) — UI layout patterns.
• *Mobile Artificial Intelligence with TensorFlow Lite & Edge AI* — Edge inference design patterns.

**3. Interactive & Video Channels:**
• Flutter YouTube Channel (Widget of the Week series).
• Google Codelabs for Flutter & Gemini Nano on Android AICore.''';
  }

  String _generateTranslationResponse(String prompt) {
    return '''### 🌐 Multilingual Academic Translation: Core Mobile AI Concepts

**1. English Source:**
*"On-device AI executes machine learning models locally on the smartphone hardware, ensuring zero network latency, complete data privacy, and full offline accessibility."*

**2. Hindi (हिंदी) Translation:**
*"ऑन-डिवाइस एआई (On-device AI) मशीन लर्निंग मॉडल को स्मार्टफोन के लोकल हार्डवेयर (NPU/GPU) पर सीधे निष्पादित करता है। यह शून्य नेटवर्क लेटेंसी, पूर्ण डेटा गोपनीयता (Privacy) और बिना इंटरनेट के ऑफ़लाइन कार्यक्षमता सुनिश्चित करता है।"*

**3. Gujarati (ગુજરાતી) Translation:**
*"ઓન-ડિવાઇસ AI (On-device AI) મશીન લર્નિંગ મોડેલ્સને સ્માર્ટફોનના સ્થાનિક હાર્ડવેર (NPU/GPU) પર સીધું રન કરે છે. આ શૂન્ય નેટવર્ક લેટન્સી, સંપૂર્ણ ડેટા પ્રાઇવસી અને ઇન્ટરનેટ વિના ઑફલાઇન ઉપલબ્ધતા સુનિશ્ચિત કરે છે."*

**Key Terminology Glossary:**
• **Widget:** વિજેટ / विजेट (Building block of UI)
• **State:** સ્થિતિ / स्थिति (Dynamic data)
• **Local Database:** સ્થાનિક ડેટાબેઝ / स्थानीय डेटाबेस (SQLite)''';
  }

  String _generateStatefulVsStatelessResponse() {
    return '''### 💡 Concept Guide: `StatelessWidget` vs `StatefulWidget`

| Feature | `StatelessWidget` | `StatefulWidget` |
| :--- | :--- | :--- |
| **Mutability** | Immutable (Configuration only) | Mutable state held in linked `State` object |
| **Re-render** | Only when parent rebuilds | Can trigger self rebuild via `setState()` |
| **Lifecycle** | `build()` only | `createState()`, `initState()`, `build()`, `dispose()` |
| **Memory** | Very lightweight | Requires additional state instance |
| **Use Case** | Labels, Icons, Badges, Headers | Forms, Checkboxes, Timers, Live Search |

**Code Anatomy:**
```dart
// Stateful Widget Pattern
class CounterWidget extends StatefulWidget {
  const CounterWidget({super.key});
  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int _count = 0;
  void _increment() => setState(() => _count++);
  @override
  Widget build(BuildContext context) => ElevatedButton(
    onPressed: _increment,
    child: Text('Count: \$_count'),
  );
}
```''';
  }

  String _generateInterviewQuestionsResponse() {
    return '''### 🎯 Top 5 Flutter & Mobile AI Interview Questions

**Q1: How does Flutter achieve 60/120 FPS high performance?**
*Ans:* Flutter bypasses native OEM platform UI bridges. It compiles directly to native ARM machine code using the Skia/Impeller rendering engine.

**Q2: What is the difference between `hot reload` and `hot restart`?**
*Ans:* Hot Reload injects updated source code into the running Dart VM preserving existing application state; Hot Restart destroys existing state and restarts the Dart app from `main()`.

**Q3: Why is On-Device AI (Gemini Nano) better for mobile than Cloud LLMs?**
*Ans:* Privacy (user data never leaves the handset), zero server hosting costs, instant real-time response without network latency, and reliable functionality in offline airplane mode.

**Q4: How does `InheritedWidget` work under the hood?**
*Ans:* It allows child widgets in the widget tree to efficiently subscribe to ancestor data changes without manual parameter drilling.

**Q5: What is the role of Android AICore in Gemini Nano deployment?**
*Ans:* AICore is an Android system-level service that manages foundation model execution, updates, hardware acceleration (NPU/GPU), and memory caching securely.''';
  }

  String _generateStorageComparisonResponse() {
    return '''### 💾 Local Storage in Flutter: SQLite vs SharedPreferences

• **`shared_preferences`:**
  - Key-value store (Strings, ints, doubles, booleans, string lists).
  - Backed by Android `SharedPreferences` and iOS `NSUserDefaults`.
  - Best for user settings, theme preferences, and authentication tokens.

• **`sqflite` (SQLite Database):**
  - Full relational database engine with structured tables, primary keys, and foreign keys.
  - Supports complex parameterized queries (`SELECT`, `INSERT`, `UPDATE`, `DELETE`, `JOIN`).
  - Best for student academic records, notes, tasks, and offline sync caches.''';
  }

  String _generateApiResponse() {
    return '''### 🌐 RESTful API Integration in Flutter

• **Package:** `http` package (`import 'package:http/http.dart' as http;`).
• **HTTP GET:** Retrieves resources from server (`http.get(uri)`), parses JSON into model objects via `jsonDecode(response.body)`.
• **HTTP POST:** Submits new data payloads (`http.post(uri, body: jsonEncode(...), headers: {...})`), verifying status code `201 Created`.
• **Resilience:** Always specify `.timeout(Duration(seconds: 8))` and wrap in `try...catch` with local fallback caching for offline resilience.''';
  }

  String _generateGeneralAcademicResponse(String prompt) {
    return '''### 🤖 Smart Academic Assistant (Gemini Nano Response)

Thank you for your academic query regarding: **"$prompt"**

**Academic Guidance:**
1. **Core Concept:** In Mobile Application Development and AI engineering, understanding structural separation of concerns (Model-View-Controller/Service) is fundamental.
2. **Implementation Strategy:** Always encapsulate data logic in dedicated Services (`ApiService`, `DatabaseHelper`, `AiAssistantService`), UI presentation in `Screens`, and reusable components in `Widgets`.
3. **On-Device AI Edge Execution:** This response was synthesized locally by the on-device AI assistant module with zero cloud transmission.

Feel free to select one of the quick prompt chips above for lecture summaries, study schedules, or translations!''';
  }
}
