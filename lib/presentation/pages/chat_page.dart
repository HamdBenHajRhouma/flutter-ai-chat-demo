import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/chat_provider.dart';
import '../widgets/chat_input.dart';
import '../widgets/message_bubble.dart';

/// The only screen: message list, loading indicator, error banner,
/// mock-mode banner, and the input row.
class ChatPage extends ConsumerWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(chatProvider);
    final notifier = ref.read(chatProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('AI Chat Demo')),
      body: Column(
        children: [
          if (notifier.isMockMode)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              color: Colors.amber.shade100,
              child: const Text(
                'Mock mode — no API key set. Set OPENAI_API_KEY to use a real LLM.',
                textAlign: TextAlign.center,
              ),
            ),
          if (state.error != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              color: Colors.red.shade100,
              child: Row(
                children: [
                  Expanded(child: Text(state.error!)),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: notifier.clearError,
                    tooltip: 'Dismiss',
                  ),
                ],
              ),
            ),
          Expanded(
            child: state.messages.isEmpty
                ? const Center(
                    child: Text('Say hello to start chatting.'),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) =>
                        MessageBubble(message: state.messages[index]),
                  ),
          ),
          if (state.isLoading)
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 8),
                  Text('Thinking…'),
                ],
              ),
            ),
          ChatInput(onSend: notifier.send, isLoading: state.isLoading),
        ],
      ),
    );
  }
}
