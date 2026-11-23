import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/config.dart';
import '../../core/mock_responses.dart';

/// Talks to an OpenAI-compatible REST API: POST {baseUrl}/chat/completions
/// with { model, messages: [{ role, content }] }.
///
/// If no API key is set, returns a canned reply after a short delay
/// (mock mode) instead of touching the network.
class ChatRemoteDataSource {
  ChatRemoteDataSource({http.Client? client})
      : _client = client ?? http.Client();

  final http.Client _client;

  Future<String> complete({
    required String prompt,
    required List<Map<String, String>> history,
  }) async {
    if (AppConfig.isMockMode) {
      await Future<void>.delayed(const Duration(milliseconds: 600));
      return MockResponses.replyFor(prompt);
    }

    final response = await _client.post(
      Uri.parse('${AppConfig.baseUrl}/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AppConfig.apiKey}',
      },
      body: jsonEncode({
        'model': AppConfig.model,
        'messages': [
          ...history,
          {'role': 'user', 'content': prompt},
        ],
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'LLM API error (${response.statusCode}): ${response.body}',
      );
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final choices = data['choices'] as List<dynamic>;
    if (choices.isEmpty) {
      throw Exception('LLM API returned no choices.');
    }
    final message = choices.first['message'] as Map<String, dynamic>;
    return (message['content'] as String).trim();
  }
}
