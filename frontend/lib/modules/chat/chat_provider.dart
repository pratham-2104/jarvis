import 'package:flutter/material.dart';
import '../../models/history_item.dart';
import '../../services/pipeline_service.dart';

class ChatProvider with ChangeNotifier {
  final PipelineService _service = PipelineService();
  final List<HistoryItem> _history = [];
  bool _isLoading = false;
  String? _sessionId;

  List<HistoryItem> get history => _history;
  bool get isLoading => _isLoading;

  Future<void> startPipeline(String appName, String userPrompt) async {
    _isLoading = true;
    _history.clear();
    notifyListeners();
    try {
      final status = await _service.startPipeline(appName, userPrompt);
      if (status != null) {
        _sessionId = status.sessionId;
        _history.add(HistoryItem(type: HistoryItemType.backendOutput, status: status));
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> submitAction(int id, String feedback) async {
    if (_sessionId == null) return;
    _history.add(HistoryItem(type: HistoryItemType.userAction, selectedId: id, userFeedback: feedback));
    _isLoading = true;
    notifyListeners();
    try {
      final status = await _service.selectIdea(_sessionId!, id, feedback);
      if (status != null) {
        _history.add(HistoryItem(type: HistoryItemType.backendOutput, status: status));
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> submitScriptAction(bool approved, String feedback) async {
    if (_sessionId == null) return;
    _history.add(HistoryItem(
      type: HistoryItemType.userAction, 
      userFeedback: '${approved ? "APPROVED" : "REVISION"}: $feedback',
    ));
    _isLoading = true;
    notifyListeners();
    try {
      final status = await _service.submitScriptFeedback(_sessionId!, approved, feedback);
      if (status != null) {
        _history.add(HistoryItem(type: HistoryItemType.backendOutput, status: status));
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void reset() {
    _history.clear();
    _sessionId = null;
    _isLoading = false;
    notifyListeners();
  }
}
