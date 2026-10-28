import '../models/pipeline_status.dart';

enum HistoryItemType { backendOutput, userAction }

class HistoryItem {
  final HistoryItemType type;
  final PipelineStatus? status;
  final String? userFeedback;
  final int? selectedId;
  final String? selectedTitle;
  final DateTime timestamp;

  HistoryItem({
    required this.type,
    this.status,
    this.userFeedback,
    this.selectedId,
    this.selectedTitle,
  }) : timestamp = DateTime.now();
}
