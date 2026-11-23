import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_data_source.dart';

/// Data layer: maps domain messages to the API wire format and back.
class ChatRepositoryImpl implements ChatRepository {
  const ChatRepositoryImpl(this._dataSource);

  final ChatRemoteDataSource _dataSource;

  @override
  Future<ChatMessage> sendMessage(
    String prompt,
    List<ChatMessage> history,
  ) async {
    final wireHistory = history
        .map((m) => {
              'role': m.isUser ? 'user' : 'assistant',
              'content': m.text,
            })
        .toList();

    final reply = await _dataSource.complete(
      prompt: prompt,
      history: wireHistory,
    );
    return ChatMessage.assistant(reply);
  }
}
