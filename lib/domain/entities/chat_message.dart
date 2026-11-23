enum MessageRole { user, assistant }

/// One chat message. Domain layer — no Flutter, no http, no JSON here.
class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.role,
    required this.text,
    required this.createdAt,
  });

  factory ChatMessage.user(String text) => ChatMessage(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        role: MessageRole.user,
        text: text,
        createdAt: DateTime.now(),
      );

  factory ChatMessage.assistant(String text) => ChatMessage(
        id: 'a-${DateTime.now().microsecondsSinceEpoch}',
        role: MessageRole.assistant,
        text: text,
        createdAt: DateTime.now(),
      );

  final String id;
  final MessageRole role;
  final String text;
  final DateTime createdAt;

  bool get isUser => role == MessageRole.user;
}
