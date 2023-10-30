import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project/data/local_repository/local_history_repository.dart';
import 'package:flutter_project/data/models/repositry_model.dart';
import 'package:flutter_project/data/network_repository/network_repository.dart';
import 'package:flutter_project/search/cubit/search_cubit_state.dart';

class SearchCubit extends Cubit<SearchCubitState> {
  final NetworkRepository networkRepository;
  final LocalHistoryRepository localHistoryRepository;

  SearchCubit(this.networkRepository, this.localHistoryRepository)
      : super(SearchCubitInitial());

  Future<void> getRepositories(String nameRepository) async {
    emit(SearchCubitLoading());
    try {
      List<RepositoryModel> repositories =
          await networkRepository.search(nameRepository);
      if (repositories.isEmpty) {
        emit(SearchCubitEmpty());
      } else {
        emit(SearchCubitLoaded(repositories));
      }
    } catch (e) {
      emit(SearchCubitError(e.toString()));
    }
  }

  Future<void> loadSearchHistory() async {
    try {
      var historyData = await localHistoryRepository.getSearchHistory();
      emit(HistoryCubitLoaded(historyData));
    } catch (e) {
      emit(SearchCubitError(e.toString()));
    }
  }
}
