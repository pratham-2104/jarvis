import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
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
      if (_selectedWorkspace != null) {
        _selectedWorkspace = _workspaces.firstWhere(
          (w) => w.name == _selectedWorkspace!.name,
          orElse: () => _workspaces.isNotEmpty ? _workspaces.first : _selectedWorkspace!,
        );
      }
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

  Future<void> uploadFile(String workspaceName, String folderName, String fileName, String content) async {
    try {
      await _service.addFileToFolder(workspaceName, folderName, fileName, content);
      await fetchWorkspaces();
    } catch (e) {
      debugPrint('Error uploading file: $e');
      rethrow;
    }
  }

  Future<bool> pickAndUploadFile(String workspaceName, String folderName) async {
    try {
      final files = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['md', 'txt'],
      );

      if (files.isEmpty) {
        return false;
      }

      final pickedFile = files.first;
      final bytes = await pickedFile.readAsBytes();
      final content = utf8.decode(bytes);

      await uploadFile(workspaceName, folderName, pickedFile.name, content);
      return true;
    } catch (e) {
      debugPrint('Error picking and uploading file: $e');
      rethrow;
    }
  }
}
