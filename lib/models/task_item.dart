/// Data model representing a task in the SQLite Task Manager table.
class TaskItem {
  final int? id;
  final String taskName;
  final String dueDate;
  final String priority; // 'High', 'Medium', 'Low'
  final String status; // 'Pending', 'Completed'

  const TaskItem({
    this.id,
    required this.taskName,
    required this.dueDate,
    this.priority = 'Medium',
    this.status = 'Pending',
  });

  bool get isCompleted => status == 'Completed';

  /// Converts TaskItem to Map for SQLite database storage.
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'task_name': taskName,
      'due_date': dueDate,
      'priority': priority,
      'status': status,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  /// Constructs TaskItem from SQLite query Map result.
  factory TaskItem.fromMap(Map<String, dynamic> map) {
    return TaskItem(
      id: map['id'] as int?,
      taskName: map['task_name'] as String,
      dueDate: map['due_date'] as String,
      priority: map['priority'] as String? ?? 'Medium',
      status: map['status'] as String? ?? 'Pending',
    );
  }

  /// Creates a modified copy of the current task.
  TaskItem copyWith({
    int? id,
    String? taskName,
    String? dueDate,
    String? priority,
    String? status,
  }) {
    return TaskItem(
      id: id ?? this.id,
      taskName: taskName ?? this.taskName,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      status: status ?? this.status,
    );
  }
}
