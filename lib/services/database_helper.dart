import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart' as sql;
import '../models/student_note.dart';
import '../models/task_item.dart';

/// Database Helper class implementing SQLite database lifecycle, schema definition,
/// and CRUD operations for Student Notes and Task Management modules.
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static sql.Database? _database;

  // Database and Table Constants
  static const String dbName = 'smart_student_companion.db';
  static const int dbVersion = 1;

  static const String tableNotes = 'student_notes';
  static const String tableTasks = 'task_manager';

  // In-memory fallback for Flutter Web runtime & headless verification
  final List<StudentNote> _webNotes = [];
  final List<TaskItem> _webTasks = [];
  int _webNoteIdCounter = 1;
  int _webTaskIdCounter = 1;
  static bool useMockFallback = false;

  DatabaseHelper._init() {
    _seedWebData();
  }

  /// Retrieves the active SQLite database instance or initializes it if not yet opened.
  Future<sql.Database?> get database async {
    if (kIsWeb || useMockFallback) return null;
    if (_database != null) return _database!;
    try {
      _database = await _initDB(dbName);
      return _database!;
    } catch (_) {
      useMockFallback = true;
      if (_webNotes.isEmpty) {
        _seedWebData();
      }
      return null;
    }
  }

  Future<sql.Database> _initDB(String filePath) async {
    final dbPath = await sql.getDatabasesPath();
    final path = p.join(dbPath, filePath);

    return await sql.openDatabase(
      path,
      version: dbVersion,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(sql.Database db, int version) async {
    // 1. Table: Student Notes
    await db.execute('''
      CREATE TABLE $tableNotes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        subject TEXT NOT NULL,
        created_date TEXT NOT NULL
      )
    ''');

    // 2. Table: Task Manager
    await db.execute('''
      CREATE TABLE $tableTasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        task_name TEXT NOT NULL,
        due_date TEXT NOT NULL,
        priority TEXT NOT NULL,
        status TEXT NOT NULL
      )
    ''');

    // Seed Initial Syllabus Sample Records
    await _seedDatabase(db);
  }

  Future<void> _seedDatabase(sql.Database db) async {
    // Notes
    await db.insert(tableNotes, {
      'title': 'Flutter Widgets',
      'description':
          'Study Stateless and Stateful Widgets, widget lifecycle, and reactive UI.',
      'subject': 'Mobile Application Development',
      'created_date': '2026-10-25',
    });
    await db.insert(tableNotes, {
      'title': 'Database Normalization',
      'description':
          'Review 1NF, 2NF, 3NF and Boyce-Codd Normal Form functional dependencies.',
      'subject': 'Database Management System',
      'created_date': '2026-10-24',
    });
    await db.insert(tableNotes, {
      'title': 'Neural Networks Architecture',
      'description':
          'Study multi-layer perceptron, backpropagation algorithm, and loss optimization.',
      'subject': 'Artificial Intelligence',
      'created_date': '2026-10-23',
    });

    // Tasks
    await db.insert(tableTasks, {
      'task_name': 'Submit Flutter Assignment',
      'due_date': 'Tomorrow (5:00 PM)',
      'priority': 'High',
      'status': 'Pending',
    });
    await db.insert(tableTasks, {
      'task_name': 'Prepare DBMS Practical',
      'due_date': '28 Oct 2026',
      'priority': 'Medium',
      'status': 'Pending',
    });
    await db.insert(tableTasks, {
      'task_name': 'Complete REST API Module',
      'due_date': '30 Oct 2026',
      'priority': 'High',
      'status': 'Pending',
    });
    await db.insert(tableTasks, {
      'task_name': 'Attend Placement Workshop',
      'due_date': '02 Nov 2026',
      'priority': 'Low',
      'status': 'Completed',
    });
  }

  void _seedWebData() {
    _webNotes.clear();
    _webTasks.clear();

    _webNotes.addAll([
      StudentNote(
        id: _webNoteIdCounter++,
        title: 'Flutter Widgets',
        description:
            'Study Stateless and Stateful Widgets, widget lifecycle, and reactive UI.',
        subject: 'Mobile Application Development',
        createdDate: '2026-10-25',
      ),
      StudentNote(
        id: _webNoteIdCounter++,
        title: 'Database Normalization',
        description:
            'Review 1NF, 2NF, 3NF and Boyce-Codd Normal Form functional dependencies.',
        subject: 'Database Management System',
        createdDate: '2026-10-24',
      ),
      StudentNote(
        id: _webNoteIdCounter++,
        title: 'Neural Networks Architecture',
        description:
            'Study multi-layer perceptron, backpropagation algorithm, and loss optimization.',
        subject: 'Artificial Intelligence',
        createdDate: '2026-10-23',
      ),
    ]);

    _webTasks.addAll([
      TaskItem(
        id: _webTaskIdCounter++,
        taskName: 'Submit Flutter Assignment',
        dueDate: 'Tomorrow (5:00 PM)',
        priority: 'High',
        status: 'Pending',
      ),
      TaskItem(
        id: _webTaskIdCounter++,
        taskName: 'Prepare DBMS Practical',
        dueDate: '28 Oct 2026',
        priority: 'Medium',
        status: 'Pending',
      ),
      TaskItem(
        id: _webTaskIdCounter++,
        taskName: 'Complete REST API Module',
        dueDate: '30 Oct 2026',
        priority: 'High',
        status: 'Pending',
      ),
      TaskItem(
        id: _webTaskIdCounter++,
        taskName: 'Attend Placement Workshop',
        dueDate: '02 Nov 2026',
        priority: 'Low',
        status: 'Completed',
      ),
    ]);
  }

  // ==========================================
  // STUDENT NOTES: CRUD & SEARCH OPERATIONS
  // ==========================================

  /// CREATE: Inserts a new note into the SQLite database.
  Future<int> insertNote(StudentNote note) async {
    final db = await database;
    if (db == null) {
      final newId = _webNoteIdCounter++;
      final savedNote = note.copyWith(id: newId);
      _webNotes.insert(0, savedNote);
      return newId;
    }

    return await db.insert(tableNotes, note.toMap());
  }

  /// READ: Retrieves all notes with optional search query and subject filter.
  Future<List<StudentNote>> getAllNotes({
    String? searchQuery,
    String? subjectFilter,
  }) async {
    final db = await database;
    if (db == null) {
      var list = List<StudentNote>.from(_webNotes);
      if (subjectFilter != null &&
          subjectFilter.isNotEmpty &&
          subjectFilter != 'All') {
        list = list.where((n) => n.subject == subjectFilter).toList();
      }
      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        final q = searchQuery.toLowerCase();
        list = list
            .where(
              (n) =>
                  n.title.toLowerCase().contains(q) ||
                  n.description.toLowerCase().contains(q) ||
                  n.subject.toLowerCase().contains(q),
            )
            .toList();
      }
      return list;
    }

    String whereClause = '';
    List<dynamic> whereArgs = [];

    if (subjectFilter != null &&
        subjectFilter.isNotEmpty &&
        subjectFilter != 'All') {
      whereClause = 'subject = ?';
      whereArgs.add(subjectFilter);
    }

    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      final queryCondition =
          '(title LIKE ? OR description LIKE ? OR subject LIKE ?)';
      whereClause = whereClause.isEmpty
          ? queryCondition
          : '$whereClause AND $queryCondition';
      final qParam = '%${searchQuery.trim()}%';
      whereArgs.addAll([qParam, qParam, qParam]);
    }

    final result = await db.query(
      tableNotes,
      where: whereClause.isEmpty ? null : whereClause,
      whereArgs: whereArgs.isEmpty ? null : whereArgs,
      orderBy: 'id DESC',
    );

    return result.map((map) => StudentNote.fromMap(map)).toList();
  }

  /// UPDATE: Modifies an existing note in the SQLite database.
  Future<int> updateNote(StudentNote note) async {
    if (note.id == null) return 0;

    final db = await database;
    if (db == null) {
      final idx = _webNotes.indexWhere((n) => n.id == note.id);
      if (idx != -1) {
        _webNotes[idx] = note;
        return 1;
      }
      return 0;
    }

    return await db.update(
      tableNotes,
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  /// DELETE: Removes a note by ID from the SQLite database.
  Future<int> deleteNote(int id) async {
    final db = await database;
    if (db == null) {
      final initialLen = _webNotes.length;
      _webNotes.removeWhere((n) => n.id == id);
      return initialLen - _webNotes.length;
    }

    return await db.delete(tableNotes, where: 'id = ?', whereArgs: [id]);
  }

  // ==========================================
  // TASK MANAGER: CRUD & FILTER OPERATIONS
  // ==========================================

  /// CREATE: Inserts a new task into the SQLite database.
  Future<int> insertTask(TaskItem task) async {
    final db = await database;
    if (db == null) {
      final newId = _webTaskIdCounter++;
      final savedTask = task.copyWith(id: newId);
      _webTasks.insert(0, savedTask);
      return newId;
    }

    return await db.insert(tableTasks, task.toMap());
  }

  /// READ: Retrieves all tasks with search query, priority filter, and status filter.
  Future<List<TaskItem>> getAllTasks({
    String? searchQuery,
    String? priorityFilter,
    String? statusFilter,
  }) async {
    final db = await database;
    if (db == null) {
      var list = List<TaskItem>.from(_webTasks);
      if (priorityFilter != null &&
          priorityFilter.isNotEmpty &&
          priorityFilter != 'All') {
        list = list.where((t) => t.priority == priorityFilter).toList();
      }
      if (statusFilter != null &&
          statusFilter.isNotEmpty &&
          statusFilter != 'All') {
        list = list.where((t) => t.status == statusFilter).toList();
      }
      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        final q = searchQuery.toLowerCase();
        list = list.where((t) => t.taskName.toLowerCase().contains(q)).toList();
      }
      return list;
    }

    List<String> conditions = [];
    List<dynamic> whereArgs = [];

    if (priorityFilter != null &&
        priorityFilter.isNotEmpty &&
        priorityFilter != 'All') {
      conditions.add('priority = ?');
      whereArgs.add(priorityFilter);
    }

    if (statusFilter != null &&
        statusFilter.isNotEmpty &&
        statusFilter != 'All') {
      conditions.add('status = ?');
      whereArgs.add(statusFilter);
    }

    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      conditions.add('task_name LIKE ?');
      whereArgs.add('%${searchQuery.trim()}%');
    }

    final whereClause = conditions.isEmpty ? null : conditions.join(' AND ');

    final result = await db.query(
      tableTasks,
      where: whereClause,
      whereArgs: whereArgs.isEmpty ? null : whereArgs,
      orderBy: 'id DESC',
    );

    return result.map((map) => TaskItem.fromMap(map)).toList();
  }

  /// UPDATE: Modifies an existing task in the SQLite database.
  Future<int> updateTask(TaskItem task) async {
    if (task.id == null) return 0;

    final db = await database;
    if (db == null) {
      final idx = _webTasks.indexWhere((t) => t.id == task.id);
      if (idx != -1) {
        _webTasks[idx] = task;
        return 1;
      }
      return 0;
    }

    return await db.update(
      tableTasks,
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  /// UPDATE STATUS: Toggles task status between Pending and Completed.
  Future<int> toggleTaskStatus(int id, bool completed) async {
    final statusStr = completed ? 'Completed' : 'Pending';

    final db = await database;
    if (db == null) {
      final idx = _webTasks.indexWhere((t) => t.id == id);
      if (idx != -1) {
        _webTasks[idx] = _webTasks[idx].copyWith(status: statusStr);
        return 1;
      }
      return 0;
    }

    return await db.update(
      tableTasks,
      {'status': statusStr},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// DELETE: Removes a task by ID from the SQLite database.
  Future<int> deleteTask(int id) async {
    final db = await database;
    if (db == null) {
      final initialLen = _webTasks.length;
      _webTasks.removeWhere((t) => t.id == id);
      return initialLen - _webTasks.length;
    }

    return await db.delete(tableTasks, where: 'id = ?', whereArgs: [id]);
  }

  /// Closes database connection when terminating.
  Future<void> close() async {
    final db = await database;
    if (db != null) {
      await db.close();
    }
  }
}
