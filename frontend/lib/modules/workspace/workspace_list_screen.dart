import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_theme.dart';
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
        title: const Text('Jarvis AI Studio'),
        actions: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return IconButton(
                icon: Icon(themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
                tooltip: themeProvider.isDarkMode ? 'Switch to Light Theme' : 'Switch to Dark Theme',
                onPressed: () => themeProvider.toggleTheme(),
              );
            },
          ),
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
              color: isSelected ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.12) : null,
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
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: 'Upload .md or .txt file',
            icon: const Icon(Icons.upload_file, size: 20, color: Colors.blueGrey),
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              try {
                final uploaded = await context
                    .read<WorkspaceProvider>()
                    .pickAndUploadFile(workspaceName, folderName);
                if (!mounted) return;
                if (uploaded) {
                  messenger.showSnackBar(
                    SnackBar(content: Text('File uploaded to $workspaceName / $folderName')),
                  );
                }
              } catch (e) {
                if (!mounted) return;
                messenger.showSnackBar(
                  SnackBar(content: Text('Upload failed: $e'), backgroundColor: Colors.red),
                );
              }
            },
          ),
          IconButton(
            tooltip: 'Create file manually',
            icon: const Icon(Icons.note_add_outlined, size: 20),
            onPressed: () => _showAddFileDialog(context, workspaceName, folderName),
          ),
        ],
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
    final messenger = ScaffoldMessenger.of(context);
    final provider = context.read<WorkspaceProvider>();

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: Text('Add to $workspaceName / $folderName'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              OutlinedButton.icon(
                icon: const Icon(Icons.upload_file),
                label: const Text('Pick Local File (.md, .txt)'),
                onPressed: () async {
                  Navigator.pop(dialogCtx);
                  try {
                    final uploaded = await provider.pickAndUploadFile(workspaceName, folderName);
                    if (!mounted) return;
                    if (uploaded) {
                      messenger.showSnackBar(
                        SnackBar(content: Text('File uploaded to $workspaceName / $folderName')),
                      );
                    }
                  } catch (e) {
                    if (!mounted) return;
                    messenger.showSnackBar(
                      SnackBar(content: Text('Upload failed: $e'), backgroundColor: Colors.red),
                    );
                  }
                },
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('OR TYPE MANUALLY', style: TextStyle(fontSize: 11, color: Colors.grey)),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
              ),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: 'File Name (e.g. features.md)',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(
                  hintText: 'File content...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogCtx), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty) {
                final nav = Navigator.of(dialogCtx);
                try {
                  await provider.uploadFile(
                    workspaceName,
                    folderName,
                    nameController.text,
                    contentController.text,
                  );
                  nav.pop();
                } catch (e) {
                  if (!mounted) return;
                  messenger.showSnackBar(
                    SnackBar(content: Text('Save failed: $e'), backgroundColor: Colors.red),
                  );
                }
              }
            },
            child: const Text('Save File'),
          ),
        ],
      ),
    );
  }
}
