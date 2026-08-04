import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/workspace.dart';

class WorkspaceService {
  static const String baseUrl = 'http://localhost:8080/workspaces';

  Future<List<Workspace>> getWorkspaces() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Workspace.fromJson(json)).toList();
    }
    throw Exception('Failed to load workspaces');
  }

  Future<Workspace> createWorkspace(String name) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      body: json.encode({'name': name}),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Workspace.fromJson(json.decode(response.body));
    }
    throw Exception('Failed to create workspace');
  }

  Future<void> deleteWorkspace(String name) async {
    final response = await http.delete(Uri.parse('$baseUrl/$name'));
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete workspace');
    }
  }

  Future<void> addFileToFolder(String workspaceName, String folderName, String fileName, String content) async {
    // Dynamic folder path: /workspaces/{name}/{folderName}?fileName={fileName}
    final url = Uri.parse('$baseUrl/$workspaceName/$folderName').replace(
      queryParameters: {'fileName': fileName},
    );
    
    final response = await http.post(
      url,
      body: content,
      headers: {'Content-Type': 'text/plain'},
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to add file to $folderName');
    }
  }
}
