import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/data_source/movies_remote_data_source.dart';
import '../../data/repo/movies_repo_impl.dart';
import '../../domain/use_cases/get_movies_use_case.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final GetMoviesUseCase getMoviesUseCase;

  SearchCubit({required this.getMoviesUseCase})
      : super(const SearchInitialState());

  factory SearchCubit.create() {
    final remoteDataSource = MoviesRemoteDataSourceImpl();
    final repo = MoviesRepoImpl(remoteDataSource);
    return SearchCubit(getMoviesUseCase: GetMoviesUseCase(repo));
  }

  Future<void> search(String query) async {
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) {
      emit(const SearchInitialState());
      return;
    }

    emit(const SearchLoadingState());
    try {
      final results = await getMoviesUseCase(
        queryTerm: trimmedQuery,
        limit: 20,
      );
      emit(SearchLoadedState(
        query: trimmedQuery,
        movies: results,
      ));
    } catch (e) {
      emit(SearchErrorState(e.toString().replaceAll('Exception: ', '')));
    }
  }

  void clearSearch() {
    emit(const SearchInitialState());
  }
}
