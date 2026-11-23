# Flutter AI Chat Demo

A small, public demo app by **Hamdi Ben Haj Rhouma** — a Flutter chatbot that
talks to an LLM through an OpenAI-compatible REST API.

> This is a demo, not a production app. It is published so recruiters can see
> real, readable Flutter code. No downloads, users, or production claims.

## What it demonstrates

- **Flutter + Dart** — chat UI, loading and error states
- **Riverpod** — state management (`StateNotifierProvider`)
- **Clean Architecture** — `lib/domain`, `lib/data`, `lib/presentation`
- **REST API integration** — OpenAI-compatible `/chat/completions` endpoint
- **LLM API integration** — chat history is sent with each request
- **Mock mode** — works with no API key, so the UI and tests run anywhere
- **Tests** — 1 unit test + 1 widget test

## Project structure

```text
lib/
  main.dart                          # Wiring: data source -> repository -> use case -> provider
  core/
    config.dart                      # API key / base URL / model from --dart-define
    mock_responses.dart              # Canned replies used in mock mode
  domain/
    entities/chat_message.dart       # ChatMessage + MessageRole
    repositories/chat_repository.dart
    usecases/send_message.dart
  data/
    datasources/chat_remote_data_source.dart  # http POST to /chat/completions, or mock
    repositories/chat_repository_impl.dart
  presentation/
    providers/chat_provider.dart     # ChatNotifier + ChatState
    pages/chat_page.dart
    widgets/message_bubble.dart
    widgets/chat_input.dart
test/
  unit/send_message_test.dart
  widget/chat_page_test.dart
```

## Setup

```bash
flutter pub get
```

### Run in mock mode (no key needed)

```bash
flutter run
```

The app shows a "Mock mode" banner and answers with a canned reply.
This is the default — good for a quick look at the UI.

### Run with a real LLM API key

Use `--dart-define` (recommended — the key never touches a file):

```bash
flutter run \
  --dart-define=OPENAI_API_KEY=sk-your-key-here \
  --dart-define=OPENAI_BASE_URL=https://api.openai.com/v1 \
  --dart-define=OPENAI_MODEL=gpt-4o-mini
```

Any OpenAI-compatible endpoint works: change `OPENAI_BASE_URL` to your
provider's URL. The request body is the standard `chat/completions` format
(`model`, `messages: [{role, content}]`).

## Run the tests

```bash
flutter test
```

- `test/unit/send_message_test.dart` — the use case returns the assistant
  reply and passes history through to the repository.
- `test/widget/chat_page_test.dart` — the chat page renders, accepts input,
  and shows a reply in mock mode.

## Screenshots

_No screenshots yet — run the app in mock mode and take one if you need it._

## Author

Hamdi Ben Haj Rhouma — Flutter Developer | Mobile Development | AI Integration
- Sousse, Tunisia
- hamdibenhajrhouma@gmail.com
- https://www.linkedin.com/in/hamdi-ben-haj-rhouma
- https://github.com/HamdBenHajRhouma
