/// Canned replies used when no API key is set (mock mode).
/// Keeps the demo runnable anywhere, with no network and no key.
class MockResponses {
  const MockResponses._();

  static String replyFor(String prompt) {
    final text = prompt.trim().toLowerCase();
    if (text.contains('hello') || text.contains('hi')) {
      return 'Hello! This is a mock reply — set OPENAI_API_KEY to talk to a real LLM.';
    }
    if (text.contains('flutter')) {
      return 'Flutter is a UI toolkit by Google for building apps from one Dart codebase. (Mock reply — no API key set.)';
    }
    return 'Mock reply to "$prompt". Set OPENAI_API_KEY via --dart-define to get a real answer.';
  }
}
