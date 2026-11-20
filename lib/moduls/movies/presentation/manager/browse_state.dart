import '../../domain/entities/movie_entity.dart';

sealed class BrowseState {
  const BrowseState();
}

class BrowseInitialState extends BrowseState {
  const BrowseInitialState();
}

class BrowseLoadingState extends BrowseState {
  final String selectedGenre;
  const BrowseLoadingState({required this.selectedGenre});
}

class BrowseLoadedState extends BrowseState {
  final String selectedGenre;
  final List<MovieEntity> movies;

  const BrowseLoadedState({
    required this.selectedGenre,
    required this.movies,
  });
}

class BrowseErrorState extends BrowseState {
  final String message;
  const BrowseErrorState(this.message);
}
