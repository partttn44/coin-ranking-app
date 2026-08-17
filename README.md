# Coin Ranking App

A Flutter application for browsing cryptocurrency rankings using the Coinranking API.

The application uses MVVM with Bloc for the Presentation layer and connects to a separate Domain/Data package designed with Clean Architecture.

## Features

- Fetch 10 coins per request
- Infinite scrolling
- Search by coin name or symbol
- One-second search debounce
- Pull to refresh
- Top 3 Coins section
- Coin detail bottom sheet
- Loading, empty, and error states
- Retry failed requests
- Invite Friends items
- Native share sheet
- English localization
- Responsive user interface

## Related Repository

The Domain and Data layers are maintained in a separate repository:

[coin-ranking-data](https://github.com/partttn44/coin-ranking-data)

## Architecture

```text
View
  ↓
Bloc / Cubit
  ↓
Repository Interface
  ↓
Repository Implementation
  ↓
Remote Data Source
  ↓
Coinranking API
```

The application repository contains the Presentation layer. It communicates only with the Domain repository interface provided by `coin_ranking_data`.

## Project Structure

```text
lib/
├── core/
│   └── utils/
│       └── number_formatter.dart
│
├── injection/
│   └── injection.dart
│
├── l10n/
│   ├── app_en.arb
│   ├── generated/
│   └── l10n.dart
│
├── viewmodels/
│   ├── coin_list/
│   │   ├── coin_list_bloc.dart
│   │   ├── coin_list_event.dart
│   │   ├── coin_list_state.dart
│   │   └── coin_model.dart
│   │
│   └── coin_detail/
│       ├── coin_detail_cubit.dart
│       └── coin_detail_state.dart
│
├── views/
│   ├── pages/
│   │   └── coin_list_page.dart
│   │
│   └── widgets/
│       ├── coin_change_badge.dart
│       ├── coin_detail_bottom_sheet.dart
│       ├── coin_error_view.dart
│       ├── coin_icon.dart
│       ├── coin_item.dart
│       ├── coin_list_body.dart
│       ├── coin_list_bottom_status.dart
│       ├── coin_list_content.dart
│       ├── coin_refresh_indicator.dart
│       ├── coin_search_bar.dart
│       ├── invite_friends_item.dart
│       └── top_coin_card.dart
│
├── app.dart
└── main.dart
```

## Requirements

- Flutter latest stable version
- Dart SDK compatible with Flutter
- Coinranking API key

## Installation

Clone the repository:

```bash
git clone https://github.com/partttn44/coin-ranking-app.git
cd coin-ranking-app
```

Install dependencies:

```bash
flutter pub get
```

Generate localization files:

```bash
flutter gen-l10n
```

## Running the Application

Pass the Coinranking API key using `--dart-define`:

```bash
flutter run --dart-define=COINRANKING_API_KEY=YOUR_API_KEY
```

The real API key is not stored in the source code.

## Data Package Dependency

The application uses `coin_ranking_data` through a Git dependency:

```yaml
dependencies:
  coin_ranking_data:
    git:
      url: https://github.com/partttn44/coin-ranking-data.git
      ref: v1.0.0
```

## API Endpoints

```text
GET /v2/coins
GET /v2/coins?search={keyword}
GET /v2/coin/{uuid}
```

API documentation:

[Coinranking API Documentation](https://developers.coinranking.com/api/documentation)

## Pagination

The application requests 10 coins at a time:

```text
offset=0&limit=10
offset=10&limit=10
offset=20&limit=10
```

The first three coins from the initial request are displayed separately and excluded from the main list.

## Search

Search supports coin names and symbols.

Examples:

```text
Bitcoin
BTC
Ethereum
ETH
```

Search requests are triggered after a one-second debounce. Pagination remains available for search results, while pull-to-refresh is disabled during a search.

## Coin Details

Tapping a coin opens a bottom sheet displaying:

- Icon
- Name and symbol
- Coin color
- Price
- Market cap
- Price change
- Description
- Website link

`No description` is displayed if the description is missing. The `Read more` link is displayed only when a website URL exists.

## Invite Friends

Invite Friends items are inserted at display positions:

```text
5, 10, 20, 40, 80, 160, ...
```

Tapping an item opens the native share sheet with:

```text
https://www.7solutions.co.th/jobs
```

## Localization

English localization is provided using Flutter `gen-l10n`.

Localization source:

```text
lib/l10n/app_en.arb
```

After changing an ARB file, run:

```bash
flutter gen-l10n
```

## Error Handling

The application handles:

- Network connection errors
- Request timeouts
- Missing or invalid API keys
- API rate limits
- Invalid server responses
- Initial loading failures
- Pagination failures
- Coin detail failures

Failed requests can be retried from the user interface.

## Main Dependencies

- `flutter_bloc`
- `bloc_concurrency`
- `stream_transform`
- `equatable`
- `get_it`
- `flutter_screenutil`
- `flutter_svg`
- `custom_refresh_indicator`
- `url_launcher`
- `share_plus`
- `flutter_localizations`

## Code Quality

Run formatting and static analysis before submitting:

```bash
dart format .
flutter analyze
```

Run tests:

```bash
flutter test
```

## Build

Build a release APK:

```bash
flutter build apk --release --dart-define=COINRANKING_API_KEY=YOUR_API_KEY
```

## Notes

- API quotas depend on the Coinranking account plan.
- HTTP status `429` is handled as an error state.
- The API key must not be committed to Git.
- Coin details are loaded when a coin is selected.

## License

This application was created for a mobile developer assignment.
