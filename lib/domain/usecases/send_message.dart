import '../entities/chat_message.dart';
import '../repositories/chat_repository.dart';

/// Single use case: validate the prompt, then ask the repository.
/// Kept thin on purpose — the interesting logic lives in the data layer.
class SendMessageUseCase {
  const SendMessageUseCase(this._repository);

  final ChatRepository _repository;

  Future<ChatMessage> call(String prompt, List<ChatMessage> history) {
    final trimmed = prompt.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError('Message must not be empty.');
    }
    return _repository.sendMessage(trimmed, history);
  }
}
