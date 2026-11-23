import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/chat_remote_data_source.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/usecases/send_message.dart';
import '../../core/config.dart';

/// UI state for the chat screen: messages, loading, and the last error.
class ChatState {
  const ChatState({
    this.messages = const [],
    this.isLoading = false,
    this.error,
  });

  final List<ChatMessage> messages;
  final bool isLoading;
  final String? error;

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    String? error,
  }) =>
      ChatState(
        messages: messages ?? this.messages,
        isLoading: isLoading ?? this.isLoading,
        error: error,
      );
}

class ChatNotifier extends StateNotifier<ChatState> {
  ChatNotifier(this._sendMessage) : super(const ChatState());

  final SendMessageUseCase _sendMessage;

  bool get isMockMode => AppConfig.isMockMode;

  Future<void> send(String prompt) async {
    final trimmed = prompt.trim();
    if (trimmed.isEmpty || state.isLoading) return;

    final userMessage = ChatMessage.user(trimmed);
    final history = [...state.messages, userMessage];
    state = state.copyWith(messages: history, isLoading: true, error: null);

    try {
      final reply = await _sendMessage(trimmed, history);
      state = state.copyWith(
        messages: [...state.messages, reply],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Could not get a reply: $e',
      );
    }
  }

  void clearError() => state = state.copyWith(error: null);
}

/// Default wiring (real data source). Tests override this provider.
final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  final dataSource = ChatRemoteDataSource();
  final repository = ChatRepositoryImpl(dataSource);
  return ChatNotifier(SendMessageUseCase(repository));
});
