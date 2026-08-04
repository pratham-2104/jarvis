enum StepType { info, idea, script, error }

class AgentStep {
  final String agentName;
  final String content;
  final StepType type;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;

  AgentStep({
    required this.agentName,
    required this.content,
    required this.type,
    DateTime? timestamp,
    this.metadata,
  }) : timestamp = timestamp ?? DateTime.now();

  factory AgentStep.fromJson(Map<String, dynamic> json) {
    return AgentStep(
      agentName: json['agentName'] ?? 'System',
      content: json['content'] ?? '',
      type: StepType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => StepType.info,
      ),
      metadata: json['metadata'],
    );
  }
}
