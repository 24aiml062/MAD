import 'package:flutter/material.dart';
import 'dart_concepts.dart';

void main() {
  runApp(const SmartStudentCompanionApp());
}

/// Root widget of the Smart Student Companion App.
class SmartStudentCompanionApp extends StatelessWidget {
  const SmartStudentCompanionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Student Companion',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

/// Home screen showing a welcome message, student info, and a button
/// to demonstrate Dart programming concepts.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Student Companion'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // App icon / logo
            const Icon(Icons.school, size: 80, color: Colors.indigo),
            const SizedBox(height: 16),

            // Welcome title
            Text(
              'Welcome!',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Smart Student Companion App',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),

            // Student info card
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      'Student Information',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(),
                    _infoRow('Name', 'Parita Shah'),
                    _infoRow('Roll No.', '24AIML062'),
                    _infoRow(
                      'Subject',
                      'AIUE302 – Mobile Application Development',
                    ),
                    _infoRow('Semester', '5th (Odd 2026-27)'),
                    _infoRow('University', 'CHARUSAT'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Button to run Dart concepts demonstration
            FilledButton.icon(
              onPressed: () {
                // Run the Dart concepts demonstration and capture output
                _showConceptsDialog(context);
              },
              icon: const Icon(Icons.code),
              label: const Text('Dart Programming Concepts'),
            ),
            const SizedBox(height: 12),

            // App info text
            Text(
              'Practical 1: Flutter Environment Setup and '
              'Project Initialization',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }

  /// Helper to build an info row inside the student card.
  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Flexible(child: Text(value, textAlign: TextAlign.end)),
        ],
      ),
    );
  }

  /// Shows a dialog with a summary of the Dart concepts demonstrated.
  void _showConceptsDialog(BuildContext context) {
    // Run the demonstration function (output goes to console/debug area)
    demonstrateDartConcepts();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Dart Programming Concepts'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'The following concepts have been demonstrated '
                'and printed to the console:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              _ConceptItem('1. Variables and Data Types'),
              _ConceptItem('2. Constants (const and final)'),
              _ConceptItem('3. Operators (arithmetic, relational, logical)'),
              _ConceptItem('4. Conditional Statements (if-else, switch)'),
              _ConceptItem('5. Loops (for, while, do-while, for-in)'),
              _ConceptItem('6. Functions (arrow, optional, named params)'),
              _ConceptItem('7. Classes and Objects'),
              _ConceptItem('8. Constructors (parameterized, named)'),
              _ConceptItem('9. Inheritance'),
              _ConceptItem('10. Encapsulation and Polymorphism'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

/// Small widget to list a concept item with a bullet point.
class _ConceptItem extends StatelessWidget {
  final String text;
  const _ConceptItem(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          const Icon(Icons.check_circle, size: 16, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
