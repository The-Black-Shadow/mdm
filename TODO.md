# MDM — Project TODO & Progress Tracker

> **Purpose:** Agent updates this file after every feature completion.  
> **Statuses:** ⬜ Not Started | 🟡 In Progress | ✅ Done | ❌ Blocked  
> **Last Updated:** 2026-06-25T16:19:00+06:00

---

## Phase 1 — Foundation

- [x] ✅ **1.1 Project Setup & pubspec.yaml**
  - Add all dependencies from spec §2.2
  - Run `flutter pub get`
  - _Completed:_ 2026-06-25T10:07:00Z

- [x] ✅ **1.2 Folder Structure**
  - Create full folder structure from spec §4
  - Add `.gitkeep` to empty folders
  - _Completed:_ 2026-06-25T10:08:00Z

- [x] ✅ **1.3 Core Utils**
  - `Result<T>` sealed class (`core/utils/result.dart`)
  - `AppException` sealed class (`core/utils/app_exception.dart`)
  - `AppLogger` singleton (`core/utils/app_logger.dart`)
  - Validators (`core/utils/validators.dart`)
  - _Completed:_ 2026-06-25T10:08:00Z

- [x] ✅ **1.4 Extensions**
  - `string_extensions.dart` — `isValidYouTubeUrl`, `truncate`
  - `duration_extensions.dart` — `formatDuration`
  - `int_extensions.dart` — `formatBytes`, `formatSpeed`
  - `context_extensions.dart` — theme/mediaQuery shortcuts
  - _Completed:_ 2026-06-25T10:08:00Z

- [x] ✅ **1.5 Constants**
  - `app_constants.dart`
  - `asset_constants.dart`
  - `route_constants.dart`
  - _Completed:_ 2026-06-25T10:08:00Z

- [x] ✅ **1.6 Theme System**
  - `AppColors` tokens (§7.1)
  - `AppTypography` — Google Fonts (Inter/Nunito)
  - `AppSpacing` constants (§7.3)
  - `AppTheme` — light, dark, AMOLED (§7.2)
  - _Completed:_ 2026-06-25T10:09:48Z

- [x] ✅ **1.7 DI Setup (get_it + injectable)**
  - `core/di/injection.dart`
  - Run `build_runner` for generated config
  - _Completed:_ 2026-06-25T10:09:00Z

- [x] ✅ **1.8 Router (go_router)**
  - `core/router/app_router.dart` — all routes stubbed
  - `RouteConstants` class
  - _Completed:_ 2026-06-25T10:10:01Z

- [x] ✅ **1.9 Core Services**
  - `NotificationService` wrapper
  - `ClipboardService` with polling
  - `ConnectivityService` wrapper
  - _Completed:_ 2026-06-25T16:18:47Z

- [x] ✅ **1.10 Core Helpers**
  - `FileHelper` — safe filenames, path utils
  - `PermissionHelper` — permission_handler wrapper
  - _Completed:_ 2026-06-25T10:08:00Z

- [x] ✅ **1.11 Core Widgets**
  - `AppErrorWidget`
  - `AppLoadingWidget` (shimmer)
  - `AppEmptyWidget` (lottie)
  - _Completed:_ 2026-06-25T10:08:00Z

- [x] ✅ **1.12 Shared Components**
  - `ThumbnailWidget`
  - `QualityBadge`
  - `ProgressBarWidget`
  - `BottomSheetHandle`
  - _Completed:_ 2026-06-25T16:18:51Z

- [x] ✅ **1.13 Shared Enums & Models**
  - `DownloadStatus` enum
  - `VideoQuality` enum
  - `AudioQuality` enum
  - `MediaType` enum
  - `VideoInfo` model
  - _Completed:_ 2026-06-25T10:08:00Z

- [x] ✅ **1.14 Network Layer**
  - `DioClient` factory + interceptors
  - `LoggingInterceptor`
  - `ErrorInterceptor`
  - _Completed:_ 2026-06-25T10:09:48Z

- [x] ✅ **1.15 main.dart Wiring**
  - Call `configureDependencies()` before `runApp()`
  - Wire `AppTheme`, `GoRouter`
  - _Completed:_ 2026-06-25T10:10:01Z

---

## Phase 2 — Core Loop (Metadata + Quality Selection)

- [ ] ⬜ **2.1 YouTube Remote Source**
  - `youtube_explode_dart` adapter in data layer
  - Wrap all calls, return `Result<T>`
  - _Completed:_ —

- [ ] ⬜ **2.2 Domain Entities**
  - `VideoMetadata` entity
  - `StreamInfo` entity
  - `DownloadTask` entity
  - _Completed:_ —

- [ ] ⬜ **2.3 Data Models (freezed)**
  - `VideoMetadataModel` with `toDomain()`
  - `StreamInfoModel` with `toDomain()`
  - Run `build_runner`
  - _Completed:_ —

- [ ] ⬜ **2.4 Metadata Repository**
  - Abstract `MetadataRepository` (domain)
  - `MetadataRepositoryImpl` (data)
  - _Completed:_ —

- [ ] ⬜ **2.5 FetchMetadataUseCase**
  - Calls repository, returns `Result<VideoMetadata>`
  - _Completed:_ —

- [ ] ⬜ **2.6 MetadataBLoC**
  - Events: `FetchMetadataEvent`, `RetryMetadataEvent`
  - States: `Initial`, `Loading`, `Loaded`, `Error`
  - _Completed:_ —

- [ ] ⬜ **2.7 MetadataPage UI**
  - Full-width thumbnail + gradient overlay
  - Title, channel, duration, views, date
  - Expandable description
  - Shimmer loading state
  - Lottie error state + retry
  - Sticky bottom bar (Audio Only + Select Quality)
  - _Completed:_ —

- [ ] ⬜ **2.8 QualitySelectionPage UI**
  - Compact header (thumb + title + duration)
  - Tab bar: Video | Audio Only
  - Video tab: streams grouped by resolution
  - Audio tab: streams sorted by bitrate
  - `requiresMerge` info tooltip
  - _Completed:_ —

- [ ] ⬜ **2.9 DownloadOptionsSheet**
  - Editable filename
  - Download folder selector
  - Extract audio toggle (for video)
  - Start Download button
  - _Completed:_ —

- [ ] ⬜ **2.10 Hive Adapter Setup**
  - `DownloadTaskAdapter`
  - `HistoryEntryAdapter`
  - `AppSettingsAdapter`
  - `FavoriteAdapter`
  - Register all in `Hive.registerAdapter()`
  - _Completed:_ —

---

## Phase 3 — Download Engine

- [ ] ⬜ **3.1 DownloadTask Hive Persistence**
  - CRUD operations in `DownloadLocalSource`
  - _Completed:_ —

- [ ] ⬜ **3.2 Download Repository**
  - Abstract `DownloadRepository` (domain)
  - `DownloadRepositoryImpl` (data)
  - _Completed:_ —

- [ ] ⬜ **3.3 Download Use Cases**
  - `StartDownloadUseCase`
  - `PauseDownloadUseCase`
  - `CancelDownloadUseCase`
  - _Completed:_ —

- [ ] ⬜ **3.4 DownloadEngine (muxed only)**
  - Dio byte streaming to file
  - Progress stream (throttled 4Hz via rxdart)
  - Pause/Resume with `CancelToken` + Range header
  - Temp file cleanup
  - Update Hive on state changes
  - _Completed:_ —

- [ ] ⬜ **3.5 DownloadQueueManager**
  - Ordered pending task list
  - Max concurrent from settings
  - Auto-start next on slot free
  - Persist queue to Hive
  - _Completed:_ —

- [ ] ⬜ **3.6 DownloadBLoC**
  - Real-time progress from engine stream
  - Throttled state emissions
  - Events: Start, Pause, Resume, Cancel, Retry
  - _Completed:_ —

- [ ] ⬜ **3.7 DownloadsPage UI**
  - Tabs: Active | Queue | Completed
  - `ActiveDownloadTile` with progress bar, speed, ETA
  - Queue tab with drag-to-reorder
  - Action buttons per state (Pause/Resume/Cancel/Delete/Open/Share)
  - _Completed:_ —

- [ ] ⬜ **3.8 Download Notifications**
  - Progress notification (low importance, ongoing)
  - Complete notification
  - Failed notification (high importance)
  - Notification channels setup
  - _Completed:_ —

- [ ] ⬜ **3.9 Wi-Fi Only Enforcement**
  - Check before download start
  - Listen connectivity changes, auto-pause
  - Warning notification
  - _Completed:_ —

---

## Phase 4 — Media Processing (FFmpeg)

- [ ] ⬜ **4.1 MediaProcessor Interface**
  - `mergeVideoAndAudio()`
  - `convertToMp4()`
  - `extractAudio()`
  - `embedMetadata()`
  - _Completed:_ —

- [ ] ⬜ **4.2 FfmpegService Implementation**
  - Implement all MediaProcessor methods
  - Log all FFmpeg commands + return codes
  - Clean temp files on success/failure
  - Register as `@LazySingleton(as: MediaProcessor)`
  - _Completed:_ —

- [ ] ⬜ **4.3 Wire Merge into DownloadEngine**
  - High-quality flow: video.tmp → audio.tmp → merge → output.mp4
  - Progress phases: video(0-50%), audio(50-75%), merge(75-100%)
  - _Completed:_ —

- [ ] ⬜ **4.4 WebM → MP4 Conversion**
  - Trigger when container is webm
  - _Completed:_ —

- [ ] ⬜ **4.5 Audio Extraction (MP3)**
  - "Extract audio only" option from download sheet
  - _Completed:_ —

---

## Phase 5 — Persistence & History

- [ ] ⬜ **5.1 History Repository**
  - Abstract `HistoryRepository` (domain)
  - `HistoryRepositoryImpl` (data)
  - `HistoryLocalSource` — Hive CRUD
  - _Completed:_ —

- [ ] ⬜ **5.2 HistoryPage UI**
  - Search bar (local filter, debounce 300ms)
  - Date-grouped list (Today, Yesterday, This Week, Earlier)
  - Tiles: thumbnail, title, channel, size, date, badge
  - Long-press context menu
  - Swipe right → player, swipe left → delete (undo snackbar)
  - Lottie empty state
  - Pagination (page size 20)
  - _Completed:_ —

- [ ] ⬜ **5.3 FavoritesPage UI**
  - Same tile design as History
  - Filter `isFavorite == true`
  - Lottie empty state
  - _Completed:_ —

- [ ] ⬜ **5.4 SearchPage UI**
  - Real-time filter by title + channel
  - Debounce 300ms
  - Grouped results: Videos | Audio
  - _Completed:_ —

---

## Phase 6 — Android Integration

- [ ] ⬜ **6.1 Share Intent**
  - `receive_sharing_intent` setup
  - Listen in `main()` + on resume
  - Extract URL → validate → navigate to MetadataPage
  - AndroidManifest intent-filter
  - _Completed:_ —

- [ ] ⬜ **6.2 Clipboard Detection**
  - Poll every 2s in foreground
  - Debounce + deduplicate
  - Only show for valid YouTube URLs not already downloaded
  - Store last shown URL
  - _Completed:_ —

- [ ] ⬜ **6.3 Storage Permissions**
  - Android 13+ (API 33+): `READ_MEDIA_VIDEO`, `READ_MEDIA_AUDIO`
  - Android 10-12: `READ_EXTERNAL_STORAGE`
  - Android 9-: `READ_EXTERNAL_STORAGE` + `WRITE_EXTERNAL_STORAGE`
  - Use `device_info_plus` for version detection
  - _Completed:_ —

- [ ] ⬜ **6.4 AndroidManifest.xml Permissions**
  - INTERNET, storage, FOREGROUND_SERVICE, POST_NOTIFICATIONS, PIP
  - _Completed:_ —

- [ ] ⬜ **6.5 Foreground Service**
  - Downloads continue when backgrounded
  - Ongoing notification with progress
  - _Completed:_ —

---

## Phase 7 — Player & Polish

- [ ] ⬜ **7.1 PlayerPage — BetterPlayer**
  - Local file playback
  - Custom controls overlay (hide default)
  - Auto-hide controls after 3s
  - _Completed:_ —

- [ ] ⬜ **7.2 Player Gestures**
  - Tap to show/hide controls
  - Swipe left/right to seek
  - Swipe up/down right half → volume
  - Swipe up/down left half → brightness
  - _Completed:_ —

- [ ] ⬜ **7.3 Player Features**
  - Playback speed (0.25x — 2.0x)
  - PiP (Android 8+, check `device_info_plus`)
  - Remember playback position (Hive)
  - Fullscreen → landscape lock
  - _Completed:_ —

- [ ] ⬜ **7.4 HomePage — Full Implementation**
  - App bar with settings/downloads icons + badge
  - Clipboard banner (slide-in animation)
  - URL input card with validation
  - Quick stats row (total downloads, size, active)
  - Recent downloads (horizontal scroll, last 10)
  - Active downloads section (compact list)
  - _Completed:_ —

- [ ] ⬜ **7.5 HomeCubit**
  - States: `HomeInitial`, `HomeLoaded`, `HomeError`
  - Load recent downloads, active downloads, stats, clipboard URL
  - _Completed:_ —

- [ ] ⬜ **7.6 SettingsPage UI**
  - Downloads section (quality defaults, folder, concurrent, wifi-only, auto-merge)
  - Notifications section (progress, complete, failure toggles)
  - Appearance section (theme selector)
  - Storage section (stats, clear history, clear cache)
  - About section (version, licenses)
  - _Completed:_ —

- [ ] ⬜ **7.7 SettingsCubit**
  - Load settings from Hive on startup
  - Persist changes
  - `ThemeCubit` for theme mode
  - _Completed:_ —

---

## Phase 8 — Quality & Testing

- [ ] ⬜ **8.1 Unit Tests — Use Cases**
  - All use cases with mocked repositories
  - _Completed:_ —

- [ ] ⬜ **8.2 Unit Tests — Repositories**
  - All repository implementations with mocked data sources
  - _Completed:_ —

- [ ] ⬜ **8.3 BLoC Tests**
  - MetadataBLoC
  - DownloadBLoC
  - HomeCubit
  - SettingsCubit
  - _Completed:_ —

- [ ] ⬜ **8.4 Unit Tests — Engine & Queue**
  - DownloadQueueManager logic
  - MediaProcessor (mock FFmpeg)
  - _Completed:_ —

- [ ] ⬜ **8.5 Unit Tests — Extensions & Utils**
  - All extension methods
  - AppLogger smoke test
  - _Completed:_ —

- [ ] ⬜ **8.6 Performance Audit**
  - Check rebuild counts
  - Check frame drops
  - Verify throttled streams
  - _Completed:_ —

- [ ] ⬜ **8.7 Accessibility Audit**
  - Respect `disableAnimations`
  - Semantic labels on interactive elements
  - _Completed:_ —

---

## Feature Completion Checklist (per feature)

> Agent must verify before marking any task ✅:

- [ ] All async calls have try-catch and return `Result<T>`
- [ ] All Hive operations handled safely
- [ ] All file ops check permissions first
- [ ] New Hive adapters registered
- [ ] New services annotated + registered via injectable
- [ ] New routes added to `AppRouter`
- [ ] Feature section comments present (`// >>> ... // <<<`)
- [ ] No `print()` — use `AppLogger`
- [ ] No magic numbers or hardcoded colors
- [ ] No widget > 150 lines, no function > 30 lines

---

## Progress Summary

| Phase | Total Tasks | Done | Status |
|-------|------------|------|--------|
| 1 — Foundation | 15 | 15 | ✅ Done |
| 2 — Core Loop | 10 | 0 | ⬜ Not Started |
| 3 — Download Engine | 9 | 0 | ⬜ Not Started |
| 4 — Media Processing | 5 | 0 | ⬜ Not Started |
| 5 — Persistence & History | 4 | 0 | ⬜ Not Started |
| 6 — Android Integration | 5 | 0 | ⬜ Not Started |
| 7 — Player & Polish | 7 | 0 | ⬜ Not Started |
| 8 — Quality & Testing | 7 | 0 | ⬜ Not Started |
| **Total** | **62** | **15** | 🟡 **In Progress** |
