import '../../domain/entities/movie_entity.dart';

sealed class SearchState {
  const SearchState();
}

class SearchInitialState extends SearchState {
  const SearchInitialState();
}

class SearchLoadingState extends SearchState {
  const SearchLoadingState();
}

class SearchLoadedState extends SearchState {
  final String query;
  final List<MovieEntity> movies;

  const SearchLoadedState({
    required this.query,
    required this.movies,
  });
}

class SearchErrorState extends SearchState {
  final String message;
  const SearchErrorState(this.message);
}
