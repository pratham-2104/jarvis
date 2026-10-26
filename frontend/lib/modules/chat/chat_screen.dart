import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jarvis Pipeline')),
      body: Consumer<ChatProvider>(
        builder: (context, provider, child) {
          _scrollToBottom();
          return ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: provider.history.length + (provider.isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == provider.history.length) return _buildLoader();
              final item = provider.history[index];
              if (item.type == HistoryItemType.userAction) {
                return _buildUserAction(item);
              }
              // Determine if we should show Research/Ideas for this specific block
              bool isFirstOutput = index == 0 || (index > 0 && provider.history[index - 1].selectedId == 0);
              return _buildBackendOutput(context, item, showAll: isFirstOutput);
            },
          );
        },
      ),
    );
  }

  Widget _buildLoader() => const Padding(
      padding: EdgeInsets.all(20),
      child: Center(child: CircularProgressIndicator()));

  Widget _buildUserAction(HistoryItem item) => Card(
        color: Colors.blue.shade50,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Text('User: ${item.userFeedback}',
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
      );

  Widget _buildBackendOutput(BuildContext context, HistoryItem item, {required bool showAll}) {
    final status = item.status!;
    return Column(
      children: [
        // Only show Research if it's the first output or a Redo Research occurred
        if (showAll && status.researchData != null) _buildResearchSection(status.researchData!),
        
        // Only show Ideas if we are in Idea Approval stage AND (it's first output or a Redo/Refine)
        if (showAll && status.suggestedIdeas.isNotEmpty && (status.status.contains('IDEA') || status.status.contains('RESEARCH')))
          ...status.suggestedIdeas.map((idea) => _buildIdeaCard(context, idea)),
        
        // Always show the Redo section if we are in Idea stage
        if (status.status == 'AWAITING_IDEA_APPROVAL' || status.status.contains('IDEA')) 
          _buildRedoSection(context),
        
        // Show Script if present
        if (status.content != null) _buildScriptSection(context, status),
        
        // Show Completion
        if (status.status == 'COMPLETED') _buildCompletionCard(),
      ],
    );
  }

  Widget _buildResearchSection(String data) => ExpansionTile(
      title: const Text('Research Summary', style: TextStyle(fontWeight: FontWeight.bold)),
      children: [Padding(padding: const EdgeInsets.all(12), child: Text(data))]);

  Widget _buildIdeaCard(BuildContext context, dynamic idea) {
    final controller = TextEditingController();
    
    Color getIntentColor(String? intent) {
      switch (intent?.toLowerCase()) {
        case 'growth':
          return Colors.green.shade100;
        case 'authority':
          return Colors.purple.shade100;
        case 'connection':
          return Colors.orange.shade100;
        case 'objection':
          return Colors.blue.shade100;
        default:
          return Colors.grey.shade200;
      }
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                if (idea.intent != null && idea.intent.toString().isNotEmpty)
                  Chip(
                    label: Text(
                      idea.intent.toString().toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                    backgroundColor: getIntentColor(idea.intent),
                    visualDensity: VisualDensity.compact,
                  ),
                if (idea.hookType != null && idea.hookType.toString().isNotEmpty)
                  Chip(
                    avatar: const Icon(Icons.flash_on, size: 14, color: Colors.amber),
                    label: Text(
                      idea.hookType.toString(),
                      style: const TextStyle(fontSize: 11),
                    ),
                    backgroundColor: Colors.amber.shade50,
                    visualDensity: VisualDensity.compact,
                  ),
                if (idea.platform != null && idea.platform.toString().isNotEmpty)
                  Chip(
                    label: Text(
                      idea.platform.toString(),
                      style: const TextStyle(fontSize: 11),
                    ),
                    backgroundColor: Colors.grey.shade100,
                    visualDensity: VisualDensity.compact,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(idea.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(idea.description, style: TextStyle(color: Colors.grey.shade800, height: 1.3)),
            if (idea.hook != null && idea.hook.toString().isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blueGrey.shade200),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('🪝 ', style: TextStyle(fontSize: 16)),
                    Expanded(
                      child: Text(
                        'Hook: "${idea.hook}"',
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const Divider(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: 'Feedback or refinement (optional)',
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => context.read<ChatProvider>().submitAction(idea.id, controller.text),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  child: const Text('Select Idea'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildScriptSection(BuildContext context, PipelineStatus status) {
    final controller = TextEditingController();
    return Card(
      color: Colors.grey.shade50,
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('GENERATED SCRIPT', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)),
            const Divider(),
            Text(status.content ?? ''),
            const Divider(),
            if (status.status != 'COMPLETED') ...[
              TextField(controller: controller, decoration: const InputDecoration(hintText: 'Revision Feedback (for Rewrite)')),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => context.read<ChatProvider>().submitScriptAction(false, controller.text),
                    child: const Text('Revision (Rewrite)'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () => context.read<ChatProvider>().submitScriptAction(true, 'Approved'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade100),
                    child: const Text('Approve & Save'),
                  ),
                ],
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildRedoSection(BuildContext context) {
    final controller = TextEditingController();
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 40),
      child: Column(
        children: [
          TextField(controller: controller, decoration: const InputDecoration(hintText: 'Why redo research? (Mandatory)', border: OutlineInputBorder())),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              if (controller.text.isNotEmpty) context.read<ChatProvider>().submitAction(0, controller.text);
            },
            label: const Text('Do Research Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletionCard() => const Card(
        color: Colors.green,
        margin: EdgeInsets.symmetric(vertical: 30),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 40),
              SizedBox(width: 16),
              Expanded(child: Text('PIPELINE COMPLETED\nScript saved successfully!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))),
            ],
          ),
        ),
      );
}
