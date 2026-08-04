import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'workspace_provider.dart';
import '../chat/chat_screen.dart';
import '../chat/chat_provider.dart';

class WorkspaceListScreen extends StatefulWidget {
  const WorkspaceListScreen({super.key});

  @override
  State<WorkspaceListScreen> createState() => _WorkspaceListScreenState();
}

class _WorkspaceListScreenState extends State<WorkspaceListScreen> {
  final TextEditingController _promptController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WorkspaceProvider>().fetchWorkspaces();
    });
  }

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jarvis Workspaces'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<WorkspaceProvider>().fetchWorkspaces(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: _buildWorkspaceList()),
          _buildActionPanel(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddWorkspaceDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildWorkspaceList() {
    return Consumer<WorkspaceProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) return const Center(child: CircularProgressIndicator());
        if (provider.workspaces.isEmpty) return const Center(child: Text('No workspaces.'));

        return ListView.builder(
          itemCount: provider.workspaces.length,
          itemBuilder: (context, index) {
            final w = provider.workspaces[index];
            final isSelected = provider.selectedWorkspace?.name == w.name;
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              color: isSelected ? Colors.blue.shade50 : null,
              child: ExpansionTile(
                leading: const Icon(Icons.workspaces_outline),
                title: Text(w.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => provider.deleteWorkspace(w.name),
                    ),
                    const Icon(Icons.expand_more),
                  ],
                ),
                onExpansionChanged: (expanded) {
                  if (expanded) provider.selectWorkspace(w);
                },
                children: w.folders.entries.map((entry) => _buildFolderTile(w.name, entry.key, entry.value)).toList(),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFolderTile(String workspaceName, String folderName, List<String> files) {
    return ExpansionTile(
      leading: const Icon(Icons.folder_open, size: 20),
      title: Text(folderName),
      trailing: IconButton(
        icon: const Icon(Icons.add_circle_outline, size: 20),
        onPressed: () => _showAddFileDialog(context, workspaceName, folderName),
      ),
      children: files.map((file) => ListTile(
        contentPadding: const EdgeInsets.only(left: 72),
        leading: const Icon(Icons.description_outlined, size: 16),
        title: Text(file, style: const TextStyle(fontSize: 14)),
      )).toList(),
    );
  }

  Widget _buildActionPanel() {
    return Consumer<WorkspaceProvider>(
      builder: (context, provider, child) {
        if (provider.selectedWorkspace == null) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _promptController,
                decoration: InputDecoration(
                  hintText: 'Add optional prompt for ${provider.selectedWorkspace!.name}...',
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () {
                  context.read<ChatProvider>().startPipeline(
                    provider.selectedWorkspace!.name,
                    _promptController.text,
                  );
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatScreen()));
                },
                icon: const Icon(Icons.play_arrow),
                label: Text('Start Pipeline for ${provider.selectedWorkspace!.name}'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: Colors.blue.shade100,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddWorkspaceDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Workspace'),
        content: TextField(controller: controller, decoration: const InputDecoration(hintText: 'Name')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                context.read<WorkspaceProvider>().addWorkspace(controller.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showAddFileDialog(BuildContext context, String workspaceName, String folderName) {
    final nameController = TextEditingController();
    final contentController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add to $workspaceName / $folderName'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(hintText: 'File Name')),
            TextField(controller: contentController, decoration: const InputDecoration(hintText: 'Content')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              context.read<WorkspaceProvider>().uploadFile(folderName, nameController.text, contentController.text);
              Navigator.pop(context);
            },
            child: const Text('Upload'),
          ),
        ],
      ),
    );
  }
}
