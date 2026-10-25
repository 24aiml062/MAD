import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/ai_message.dart';
import '../services/ai_assistant_service.dart';
import '../widgets/app_drawer.dart';

class AiAssistantScreen extends StatefulWidget {
  final String? initialPrompt;
  final bool autoOpenSpecs;

  const AiAssistantScreen({
    super.key,
    this.initialPrompt,
    this.autoOpenSpecs = false,
  });

  @override
  State<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends State<AiAssistantScreen> {
  final AiAssistantService _aiService = AiAssistantService();
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<AiMessage> _messages = [];
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _loadWelcomeMessage();
    if (widget.initialPrompt != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleSendMessage(customPrompt: widget.initialPrompt);
      });
    }
    if (widget.autoOpenSpecs) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showModelSpecsDialog();
      });
    }
  }

  void _loadWelcomeMessage() {
    _messages.add(
      AiMessage(
        id: 'welcome',
        text: '''👋 **Welcome to your AI Smart Academic Assistant!**

Powered by **Google AI Edge SDK** and **Gemini Nano** architecture for mobile devices. All inference runs **100% on-device** via your smartphone's Neural Processing Unit (NPU), ensuring:
• ⚡ **Sub-second latency** (~140ms response time)
• 🔒 **Complete privacy** (your notes never leave the device)
• ✈️ **Full offline support** without internet connectivity

Select a prompt chip below or type any question regarding Flutter, Mobile AI, DBMS, or Computer Networks.''',
        isUser: false,
        timestamp: DateTime.now(),
        category: AiPromptCategory.general,
        suggestedActions: [
          'Summarize Notes',
          'Exam Study Plan',
          'Explain Widgets',
        ],
        processingTimeMs: 45,
        tokenCount: 88,
        isOffline: true,
      ),
    );
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _handleSendMessage({
    String? customPrompt,
    AiPromptCategory? category,
  }) async {
    final promptText = customPrompt ?? _inputController.text.trim();
    if (promptText.isEmpty || _isProcessing) return;

    final userMessage = AiMessage(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      text: promptText,
      isUser: true,
      timestamp: DateTime.now(),
      category: category ?? AiPromptCategory.general,
    );

    setState(() {
      _messages.add(userMessage);
      _isProcessing = true;
      if (customPrompt == null) {
        _inputController.clear();
      }
    });

    _scrollToBottom();

    try {
      final aiResponse = await _aiService.generateResponse(
        prompt: promptText,
        category: category ?? AiPromptCategory.general,
      );

      if (mounted) {
        setState(() {
          _messages.add(aiResponse);
          _isProcessing = false;
        });
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _messages.add(
            AiMessage(
              id: 'err_${DateTime.now().millisecondsSinceEpoch}',
              text: '⚠️ An error occurred during local inference: $e',
              isUser: false,
              timestamp: DateTime.now(),
              category: AiPromptCategory.general,
            ),
          );
          _isProcessing = false;
        });
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showModelSpecsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.memory, color: Colors.blueAccent),
            SizedBox(width: 8),
            Text('Gemini Nano Specs'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSpecRow(
              'Model Architecture',
              'Gemini Nano (4-bit INT4 Quantized)',
            ),
            _buildSpecRow(
              'Runtime Framework',
              'Google AI Edge SDK (LiteRT / AICore)',
            ),
            _buildSpecRow(
              'Hardware Engine',
              'On-Device NPU & Hexagon Tensor Accelerator',
            ),
            _buildSpecRow('Context Window', '4K Tokens Context'),
            _buildSpecRow(
              'Privacy Mode',
              '100% Local Inference (Zero Cloud Data Leak)',
            ),
            _buildSpecRow(
              'Offline Capability',
              'Fully Operational in Airplane Mode',
            ),
            _buildSpecRow(
              'Target Platform',
              'Android 14+ AICore / iOS Edge ML',
            ),
          ],
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

  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  void _clearChatHistory() {
    setState(() {
      _messages.clear();
      _loadWelcomeMessage();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Chat session reset to initial state'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'AI Smart Assistant',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.greenAccent,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  'Gemini Nano • Google AI Edge SDK',
                  style: TextStyle(fontSize: 11, color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'Gemini Nano Architecture Specs',
            onPressed: _showModelSpecsDialog,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset Chat',
            onPressed: _clearChatHistory,
          ),
        ],
      ),
      drawer: const AppDrawer(currentRoute: '/ai_assistant'),
      body: SafeArea(
        child: Column(
          children: [
            // Prompt Shortcuts Bar
            _buildPromptShortcuts(),

            // Chat Messages Stream
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(12),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return _buildMessageBubble(message);
                },
              ),
            ),

            // Processing indicator
            if (_isProcessing) _buildProcessingIndicator(),

            // Message Input Field
            _buildInputArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildPromptShortcuts() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        border: Border(
          bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 6, bottom: 4),
            child: Text(
              '💡 Quick Academic Prompts (Gemini Nano):',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: AiAssistantService.promptTemplates.map((template) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ActionChip(
                    avatar: Icon(
                      _getIconForTemplate(template['icon'] as String),
                      size: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    label: Text(
                      template['title'] as String,
                      style: const TextStyle(fontSize: 12),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    onPressed: _isProcessing
                        ? null
                        : () {
                            _handleSendMessage(
                              customPrompt: template['prompt'] as String,
                              category:
                                  template['category'] as AiPromptCategory,
                            );
                          },
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForTemplate(String iconName) {
    switch (iconName) {
      case 'notes':
        return Icons.summarize_rounded;
      case 'school':
        return Icons.school_rounded;
      case 'event_note':
        return Icons.calendar_month_rounded;
      case 'menu_book':
        return Icons.menu_book_rounded;
      case 'translate':
        return Icons.translate_rounded;
      case 'quiz':
        return Icons.quiz_rounded;
      default:
        return Icons.auto_awesome;
    }
  }

  Widget _buildMessageBubble(AiMessage message) {
    final isUser = message.isUser;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser)
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.blue.shade100,
              child: const Icon(
                Icons.smart_toy_rounded,
                size: 18,
                color: Colors.blueAccent,
              ),
            ),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.82,
              ),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isUser
                    ? theme.colorScheme.primary
                    : theme.colorScheme.surfaceContainerHighest.withValues(
                        alpha: 0.6,
                      ),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(14),
                  topRight: const Radius.circular(14),
                  bottomLeft: isUser
                      ? const Radius.circular(14)
                      : const Radius.circular(2),
                  bottomRight: isUser
                      ? const Radius.circular(2)
                      : const Radius.circular(14),
                ),
                border: !isUser
                    ? Border.all(color: Colors.grey.withValues(alpha: 0.2))
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isUser) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.bolt,
                              size: 14,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              'Gemini Nano ${message.processingTimeMs != null ? '• ${message.processingTimeMs}ms' : ''}',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.wifi_off,
                                size: 10,
                                color: Colors.green,
                              ),
                              SizedBox(width: 3),
                              Text(
                                'On-Device',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 12),
                  ],
                  SelectableText(
                    message.text,
                    style: TextStyle(
                      fontSize: 13.5,
                      height: 1.4,
                      color: isUser
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (!isUser && message.suggestedActions.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: message.suggestedActions.map((action) {
                        return InkWell(
                          onTap: () {
                            Clipboard.setData(
                              ClipboardData(text: message.text),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Copied "$action" to clipboard!'),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: theme.colorScheme.primary.withValues(
                                  alpha: 0.3,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.copy,
                                  size: 11,
                                  color: theme.colorScheme.primary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  action,
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (isUser) const SizedBox(width: 8),
          if (isUser)
            CircleAvatar(
              radius: 16,
              backgroundColor: theme.colorScheme.primary,
              child: const Icon(Icons.person, size: 18, color: Colors.white),
            ),
        ],
      ),
    );
  }

  Widget _buildProcessingIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 10),
          Text(
            'Gemini Nano executing local on-device inference...',
            style: TextStyle(
              fontSize: 12,
              fontStyle: FontStyle.italic,
              color: Colors.blueAccent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, -2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _inputController,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _handleSendMessage(),
              decoration: InputDecoration(
                hintText: 'Ask Gemini Nano about Flutter, AI, DBMS...',
                hintStyle: const TextStyle(fontSize: 13),
                filled: true,
                fillColor: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(
                  Icons.auto_awesome,
                  size: 18,
                  color: Colors.blueAccent,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: _isProcessing
                ? Colors.grey
                : Theme.of(context).colorScheme.primary,
            child: IconButton(
              icon: const Icon(
                Icons.send_rounded,
                color: Colors.white,
                size: 18,
              ),
              onPressed: _isProcessing ? null : () => _handleSendMessage(),
            ),
          ),
        ],
      ),
    );
  }
}
