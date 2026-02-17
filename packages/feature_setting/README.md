# feature_setting

`feature_setting` is the settings feature package for Emobin.
It owns setting-related state management and local preference persistence behind feature-level APIs.

## Responsibility Scope
- Provide theme mode state (`AppThemeModeCubit`) and persistence.
- Provide feed emotion preset state (`FeedEmotionPresetCubit`) and persistence.
- Register setting dependencies via `injectable` micro package DI.

`feature_setting` is the only package that directly accesses `SharedPreferences` for these settings.
The `app` package should consume Cubits exported by this feature package instead of reading preferences directly.

## Clean Architecture Mapping
This package currently focuses on presentation + local setting infrastructure.

- `presentation`
  - `AppThemeModeCubit`: handles light/dark mode toggle and initialization.
  - `FeedEmotionPresetCubit`: handles emotion preset initialize/update/validation.
- `data/infrastructure`
  - `SettingModule`: provides `SharedPreferences` instance for DI.
- `domain`
  - Not separated yet because setting logic is currently simple and Cubit-centric.

## Directory Layout
- `lib/feature_setting.dart`
  - Public exports for DI and Cubits.
- `lib/src/core/constants/defaults.dart`
  - Default values for settings (`feedEmotionPresets`).
- `lib/src/core/constants/keys.dart`
  - Shared preference keys.
- `lib/src/core/di/di.dart`
  - `@InjectableInit.microPackage()` entrypoint.
- `lib/src/core/di/setting_module.dart`
  - `SharedPreferences` provider module.
- `lib/src/core/di/di.module.dart`
  - Generated DI registrations.
- `lib/src/presentation/cubit/app_theme/app_theme_mode_cubit.dart`
  - Theme mode state management.
- `lib/src/presentation/cubit/feed_emotion_preset/feed_emotion_preset_cubit.dart`
  - Emotion preset state management.

## Cubits and Features
- `AppThemeModeCubit`
  - `initialize()`: loads saved theme mode.
  - `toggleBrightness()`: toggles light/dark and persists the new mode.
- `FeedEmotionPresetCubit`
  - `initialize()`: seeds defaults when missing, then emits saved presets.
  - `addEmotion(String)`: validates and appends a new emotion preset.
  - `removeEmotion(String)`: removes an existing emotion preset.

## Usage Example
```dart
BlocProvider(
  create: (_) => getIt<AppThemeModeCubit>()..initialize(),
  child: const MyScreen(),
)
```

```dart
context.read<FeedEmotionPresetCubit>().addEmotion('Calm');
```

## Testing
There is currently no dedicated `test/` directory in this package.
Recommended tests to add:
- `AppThemeModeCubit` initialization and toggle persistence behavior.
- `FeedEmotionPresetCubit` duplicate validation and save behavior.

Run analysis and tests from workspace root:
```bash
flutter analyze packages/feature_setting
flutter test packages/feature_setting
```
