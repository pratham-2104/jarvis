import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pipeline_status.dart';

class PipelineService {
  static const String baseUrl = 'http://localhost:8080/pipeline';

  Future<PipelineStatus?> startPipeline(String appName, String userPrompt) async {
    final response = await http.post(
      Uri.parse('$baseUrl/start'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'appName': appName, 'userPrompt': userPrompt}),
    );
    if (response.statusCode == 200) {
      return PipelineStatus.fromJson(json.decode(response.body));
    }
    throw Exception('Failed to start: ${response.statusCode}');
  }

  Future<PipelineStatus?> selectIdea(String sessionId, int ideaId, String feedback) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$sessionId/idea-selection'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'selectedId': ideaId, 'feedback': feedback}),
    );
    if (response.statusCode == 200) {
      return PipelineStatus.fromJson(json.decode(response.body));
    }
    throw Exception('Failed selection: ${response.statusCode}');
  }

  Future<PipelineStatus?> submitScriptFeedback(String sessionId, bool approved, String feedback) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$sessionId/script-feedback'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'approved': approved, 'feedback': feedback}),
    );
    if (response.statusCode == 200) {
      return PipelineStatus.fromJson(json.decode(response.body));
    }
    throw Exception('Failed script feedback: ${response.statusCode}');
  }
}
