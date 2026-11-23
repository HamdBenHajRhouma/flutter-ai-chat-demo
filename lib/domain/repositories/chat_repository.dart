import '../entities/chat_message.dart';

/// Domain contract: send a prompt with the conversation so far,
/// get the assistant's reply back.
abstract class ChatRepository {
  Future<ChatMessage> sendMessage(
    String prompt,
    List<ChatMessage> history,
  );
}
