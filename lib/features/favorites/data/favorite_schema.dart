// >>> FavoriteSchema =======================
// Favorites do not have a dedicated Hive schema.
//
// The favorites feature uses [HistoryEntrySchema] (typeId: 1) from the
// history feature and filters entries where [isFavorite] is true.
//
// See: package:mdm/features/history/data/datasources/history_entry_schema.dart
//
// This design avoids data duplication and ensures favorites stay in sync
// with the download history. Toggling a favorite simply flips the
// [HistoryEntrySchema.isFavorite] flag and calls [HiveObject.save()].
// <<< FavoriteSchema =======================
