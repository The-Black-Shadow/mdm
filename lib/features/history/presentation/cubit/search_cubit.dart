// >>> SearchCubit =======================
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mdm/core/utils/app_logger.dart';
import 'package:mdm/features/history/domain/repositories/history_repository.dart';
import 'package:mdm/features/history/presentation/cubit/search_state.dart';

@injectable
class SearchCubit extends Cubit<SearchState> {
  final HistoryRepository _repository;

  SearchCubit(this._repository) : super(const SearchState.initial());

  Future<void> performSearch(String query) async {
    if (query.trim().isEmpty) {
      emit(const SearchState.initial());
      return;
    }

    emit(const SearchState.loading());
    final result = await _repository.searchHistory(query);
    
    result.when(
      success: (entries) {
        emit(SearchState.loaded(entries));
      },
      failure: (e) {
        emit(SearchState.error(e.message));
      },
    );
  }
}
// <<< SearchCubit =======================
