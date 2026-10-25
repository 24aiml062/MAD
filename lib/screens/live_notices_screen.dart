import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/academic_notice.dart';
import '../services/api_service.dart';
import '../services/preferences_service.dart';
import '../widgets/app_drawer.dart';

/// Screen implementing RESTful API Integration (HTTP GET & POST), JSON Serialization,
/// Pull-to-Refresh, Asynchronous FutureBuilder, and Defensive Error Handling.
class LiveNoticesScreen extends StatefulWidget {
  final int initialTabIndex;
  final bool autoSubmit;

  const LiveNoticesScreen({
    super.key,
    this.initialTabIndex = 0,
    this.autoSubmit = false,
  });

  @override
  State<LiveNoticesScreen> createState() => _LiveNoticesScreenState();
}

class _LiveNoticesScreenState extends State<LiveNoticesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Search & Filter State
  String _searchQuery = '';
  String _selectedCategory = 'All';

  // In-flight Future
  late Future<List<AcademicNotice>> _noticesFuture;

  // POST Form State
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  String _selectedInquiryCategory = 'Lab Support';
  bool _isSubmittingPost = false;

  final List<String> _categories = [
    'All',
    'Exam',
    'Placement',
    'Workshop',
    'Tech Fest',
    'Academic',
  ];

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

    // Pre-populate with authenticated student details
    _nameController.text = PreferencesService.userName;
    _emailController.text = PreferencesService.userEmail;

    _fetchNotices();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.autoSubmit || qDialog == 'feedback_success') {
        _handleSubmitFeedback();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _fetchNotices() {
    setState(() {
      _noticesFuture = ApiService.getAcademicNotices();
    });
  }

  Future<void> _handleRefresh() async {
    _fetchNotices();
    await _noticesFuture;
  }

  Future<void> _handleSubmitFeedback() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmittingPost = true);

    final submission = StudentFeedbackSubmission(
      studentName: _nameController.text.trim(),
      email: _emailController.text.trim(),
      category: _selectedInquiryCategory,
      message: _messageController.text.trim(),
    );

    final response = await ApiService.submitFeedback(submission);

    if (!mounted) return;
    setState(() => _isSubmittingPost = false);

    // Display Server Confirmation Dialog with HTTP 201 details
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.cloud_done, color: Color(0xFF2E7D32)),
            SizedBox(width: 8),
            Text(
              'REST POST Response: 201 Created',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your inquiry has been successfully transmitted to the remote REST server via HTTP POST.',
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Text(
                const JsonEncoder.withIndent('  ').convert(response),
                style: const TextStyle(fontFamily: 'Consolas', fontSize: 11),
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              _messageController.clear();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      drawer: const AppDrawer(currentRoute: '/live_notices'),
      appBar: AppBar(
        title: const Text(
          'University Notices (REST API)',
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
            Tab(icon: Icon(Icons.cloud_download), text: 'Live Notices (GET)'),
            Tab(icon: Icon(Icons.cloud_upload), text: 'Submit Inquiry (POST)'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Pull live data from REST API',
            onPressed: _fetchNotices,
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildLiveNoticesTab(theme, isDark),
          _buildPostFeedbackTab(theme, isDark),
        ],
      ),
    );
  }

  // ==========================================
  // TAB 1: LIVE NOTICES (HTTP GET + REFRESH)
  // ==========================================

  Widget _buildLiveNoticesTab(ThemeData theme, bool isDark) {
    return Column(
      children: [
        // Server Status Banner
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          color: const Color(0xFF00897B).withValues(alpha: 0.12),
          child: const Row(
            children: [
              Icon(Icons.wifi, size: 14, color: Color(0xFF00897B)),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Connected to REST Endpoint: jsonplaceholder.typicode.com/posts (JSON Parsing Active)',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF00695C),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Search & Category Filters
        Container(
          padding: const EdgeInsets.all(12),
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search notices by title, keywords or author...',
                  prefixIcon: const Icon(Icons.search, size: 20),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () => setState(() => _searchQuery = ''),
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
                onChanged: (val) => setState(() => _searchQuery = val),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 8),
                  itemBuilder: (context, idx) {
                    final cat = _categories[idx];
                    final isSelected = _selectedCategory == cat;
                    return FilterChip(
                      label: Text(
                        cat,
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
                      selectedColor: _getCategoryColor(cat),
                      showCheckmark: false,
                      onSelected: (selected) {
                        setState(() => _selectedCategory = cat);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),

        // Asynchronous ListView via FutureBuilder & Pull-to-Refresh
        Expanded(
          child: RefreshIndicator(
            onRefresh: _handleRefresh,
            color: theme.colorScheme.primary,
            child: FutureBuilder<List<AcademicNotice>>(
              future: _noticesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 14),
                        Text(
                          'Performing HTTP GET to REST Server...',
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.cloud_off,
                          size: 56,
                          color: Colors.redAccent,
                        ),
                        const SizedBox(height: 12),
                        Text('HTTP Connection Error: ${snapshot.error}'),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: _fetchNotices,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry Connection'),
                        ),
                      ],
                    ),
                  );
                }

                var notices = snapshot.data ?? [];

                // Filter by category
                if (_selectedCategory != 'All') {
                  notices = notices
                      .where((n) => n.category == _selectedCategory)
                      .toList();
                }

                // Filter by search query
                if (_searchQuery.trim().isNotEmpty) {
                  final q = _searchQuery.toLowerCase();
                  notices = notices
                      .where(
                        (n) =>
                            n.title.toLowerCase().contains(q) ||
                            n.body.toLowerCase().contains(q) ||
                            n.author.toLowerCase().contains(q),
                      )
                      .toList();
                }

                if (notices.isEmpty) {
                  return const Center(
                    child: Text(
                      'No academic notices match the selected criteria.',
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: notices.length,
                  itemBuilder: (context, idx) {
                    final notice = notices[idx];
                    return Card(
                      elevation: 2.5,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () => _showNoticeDetails(notice),
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getCategoryColor(
                                        notice.category,
                                      ).withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      notice.category.toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: _getCategoryColor(
                                          notice.category,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_month,
                                        size: 12,
                                        color: Colors.grey.shade500,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        notice.date,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                notice.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                notice.body,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isDark
                                      ? Colors.white70
                                      : Colors.grey.shade700,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.account_balance,
                                        size: 14,
                                        color: Colors.indigo,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        notice.author,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.indigo,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'REST ID #${notice.id}',
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  void _showNoticeDetails(AcademicNotice notice) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: _getCategoryColor(
                  notice.category,
                ).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                notice.category,
                style: TextStyle(
                  fontSize: 11,
                  color: _getCategoryColor(notice.category),
                ),
              ),
            ),
            const Spacer(),
            Text(
              'ID: #${notice.id}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notice.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.school, size: 14, color: Colors.indigo),
                const SizedBox(width: 4),
                Text(
                  notice.author,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 12, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  notice.date,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
            const Divider(height: 20),
            Text(
              notice.body,
              style: const TextStyle(fontSize: 13, height: 1.4),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // TAB 2: SUBMIT INQUIRY (HTTP POST)
  // ==========================================

  Widget _buildPostFeedbackTab(ThemeData theme, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.send_rounded, color: Color(0xFF1A237E)),
                        SizedBox(width: 8),
                        Text(
                          'Submit Academic Inquiry / Feedback',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Demonstrates HTTP POST request transmission with JSON payload serialization (RFC 8259).',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const Divider(height: 24),

                    // Student Name
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Student Name *',
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) =>
                          v == null || v.trim().isEmpty ? 'Enter name' : null,
                    ),
                    const SizedBox(height: 14),

                    // Student Email
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'University Email ID *',
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) => v == null || !v.contains('@')
                          ? 'Enter valid email'
                          : null,
                    ),
                    const SizedBox(height: 14),

                    // Category
                    DropdownButtonFormField<String>(
                      initialValue: _selectedInquiryCategory,
                      decoration: const InputDecoration(
                        labelText: 'Inquiry Category *',
                        prefixIcon: Icon(Icons.category_outlined),
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Lab Support',
                          child: Text('Lab Support & Practical Queries'),
                        ),
                        DropdownMenuItem(
                          value: 'Exam Query',
                          child: Text('Examination & Grading Inquiries'),
                        ),
                        DropdownMenuItem(
                          value: 'Placement Assistance',
                          child: Text('Training & Placement Assistance'),
                        ),
                        DropdownMenuItem(
                          value: 'General Feedback',
                          child: Text('General App & Campus Feedback'),
                        ),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _selectedInquiryCategory = val);
                        }
                      },
                    ),
                    const SizedBox(height: 14),

                    // Message
                    TextFormField(
                      controller: _messageController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: 'Inquiry Message / Feedback *',
                        alignLabelWithHint: true,
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(bottom: 60),
                          child: Icon(Icons.message_outlined),
                        ),
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) => v == null || v.trim().isEmpty
                          ? 'Enter inquiry details'
                          : null,
                    ),
                    const SizedBox(height: 20),

                    // Submit Button
                    SizedBox(
                      height: 48,
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: _isSubmittingPost
                            ? null
                            : _handleSubmitFeedback,
                        icon: _isSubmittingPost
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.cloud_upload),
                        label: Text(
                          _isSubmittingPost
                              ? 'Sending HTTP POST Payload...'
                              : 'Send via REST POST Request',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Exam':
        return Colors.redAccent;
      case 'Placement':
        return Colors.green.shade700;
      case 'Workshop':
        return Colors.purple;
      case 'Tech Fest':
        return Colors.pink;
      case 'Academic':
        return Colors.indigo;
      default:
        return Colors.teal;
    }
  }
}
