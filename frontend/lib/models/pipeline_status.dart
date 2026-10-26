class SuggestedIdea {
  final int id;
  final String title;
  final String description;
  final String platform;
  final String hook;
  final String? intent;
  final String? hookType;

  SuggestedIdea({
    required this.id,
    required this.title,
    required this.description,
    required this.platform,
    required this.hook,
    this.intent,
    this.hookType,
  });

  factory SuggestedIdea.fromJson(Map<String, dynamic> json) {
    return SuggestedIdea(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      platform: json['platform'] ?? '',
      hook: json['hook'] ?? '',
      intent: json['intent'],
      hookType: json['hookType'],
    );
  }
}

class PipelineStatus {
  final String sessionId;
  final String status;
  final String? researchData;
  final List<SuggestedIdea> suggestedIdeas;
  final String? content;
  final String? message;

  PipelineStatus({
    required this.sessionId,
    required this.status,
    this.researchData,
    this.suggestedIdeas = const [],
    this.content,
    this.message,
  });

  factory PipelineStatus.fromJson(Map<String, dynamic> json) {
    return PipelineStatus(
      sessionId: json['sessionId'] ?? '',
      status: json['status'] ?? '',
      researchData: json['researchData'],
      suggestedIdeas: (json['suggestedIdeas'] as List? ?? [])
          .map((i) => SuggestedIdea.fromJson(i))
          .toList(),
      content: json['content'],
      message: json['message'],
    );
  }
}
