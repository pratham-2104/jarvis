import 'package:flutter/material.dart';
import '../../models/workspace.dart';
import '../../services/workspace_service.dart';

class WorkspaceProvider with ChangeNotifier {
  final WorkspaceService _service = WorkspaceService();
  
  List<Workspace> _workspaces = [];
  Workspace? _selectedWorkspace;
  bool _isLoading = false;

  List<Workspace> get workspaces => _workspaces;
  Workspace? get selectedWorkspace => _selectedWorkspace;
  bool get isLoading => _isLoading;

  Future<void> fetchWorkspaces() async {
    _isLoading = true;
    notifyListeners();
    try {
      _workspaces = await _service.getWorkspaces();
    } catch (e) {
      debugPrint('Error fetching workspaces: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectWorkspace(Workspace workspace) {
    _selectedWorkspace = workspace;
    notifyListeners();
  }

  Future<void> addWorkspace(String name) async {
    try {
      await _service.createWorkspace(name);
      await fetchWorkspaces();
    } catch (e) {
      debugPrint('Error adding workspace: $e');
    }
  }

  Future<void> deleteWorkspace(String name) async {
    try {
      await _service.deleteWorkspace(name);
      _workspaces.removeWhere((w) => w.name == name);
      if (_selectedWorkspace?.name == name) _selectedWorkspace = null;
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting workspace: $e');
    }
  }

  Future<void> uploadFile(String folderName, String fileName, String content) async {
    if (_selectedWorkspace == null) return;
    try {
      await _service.addFileToFolder(_selectedWorkspace!.name, folderName, fileName, content);
      await fetchWorkspaces(); 
    } catch (e) {
      debugPrint('Error uploading file: $e');
    }
  }
}
