// >>> FavoritesCubit =======================
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mdm/features/history/domain/repositories/history_repository.dart';
import 'package:mdm/features/history/presentation/cubit/favorites_state.dart';

@injectable
class FavoritesCubit extends Cubit<FavoritesState> {
  final HistoryRepository _repository;

  FavoritesCubit(this._repository) : super(const FavoritesState.initial());

  Future<void> loadFavorites() async {
    emit(const FavoritesState.loading());
    final result = await _repository.getFavorites();
    
    result.when(
      success: (entries) {
        emit(FavoritesState.loaded(entries));
      },
      failure: (e) {
        emit(FavoritesState.error(e.message));
      },
    );
  }

  Future<void> removeFavorite(String videoId) async {
    // Just toggle it back to false
    final result = await _repository.toggleFavorite(videoId, false);
    if (result.isSuccess) {
      loadFavorites(); // Reload to get updated list
    }
  }
}
// <<< FavoritesCubit =======================
