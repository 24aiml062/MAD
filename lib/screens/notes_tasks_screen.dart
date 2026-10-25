import 'package:flutter/material.dart';
import '../models/student_note.dart';
import '../models/task_item.dart';
import '../services/database_helper.dart';
import '../widgets/app_drawer.dart';

/// Screen implementing SQLite-driven Student Notes & Task Management
/// featuring full CRUD, search, priority/subject filtering, and FutureBuilder async UI.
class NotesTasksScreen extends StatefulWidget {
  final int initialTabIndex;

  const NotesTasksScreen({super.key, this.initialTabIndex = 0});

  @override
  State<NotesTasksScreen> createState() => _NotesTasksScreenState();
}

class _NotesTasksScreenState extends State<NotesTasksScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Search & Filter State
  String _notesSearchQuery = '';
  String _notesSubjectFilter = 'All';

  String _tasksSearchQuery = '';
  String _tasksPriorityFilter = 'All';
  String _tasksStatusFilter = 'All';

  // Future triggers for re-fetching
  late Future<List<StudentNote>> _notesFuture;
  late Future<List<TaskItem>> _tasksFuture;

  final List<String> _subjects = [
    'All',
    'Mobile Application Development',
    'Database Management System',
    'Artificial Intelligence',
    'Computer Networks',
  ];

  final List<String> _priorities = ['All', 'High', 'Medium', 'Low'];
  final List<String> _statuses = ['All', 'Pending', 'Completed'];

  @override
  void initState() {
    super.initState();
    final qTab = Uri.base.queryParameters['tab'];
    final qDialog = Uri.base.queryParameters['dialog'];
    final initialTab = qTab == '1' ? 1 : widget.initialTabIndex;

    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: initialTab,
    );
    _refreshNotes();
    _refreshTasks();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (qDialog == 'add_note') {
        _showAddEditNoteDialog();
      } else if (qDialog == 'add_task') {
        _showAddEditTaskDialog();
      } else if (qDialog == 'delete_note') {
        final notes = await DatabaseHelper.instance.getAllNotes();
        if (notes.isNotEmpty && mounted) {
          _confirmDeleteNote(notes.first);
        }
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _refreshNotes() {
    setState(() {
      _notesFuture = DatabaseHelper.instance.getAllNotes(
        searchQuery: _notesSearchQuery,
        subjectFilter: _notesSubjectFilter,
      );
    });
  }

  void _refreshTasks() {
    setState(() {
      _tasksFuture = DatabaseHelper.instance.getAllTasks(
        searchQuery: _tasksSearchQuery,
        priorityFilter: _tasksPriorityFilter,
        statusFilter: _tasksStatusFilter,
      );
    });
  }

  // ==========================================
  // NOTE CRUD DIALOGS
  // ==========================================

  void _showAddEditNoteDialog({StudentNote? existingNote}) {
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController(
      text: existingNote?.title ?? '',
    );
    final descController = TextEditingController(
      text: existingNote?.description ?? '',
    );
    String selectedSubject =
        existingNote?.subject ?? 'Mobile Application Development';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                existingNote == null ? Icons.note_add : Icons.edit_note,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(width: 8),
              Text(existingNote == null ? 'Add SQLite Note' : 'Edit Note'),
            ],
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Note Title *',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'Please enter note title'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: selectedSubject,
                    decoration: const InputDecoration(
                      labelText: 'Subject *',
                      border: OutlineInputBorder(),
                    ),
                    items: _subjects
                        .where((s) => s != 'All')
                        .map(
                          (s) => DropdownMenuItem(
                            value: s,
                            child: Text(s, overflow: TextOverflow.ellipsis),
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setDialogState(() => selectedSubject = val);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: descController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Description *',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'Please enter description'
                        : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final now = DateTime.now();
                  final dateStr =
                      '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

                  if (existingNote == null) {
                    // CREATE
                    await DatabaseHelper.instance.insertNote(
                      StudentNote(
                        title: titleController.text.trim(),
                        description: descController.text.trim(),
                        subject: selectedSubject,
                        createdDate: dateStr,
                      ),
                    );
                    _showSnackBar(
                      'Note successfully saved to SQLite Database!',
                    );
                  } else {
                    // UPDATE
                    await DatabaseHelper.instance.updateNote(
                      existingNote.copyWith(
                        title: titleController.text.trim(),
                        description: descController.text.trim(),
                        subject: selectedSubject,
                      ),
                    );
                    _showSnackBar('Note updated successfully in SQLite!');
                  }
                  if (ctx.mounted) Navigator.pop(ctx);
                  _refreshNotes();
                }
              },
              child: Text(existingNote == null ? 'Save Note' : 'Update Note'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteNote(StudentNote note) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.delete_forever, color: Colors.redAccent),
            SizedBox(width: 8),
            Text('Delete Note'),
          ],
        ),
        content: Text(
          'Are you sure you want to permanently delete "${note.title}" from SQLite?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              await DatabaseHelper.instance.deleteNote(note.id!);
              _showSnackBar('Note deleted from SQLite Database');
              _refreshNotes();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // TASK CRUD DIALOGS
  // ==========================================

  void _showAddEditTaskDialog({TaskItem? existingTask}) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(
      text: existingTask?.taskName ?? '',
    );
    final dueController = TextEditingController(
      text: existingTask?.dueDate ?? 'Tomorrow (5:00 PM)',
    );
    String selectedPriority = existingTask?.priority ?? 'Medium';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                existingTask == null ? Icons.add_task : Icons.edit_calendar,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(width: 8),
              Text(existingTask == null ? 'Add SQLite Task' : 'Edit Task'),
            ],
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Task Name *',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'Please enter task name'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: dueController,
                    decoration: const InputDecoration(
                      labelText: 'Due Date / Deadline *',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today, size: 20),
                    ),
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'Please enter due date'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: selectedPriority,
                    decoration: const InputDecoration(
                      labelText: 'Priority Level *',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'High',
                        child: Text('High Priority'),
                      ),
                      DropdownMenuItem(
                        value: 'Medium',
                        child: Text('Medium Priority'),
                      ),
                      DropdownMenuItem(
                        value: 'Low',
                        child: Text('Low Priority'),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setDialogState(() => selectedPriority = val);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  if (existingTask == null) {
                    // CREATE
                    await DatabaseHelper.instance.insertTask(
                      TaskItem(
                        taskName: nameController.text.trim(),
                        dueDate: dueController.text.trim(),
                        priority: selectedPriority,
                        status: 'Pending',
                      ),
                    );
                    _showSnackBar(
                      'Task successfully added to SQLite Task Manager!',
                    );
                  } else {
                    // UPDATE
                    await DatabaseHelper.instance.updateTask(
                      existingTask.copyWith(
                        taskName: nameController.text.trim(),
                        dueDate: dueController.text.trim(),
                        priority: selectedPriority,
                      ),
                    );
                    _showSnackBar('Task updated in SQLite Database!');
                  }
                  if (ctx.mounted) Navigator.pop(ctx);
                  _refreshTasks();
                }
              },
              child: Text(existingTask == null ? 'Save Task' : 'Update Task'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteTask(TaskItem task) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.delete_forever, color: Colors.redAccent),
            SizedBox(width: 8),
            Text('Delete Task'),
          ],
        ),
        content: Text(
          'Are you sure you want to delete "${task.taskName}" from SQLite?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              await DatabaseHelper.instance.deleteTask(task.id!);
              _showSnackBar('Task deleted from SQLite Database');
              _refreshTasks();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: const Color(0xFF2E7D32),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      drawer: const AppDrawer(currentRoute: '/notes_tasks'),
      appBar: AppBar(
        title: const Text(
          'Notes & Tasks (SQLite DB)',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.notes), text: 'Student Notes'),
            Tab(icon: Icon(Icons.check_circle_outline), text: 'Task Manager'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reload SQLite Data',
            onPressed: () {
              _refreshNotes();
              _refreshTasks();
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildNotesTab(theme, isDark),
          _buildTasksTab(theme, isDark),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        onPressed: () {
          if (_tabController.index == 0) {
            _showAddEditNoteDialog();
          } else {
            _showAddEditTaskDialog();
          }
        },
        icon: const Icon(Icons.add),
        label: Text(_tabController.index == 0 ? 'New Note' : 'New Task'),
      ),
    );
  }

  // ==========================================
  // TAB 1: STUDENT NOTES (FUTUREBUILDER)
  // ==========================================

  Widget _buildNotesTab(ThemeData theme, bool isDark) {
    return Column(
      children: [
        // Search & Subject Filter Bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search notes by title, subject or content...',
                  prefixIcon: const Icon(Icons.search, size: 20),
                  suffixIcon: _notesSearchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () {
                            setState(() => _notesSearchQuery = '');
                            _refreshNotes();
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: isDark
                      ? Colors.grey.shade900
                      : Colors.grey.shade100,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (val) {
                  setState(() => _notesSearchQuery = val);
                  _refreshNotes();
                },
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _subjects.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 8),
                  itemBuilder: (context, idx) {
                    final sub = _subjects[idx];
                    final isSelected = _notesSubjectFilter == sub;
                    return FilterChip(
                      label: Text(
                        sub == 'Mobile Application Development'
                            ? 'MAD'
                            : sub == 'Database Management System'
                            ? 'DBMS'
                            : sub == 'Artificial Intelligence'
                            ? 'AI'
                            : sub == 'Computer Networks'
                            ? 'CN'
                            : sub,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isSelected
                              ? Colors.white
                              : theme.textTheme.bodyMedium?.color,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: theme.colorScheme.primary,
                      showCheckmark: false,
                      onSelected: (selected) {
                        setState(() => _notesSubjectFilter = sub);
                        _refreshNotes();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),

        // Asynchronous ListView via FutureBuilder
        Expanded(
          child: FutureBuilder<List<StudentNote>>(
            future: _notesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text('SQLite Query Error: ${snapshot.error}'),
                );
              }

              final notes = snapshot.data ?? [];
              if (notes.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.notes, size: 64, color: Colors.grey.shade400),
                      const SizedBox(height: 12),
                      Text(
                        'No notes found in SQLite',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tap "+ New Note" to add a new academic record',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.only(
                  left: 12,
                  right: 12,
                  top: 12,
                  bottom: 80,
                ),
                itemCount: notes.length,
                itemBuilder: (context, idx) {
                  final note = notes[idx];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: _getSubjectColor(
                                    note.subject,
                                  ).withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  note.subject,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: _getSubjectColor(note.subject),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, size: 18),
                                    color: Colors.blueAccent,
                                    onPressed: () => _showAddEditNoteDialog(
                                      existingNote: note,
                                    ),
                                    tooltip: 'Edit Note',
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      size: 18,
                                    ),
                                    color: Colors.redAccent,
                                    onPressed: () => _confirmDeleteNote(note),
                                    tooltip: 'Delete Note',
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            note.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            note.description,
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark
                                  ? Colors.white70
                                  : Colors.grey.shade800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 12,
                                color: Colors.grey.shade500,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Created: ${note.createdDate}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  // ==========================================
  // TAB 2: TASK MANAGER (FUTUREBUILDER)
  // ==========================================

  Widget _buildTasksTab(ThemeData theme, bool isDark) {
    return Column(
      children: [
        // Task Search & Priority Filters
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search tasks by name...',
                  prefixIcon: const Icon(Icons.search, size: 20),
                  suffixIcon: _tasksSearchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () {
                            setState(() => _tasksSearchQuery = '');
                            _refreshTasks();
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: isDark
                      ? Colors.grey.shade900
                      : Colors.grey.shade100,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (val) {
                  setState(() => _tasksSearchQuery = val);
                  _refreshTasks();
                },
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text(
                    'Priority: ',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 32,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _priorities.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 6),
                        itemBuilder: (context, idx) {
                          final pri = _priorities[idx];
                          final isSel = _tasksPriorityFilter == pri;
                          return ChoiceChip(
                            label: Text(
                              pri,
                              style: TextStyle(
                                fontSize: 10,
                                color: isSel ? Colors.white : null,
                              ),
                            ),
                            selected: isSel,
                            selectedColor: _getPriorityColor(pri),
                            onSelected: (val) {
                              setState(() => _tasksPriorityFilter = pri);
                              _refreshTasks();
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Text(
                    'Status: ',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 32,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _statuses.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 6),
                        itemBuilder: (context, idx) {
                          final st = _statuses[idx];
                          final isSel = _tasksStatusFilter == st;
                          return ChoiceChip(
                            label: Text(
                              st,
                              style: TextStyle(
                                fontSize: 10,
                                color: isSel ? Colors.white : null,
                              ),
                            ),
                            selected: isSel,
                            selectedColor: theme.colorScheme.primary,
                            onSelected: (val) {
                              setState(() => _tasksStatusFilter = st);
                              _refreshTasks();
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(height: 1),

        // Asynchronous Task List via FutureBuilder
        Expanded(
          child: FutureBuilder<List<TaskItem>>(
            future: _tasksFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text('SQLite Query Error: ${snapshot.error}'),
                );
              }

              final tasks = snapshot.data ?? [];
              if (tasks.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.task_alt,
                        size: 64,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No tasks found in SQLite',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tap "+ New Task" to create a task reminder',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.only(
                  left: 12,
                  right: 12,
                  top: 12,
                  bottom: 80,
                ),
                itemCount: tasks.length,
                itemBuilder: (context, idx) {
                  final task = tasks[idx];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      leading: Checkbox(
                        value: task.isCompleted,
                        activeColor: const Color(0xFF2E7D32),
                        onChanged: (checked) async {
                          if (checked != null && task.id != null) {
                            await DatabaseHelper.instance.toggleTaskStatus(
                              task.id!,
                              checked,
                            );
                            _refreshTasks();
                          }
                        },
                      ),
                      title: Text(
                        task.taskName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                          color: task.isCompleted ? Colors.grey : null,
                        ),
                      ),
                      subtitle: Row(
                        children: [
                          Icon(
                            Icons.schedule,
                            size: 12,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            task.dueDate,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 1.5,
                            ),
                            decoration: BoxDecoration(
                              color: _getPriorityColor(
                                task.priority,
                              ).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              task.priority,
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.bold,
                                color: _getPriorityColor(task.priority),
                              ),
                            ),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, size: 18),
                            color: Colors.blueAccent,
                            onPressed: () =>
                                _showAddEditTaskDialog(existingTask: task),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, size: 18),
                            color: Colors.redAccent,
                            onPressed: () => _confirmDeleteTask(task),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Color _getSubjectColor(String subject) {
    switch (subject) {
      case 'Mobile Application Development':
        return Colors.indigo;
      case 'Database Management System':
        return Colors.teal;
      case 'Artificial Intelligence':
        return Colors.purple;
      case 'Computer Networks':
        return Colors.orange.shade800;
      default:
        return Colors.blueGrey;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.redAccent;
      case 'Medium':
        return Colors.orange.shade800;
      case 'Low':
        return Colors.green;
      default:
        return Colors.blueGrey;
    }
  }
}
