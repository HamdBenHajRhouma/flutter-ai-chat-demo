import 'package:flutter_ai_chat_demo/domain/entities/chat_message.dart';
import 'package:flutter_ai_chat_demo/domain/repositories/chat_repository.dart';
import 'package:flutter_ai_chat_demo/domain/usecases/send_message.dart';
import 'package:flutter_test/flutter_test.dart';

/// Fake repository: echoes the prompt back, and records what it received
/// so the test can check the history was passed through.
class FakeChatRepository implements ChatRepository {
  List<ChatMessage> lastHistory = [];
  String lastPrompt = '';

  @override
  Future<ChatMessage> sendMessage(
    String prompt,
    List<ChatMessage> history,
  ) async {
    lastPrompt = prompt;
    lastHistory = history;
    return ChatMessage.assistant('Reply to: $prompt');
  }
}

void main() {
  test('use case returns the assistant reply and passes history through',
      () async {
    final fake = FakeChatRepository();
    final useCase = SendMessageUseCase(fake);
    final history = [ChatMessage.user('Hello')];

    final reply = await useCase('How are you?', history);

    expect(reply.role, MessageRole.assistant);
    expect(reply.text, 'Reply to: How are you?');
    expect(fake.lastPrompt, 'How are you?');
    expect(fake.lastHistory, history);
  });

  test('use case rejects an empty message', () async {
    final useCase = SendMessageUseCase(FakeChatRepository());

    expect(
      () => useCase('   ', const []),
      throwsArgumentError,
    );
  });
}
