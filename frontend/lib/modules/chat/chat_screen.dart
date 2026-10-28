import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/app_theme.dart';
import 'chat_provider.dart';
import '../../models/history_item.dart';
import '../../models/pipeline_status.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  int _lastHistoryLength = 0;
  bool _lastLoadingState = false;

  void _scrollToBottomIfNeeded(int currentLength, bool isLoading) {
    if (currentLength > _lastHistoryLength || (isLoading && !_lastLoadingState)) {
      _lastHistoryLength = currentLength;
      _lastLoadingState = isLoading;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    } else {
      _lastLoadingState = isLoading;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jarvis Pipeline Studio'),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            tooltip: isDark ? 'Switch to Light Theme' : 'Switch to Dark Theme',
            onPressed: () => themeProvider.toggleTheme(),
          ),
        ],
      ),
      body: Consumer<ChatProvider>(
        builder: (context, provider, child) {
          final isCompleted = provider.history.any((h) => h.status?.status == 'COMPLETED');
          final extraItemCount = (provider.isLoading ? 1 : 0) + (isCompleted ? 1 : 0);

          _scrollToBottomIfNeeded(provider.history.length + extraItemCount, provider.isLoading);

          return ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: provider.history.length + extraItemCount,
            itemBuilder: (context, index) {
              if (index < provider.history.length) {
                final item = provider.history[index];
                if (item.type == HistoryItemType.userAction) {
                  return _buildUserAction(context, item, isDark);
                }

                // Check if any userAction or another backendOutput happened after this item
                bool hasSubsequentAction = false;
                for (int i = index + 1; i < provider.history.length; i++) {
                  if (provider.history[i].type == HistoryItemType.userAction ||
                      provider.history[i].type == HistoryItemType.backendOutput) {
                    hasSubsequentAction = true;
                    break;
                  }
                }

                // Only actionable if user hasn't acted yet AND system is not loading
                bool isActionable = !hasSubsequentAction && !provider.isLoading;

                return _buildBackendOutput(context, item, isDark, isActionable: isActionable);
              }

              // Trailing items: Loader first, then Completion Card at the very bottom
              if (provider.isLoading && index == provider.history.length) {
                return _buildLoader();
              }

              if (isCompleted) {
                return _buildCompletionCard(context, isDark);
              }

              return const SizedBox.shrink();
            },
          );
        },
      ),
    );
  }

  Widget _buildLoader() => const Padding(
        padding: EdgeInsets.all(24),
        child: Center(
          child: Column(
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 12),
              Text('Agents are reasoning and generating content...',
                  style: TextStyle(fontSize: 13, color: Colors.grey)),
            ],
          ),
        ),
      );

  Widget _buildUserAction(BuildContext context, HistoryItem item, bool isDark) {
    String badgeText = 'ACTION';
    Color badgeColor = AppTheme.primaryIndigo;
    String mainTitle = '';
    String? subFeedback = item.userFeedback?.trim();

    if (item.selectedId == 0) {
      badgeText = 'RESEARCH';
      badgeColor = AppTheme.accentCyan;
      mainTitle = 'Requested: Do Research Again with new feedback';
    } else if (item.selectedId != null && item.selectedId! > 0) {
      badgeText = 'SELECTED IDEA #${item.selectedId}';
      badgeColor = AppTheme.accentEmerald;
      if (item.selectedTitle != null && item.selectedTitle!.isNotEmpty) {
        mainTitle = item.selectedTitle!;
      } else {
        mainTitle = 'Proceed with Idea #${item.selectedId}';
      }
    } else {
      mainTitle = item.userFeedback ?? 'Action confirmed';
      subFeedback = null;
    }

    final hasExtraFeedback = subFeedback != null &&
        subFeedback.isNotEmpty &&
        subFeedback != mainTitle &&
        !mainTitle.contains(subFeedback);

    return Card(
      color: isDark ? const Color(0xFF161F38) : const Color(0xFFEEF2FF),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDark ? AppTheme.primaryIndigo.withValues(alpha: 0.5) : const Color(0xFFC7D2FE),
          width: 1.2,
        ),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: badgeColor.withValues(alpha: isDark ? 0.2 : 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check, size: 18, color: badgeColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: badgeColor.withValues(alpha: isDark ? 0.25 : 0.15),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: badgeColor.withValues(alpha: 0.6)),
                        ),
                        child: Text(
                          badgeText,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : badgeColor,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    mainTitle,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                      height: 1.3,
                    ),
                  ),
                  if (hasExtraFeedback) ...[
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.04),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.chat_bubble_outline, size: 14, color: AppTheme.accentAmber),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Feedback: "$subFeedback"',
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark ? Colors.white70 : const Color(0xFF475569),
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackendOutput(BuildContext context, HistoryItem item, bool isDark, {required bool isActionable}) {
    final status = item.status!;
    final isAwaitingIdea = status.status == 'AWAITING_IDEA_APPROVAL';

    return Column(
      children: [
        if (status.researchData != null) _buildResearchSection(context, status.researchData!, isDark),
        if (status.suggestedIdeas.isNotEmpty && (status.status.contains('IDEA') || status.status.contains('RESEARCH')))
          ...status.suggestedIdeas.map((idea) => _buildIdeaCard(context, idea, isDark, isActionable: isActionable && isAwaitingIdea)),
        if (isActionable && isAwaitingIdea) 
          _buildRedoSection(context, isDark),
        if (status.content != null) _buildScriptSection(context, status, isDark),
      ],
    );
  }

  Widget _buildResearchSection(BuildContext context, String data, bool isDark) => Card(
        margin: const EdgeInsets.only(bottom: 16),
        child: ExpansionTile(
          shape: const Border(),
          collapsedShape: const Border(),
          leading: const Icon(Icons.travel_explore, color: AppTheme.accentCyan),
          title: const Text('Research Summary & Market Intel', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: isDark ? AppTheme.darkSurface : const Color(0xFFF8FAFC),
              child: SelectableText(
                data,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.5,
                  color: isDark ? Colors.white70 : const Color(0xFF334155),
                ),
              ),
            ),
          ],
        ),
      );

  Widget _buildIdeaCard(BuildContext context, dynamic idea, bool isDark, {required bool isActionable}) {
    final controller = TextEditingController();

    Color getIntentColor(String? intent) {
      switch (intent?.toLowerCase()) {
        case 'growth':
          return AppTheme.accentEmerald;
        case 'authority':
          return AppTheme.accentPurple;
        case 'connection':
          return AppTheme.accentAmber;
        case 'objection':
          return AppTheme.accentCyan;
        default:
          return Colors.grey;
      }
    }

    final intentColor = getIntentColor(idea.intent);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                if (idea.intent != null && idea.intent.toString().isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: intentColor.withValues(alpha: isDark ? 0.2 : 0.12),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: intentColor.withValues(alpha: 0.5)),
                    ),
                    child: Text(
                      idea.intent.toString().toUpperCase(),
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: intentColor),
                    ),
                  ),
                if (idea.hookType != null && idea.hookType.toString().isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.accentAmber.withValues(alpha: isDark ? 0.18 : 0.1),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppTheme.accentAmber.withValues(alpha: 0.4)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.flash_on, size: 13, color: AppTheme.accentAmber),
                        const SizedBox(width: 4),
                        Text(
                          idea.hookType.toString(),
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: isDark ? Colors.amber.shade200 : Colors.amber.shade900),
                        ),
                      ],
                    ),
                  ),
                if (idea.platform != null && idea.platform.toString().isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      idea.platform.toString(),
                      style: TextStyle(fontSize: 11, color: isDark ? Colors.white70 : Colors.black87),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(idea.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              idea.description,
              style: TextStyle(
                color: isDark ? Colors.white70 : const Color(0xFF475569),
                height: 1.4,
                fontSize: 14,
              ),
            ),
            if (idea.hook != null && idea.hook.toString().isNotEmpty) ...[
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.darkSurface : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('🪝 ', style: TextStyle(fontSize: 16)),
                    Expanded(
                      child: Text(
                        'Hook: "${idea.hook}"',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (isActionable) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        hintText: 'Feedback or refinement (optional)...',
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => context.read<ChatProvider>().submitAction(
                          idea.id,
                          controller.text,
                          ideaTitle: idea.title,
                        ),
                    child: const Text('Select Idea'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildScriptSection(BuildContext context, PipelineStatus status, bool isDark) {
    final controller = TextEditingController();
    final rawContent = status.content ?? '';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.auto_awesome, color: AppTheme.primaryIndigo, size: 24),
                const SizedBox(width: 10),
                const Text(
                  'REPURPOSED CONTENT SUITE',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 0.3),
                ),
                const Spacer(),
                FilledButton.tonalIcon(
                  icon: const Icon(Icons.copy_rounded, size: 16),
                  label: const Text('Copy Entire Suite', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: rawContent));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Copied all repurposed formats to clipboard!')),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.darkSurface : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder),
              ),
              child: SelectableText(
                rawContent,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 13,
                  height: 1.5,
                  color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF1E293B),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            if (status.status == 'COMPLETED') ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppTheme.accentEmerald.withValues(alpha: isDark ? 0.2 : 0.12),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.accentEmerald.withValues(alpha: 0.5)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.check_circle, size: 18, color: AppTheme.accentEmerald),
                    SizedBox(width: 8),
                    Text(
                      'Approved & Saved to Workspace scripts/',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: AppTheme.accentEmerald,
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'Revision feedback for rewrite...',
                  isDense: true,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => context.read<ChatProvider>().submitScriptAction(false, controller.text),
                    child: const Text('Request Revision'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.check_circle_outline, size: 18),
                    onPressed: () => context.read<ChatProvider>().submitScriptAction(true, 'Approved'),
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentEmerald),
                    label: const Text('Approve & Save Suite'),
                  ),
                ],
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildRedoSection(BuildContext context, bool isDark) {
    final controller = TextEditingController();
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 30),
      child: Column(
        children: [
          TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Why redo research? (Mandatory to explore different angles)',
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                context.read<ChatProvider>().submitAction(
                      0,
                      controller.text.trim(),
                      ideaTitle: 'Redo Research',
                    );
              }
            },
            label: const Text('Do Research Again with Feedback'),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletionCard(BuildContext context, bool isDark) {
    final chatProvider = context.read<ChatProvider>();
    return Card(
      color: AppTheme.accentEmerald.withValues(alpha: isDark ? 0.15 : 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: AppTheme.accentEmerald, width: 1.5),
      ),
      margin: const EdgeInsets.symmetric(vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Row(
              children: [
                Icon(Icons.check_circle, color: AppTheme.accentEmerald, size: 36),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'PIPELINE COMPLETED\nFull content suite saved successfully to workspace!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.arrow_back, size: 18),
                    label: const Text('Change Workspace'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text('Run Again (New Idea)'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accentEmerald,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      if (chatProvider.currentAppName != null) {
                        chatProvider.startPipeline(chatProvider.currentAppName!, '');
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
