import 'package:flutter/material.dart';
import '../../models/history_item.dart';
import '../../services/pipeline_service.dart';

class ChatProvider with ChangeNotifier {
  final PipelineService _service = PipelineService();
  final List<HistoryItem> _history = [];
  bool _isLoading = false;
  String? _sessionId;
  String? _currentAppName;

  List<HistoryItem> get history => _history;
  bool get isLoading => _isLoading;
  String? get currentAppName => _currentAppName;

  Future<void> startPipeline(String appName, String userPrompt) async {
    _isLoading = true;
    _currentAppName = appName;
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

  Future<void> submitAction(int id, String feedback, {String? ideaTitle}) async {
    if (_sessionId == null) return;
    _history.add(HistoryItem(
      type: HistoryItemType.userAction, 
      selectedId: id, 
      userFeedback: feedback,
      selectedTitle: ideaTitle,
    ));
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
    final actionLabel = approved 
        ? 'Approved & Saved Script' 
        : (feedback.trim().isNotEmpty ? 'Requested Revision: "$feedback"' : 'Requested Revision (Rewrite)');
    _history.add(HistoryItem(
      type: HistoryItemType.userAction, 
      userFeedback: actionLabel,
    ));
    _isLoading = true;
    notifyListeners();
    try {
      final status = await _service.submitScriptFeedback(_sessionId!, approved, feedback);
      if (status != null) {
        if (approved) {
          // Update the existing script backendOutput item to COMPLETED
          // to prevent duplicate script rendering!
          for (int i = _history.length - 1; i >= 0; i--) {
            if (_history[i].type == HistoryItemType.backendOutput &&
                _history[i].status?.content != null) {
              _history[i] = HistoryItem(
                type: HistoryItemType.backendOutput,
                status: status,
              );
              break;
            }
          }
        } else {
          _history.add(HistoryItem(type: HistoryItemType.backendOutput, status: status));
        }
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
