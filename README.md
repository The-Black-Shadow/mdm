# MDM — Premium Multi-Platform Media Downloader

MDM (Media Downloader Manager) is a high-performance, premium multi-platform downloader designed for Android. Built using Flutter, this project is architected with a focus on rich aesthetics, smooth animations, and solid architectural principles. 

While the app is structured to easily integrate additional platforms (such as Facebook, Instagram, TikTok, and SoundCloud) in future milestones, **YouTube** is currently the first fully supported platform.

---

## 🌟 Key Features

- **Premium Material 3 UI:** Fluid animations, curated AMOLED/dark/light themes, and custom widgets designed to feel premium (inspired by Spotify and YouTube Music).
- **Decoupled Architecture:** Built using **Feature-First Clean Architecture** with strict layer separation.
- **Advanced Download Engine:** High-performance, multi-threaded download engine supporting pause, resume, and concurrency limit configurations.
- **Smart Foreground Clipboard Scanning:** Auto-scanning of URLs with intelligent deduplication and a slide-in banner for quick actions.
- **Deep Android Integration:** Integration with Android Share Intents to parse shared media links, foreground services for background download persistence, and version-aware storage permission handler.
- **FFmpeg Integration:** Automated merging of high-quality separate video & audio streams, MP3 audio conversion, WebM to MP4 conversion, and audio ID3 metadata tags embedding.
- **Custom Gesture Media Player:** Gestures for seeking, brightness, and volume adjustments, Picture-in-Picture (PiP) support, and playback position persistence.
- **Indexed Local Database:** Search, favorites, date-grouped download history, and app settings managed via Hive database.

---

## 📐 Current Project Directory Structure (Phase 1 Baseline)

Below is the actual file structure generated for the Phase 1 Foundation baseline:

```
lib/
├── main.dart
├── core/
│   ├── constants/
│   │   ├── app_constants.dart           # Global string keys, limits, and numeric constants
│   │   ├── asset_constants.dart         # Relative paths for Lottie and image assets
│   │   └── route_constants.dart         # Route path names for navigation
│   ├── di/
│   │   └── injection.dart               # Dependency injection baseline using GetIt
│   ├── extensions/
│   │   ├── context_extensions.dart      # BuildContext helpers for theme and media query
│   │   ├── duration_extensions.dart     # Duration to human-readable format mapping
│   │   ├── int_extensions.dart          # Byte size and bandwidth speed formatters
│   │   └── string_extensions.dart       # Sanitizers, validation checks, and truncators
│   ├── helpers/
│   │   ├── file_helper.dart             # Storage folder path providers (temp, cache, download)
│   │   └── permission_helper.dart       # Version-aware storage & notification permission handler
│   ├── network/
│   │   ├── dio_client.dart              # Dio HTTP client initialization with logging & error mappings
│   │   └── interceptors/
│   │       ├── error_interceptor.dart   # DioException to AppException mapping layer
│   │       └── logging_interceptor.dart # Logging outgoing requests, response statuses, and latency
│   ├── router/
│   │   └── app_router.dart              # GoRouter config mapping page stubs to RouteConstants
│   ├── services/
│   │   ├── clipboard_service.dart       # Foreground clipboard scanner with URL validation
│   │   ├── connectivity_service.dart    # Mobile data/Wi-Fi active connection state monitor
│   │   └── notification_service.dart    # FlutterLocalNotificationsPlugin wrapper (progress/warning notifications)
│   ├── theme/
│   │   ├── app_colors.dart              # Light/Dark/AMOLED brand color hex values
│   │   ├── app_spacing.dart             # Unified grid margin values (xs, sm, md, base, lg, etc.)
│   │   ├── app_theme.dart               # Theme builders loading colors, spacing, and typography
│   │   └── app_typography.dart          # TextTheme configurations utilizing Google Fonts Inter
│   ├── utils/
│   │   ├── app_exception.dart           # Sealed class representation of typed errors
│   │   ├── app_logger.dart              # Custom console logger wrapping the logger package
│   │   ├── result.dart                  # Result<T> sealed success/failure wrapper
│   │   └── validators.dart              # Custom validators for YouTube links and filenames
│   └── widgets/
│       ├── app_empty_widget.dart        # Vector illustration state handler
│       ├── app_error_widget.dart        # Unified crash/error fallback display
│       └── app_loading_widget.dart      # Skeleton shimmer loader widget
│
├── shared/
│   ├── components/
│   │   ├── bottom_sheet_handle.dart     # Modal sheets drag gesture indicator bar
│   │   ├── progress_bar_widget.dart     # Custom stacked animated progress indicator
│   │   ├── quality_badge.dart           # Render tags (e.g. 1080p, MP3) in standard cards
│   │   └── thumbnail_widget.dart        # Image handler loading images asynchronously with shimmers
│   ├── enums/
│   │   ├── audio_quality.dart           # Bitrates configuration mapper
│   │   ├── download_status.dart         # Waiting, downloading, paused, completed, or failed state
│   │   ├── media_type.dart              # Video, audio, or muxed type representation
│   │   └── video_quality.dart           # Standard resolutions mapper
│   └── models/
│       └── video_info.dart              # Basic immutable representation of a parsed media metadata
│
└── features/                            # Decoupled packages (directories generated, files to be added)
    ├── downloader/                      # Parser repositories, download sheet dialogs, and download cubits
    ├── downloads/                       # Live progress tracker view components
    ├── favorites/                       # Locally flagged items index view
    ├── history/                         # Date-sorted lists of finished items
    ├── home/                            # Sanity check text fields, banners, and analytics widgets
    ├── player/                          # Custom media player layouts
    ├── search/                          # Local metadata filter pages
    └── settings/                        # System configurations page
```

---

## 🏗️ Technical Stack & Dependencies

### Core Stack
- **Framework:** Flutter (latest stable) & Dart
- **State Management:** `flutter_bloc` & `bloc`
- **Routing:** `go_router`
- **Dependency Injection:** `get_it` & `injectable`
- **Networking:** `dio` with custom interceptors
- **Local Database:** `hive_ce` & `hive_ce_flutter`
- **Media Processing:** `ffmpeg_kit_flutter_new`
- **Video Player:** `better_player_plus`

### Utilities & UI Packages
- `receive_sharing_intent` — Deep links & Android Share intents.
- `cached_network_image` — Caching remote images.
- `shimmer` — Skeleton loaders for content.
- `lottie` — Smooth vector animations for empty/error states.
- `flutter_animate` — Declarative chained animations.
- `device_info_plus` — SDK version detection.
- `connectivity_plus` — Dynamic Wi-Fi checks.
- `rxdart` — Stream utilities (specifically for progress throttling).
- `logger` — Organized logging format.

---

## 📐 Architecture Guidelines

MDM follows a **Feature-first Clean Architecture** pattern. Each feature is packaged separately and does not depend directly on other features. 

### Clean Architecture Layers
1. **Presentation:** Pages, widgets, and BLoC/Cubit state handlers. Depends *only* on the domain layer.
2. **Domain:** Pure Dart layer containing entities, abstract repository interfaces, and use cases. Has *no* dependencies on other layers or external packages.
3. **Data:** Network clients, local storage sources, repository implementations, and data models (using `freezed` + `json_serializable`).

### Repository Contract and Result Wrapper
Repositories do not throw raw exceptions. They wrap all API or storage outcomes in a sealed `Result` type:

```dart
sealed class Result<T> {
  const Result();
}

final class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

final class Failure<T> extends Result<T> {
  final AppException exception;
  const Failure(this.exception);
}
```

---

## ⚙️ Core Engine Pipelines (Planned)

### Download Pipeline (High Quality)
When downloading streams that require merging (e.g. 1080p, 4K video streams which are split into separate video-only and audio-only components on YouTube):

1. **Temp Dir Setup:** A temporary workspace `/cache/<taskId>/` is initialized.
2. **Video Download:** The video track is streamed via Dio to `/cache/<taskId>/video.tmp` (representing `0-50%` of overall progress).
3. **Audio Download:** The audio track is streamed via Dio to `/cache/<taskId>/audio.tmp` (representing `50-75%` of overall progress).
4. **FFmpeg Merge:** `MediaProcessor` merges both files using copy codecs:
   ```bash
   ffmpeg -i video.tmp -i audio.tmp -c:v copy -c:a aac -strict experimental output.mp4
   ```
   (Representing `75-100%` of overall progress).
5. **Final Relocation:** The compiled `output.mp4` is moved to the final designated download directory, the temporary folder is deleted, and the task is saved to history.

### Progress Throttling
To prevent UI thread congestion caused by frequent stream updates, download progress events are throttled at a maximum frequency of 4Hz (every 250ms) using RxDart:
```dart
Stream<DownloadProgress> get progressStream =>
    _progressController.stream.throttleTime(
      const Duration(milliseconds: 250),
      trailing: true,
    );
```

---

## 🔌 Android System Integrations

### Share Intent Receiver
Users can share links directly to MDM from other apps. Configured in `AndroidManifest.xml`:
```xml
<intent-filter>
  <action android:name="android.intent.action.SEND" />
  <category android:name="android.intent.category.DEFAULT" />
  <data android:mimeType="text/plain" />
</intent-filter>
```
On trigger, the deep link is intercepted, sanitized, validated, and the user is redirected straight to the metadata analysis screen.

### Foreground Service
Active downloads run within an Android Foreground Service. This keeps the download pipeline alive when the app goes into the background, updating a persistent, low-priority progress notification.

### SDK-Aware Storage Permissions
MDM dynamically adjusts storage requests depending on the Android API version:
- **Android 13+ (API 33+):** Requests `READ_MEDIA_VIDEO` and `READ_MEDIA_AUDIO`.
- **Android 10-12 (API 29-32):** Reads external storage; writes inside scoped storage app-specific directories.
- **Android 9 and below:** Requests traditional `READ_EXTERNAL_STORAGE` and `WRITE_EXTERNAL_STORAGE`.

---

## 🛠️ Setup & Running

1. **Prerequisites:** Install the [Flutter SDK](https://docs.flutter.dev/get-started/install) and Android SDK.
2. **Fetch Dependencies:**
   ```bash
   flutter pub get
   ```
3. **Generate Code Boilerplate:** Generate database schemas, injectable dependencies, and JSON models:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```
4. **Run Application:** Run on a connected Android emulator or physical device:
   ```bash
   flutter run
   ```

---

## 🧪 Testing Strategy

MDM utilizes a comprehensive unit and state-flow testing setup:
- **Use Cases:** Verified via mocked repository interfaces.
- **Repositories:** Verified via mocked local database and remote client data sources.
- **BLoCs/Cubits:** Tested using the `bloc_test` library.
- **Layout Mirroring:** Tests are structured in `test/` mirroring the directory structure of `lib/`.

Example test configuration:
```dart
blocTest<MetadataBloc, MetadataState>(
  'emits [loading, loaded] when fetch succeeds',
  build: () {
    when(() => mockFetchMetadata(any())).thenAnswer(
      (_) async => Success(fakeMetadata),
    );
    return MetadataBloc(fetchMetadataUseCase: mockFetchMetadata);
  },
  act: (bloc) => bloc.add(FetchMetadataEvent(url: 'https://youtube.com/watch?v=test')),
  expect: () => [
    isA<MetadataLoading>(),
    isA<MetadataLoaded>(),
  ],
);
```

---

## 📄 License
This project is open-source under the [MIT License](LICENSE).
