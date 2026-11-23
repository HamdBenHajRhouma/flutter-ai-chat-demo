/// Runtime config, read from --dart-define so no key is ever in source.
///
///   flutter run --dart-define=OPENAI_API_KEY=sk-...
///   flutter run --dart-define=OPENAI_BASE_URL=https://api.openai.com/v1
///   flutter run --dart-define=OPENAI_MODEL=gpt-4o-mini
class AppConfig {
  const AppConfig._();

  static const String apiKey = String.fromEnvironment(
    'OPENAI_API_KEY',
    defaultValue: '',
  );

  static const String baseUrl = String.fromEnvironment(
    'OPENAI_BASE_URL',
    defaultValue: 'https://api.openai.com/v1',
  );

  static const String model = String.fromEnvironment(
    'OPENAI_MODEL',
    defaultValue: 'gpt-4o-mini',
  );

  /// No key set -> the data source answers from [MockResponses] instead
  /// of calling the network. The UI shows a "Mock mode" banner.
  static bool get isMockMode => apiKey.isEmpty;
}
