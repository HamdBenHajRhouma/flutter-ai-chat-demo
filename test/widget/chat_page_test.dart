import 'package:flutter/material.dart';
import 'package:flutter_ai_chat_demo/domain/entities/chat_message.dart';
import 'package:flutter_ai_chat_demo/domain/repositories/chat_repository.dart';
import 'package:flutter_ai_chat_demo/domain/usecases/send_message.dart';
import 'package:flutter_ai_chat_demo/presentation/pages/chat_page.dart';
import 'package:flutter_ai_chat_demo/presentation/providers/chat_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeChatRepository implements ChatRepository {
  @override
  Future<ChatMessage> sendMessage(
    String prompt,
    List<ChatMessage> history,
  ) async =>
      ChatMessage.assistant('Mock reply to: $prompt');
}

void main() {
  testWidgets('chat page renders, accepts input, and shows a reply',
      (tester) async {
    final notifier = ChatNotifier(SendMessageUseCase(FakeChatRepository()));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          chatProvider.overrideWith((ref) => notifier),
        ],
        child: const MaterialApp(home: ChatPage()),
      ),
    );

    expect(find.text('Say hello to start chatting.'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Hello AI');
    await tester.tap(find.byKey(const Key('send-button')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Hello AI'), findsOneWidget);
    expect(find.text('Mock reply to: Hello AI'), findsOneWidget);
  });
}
