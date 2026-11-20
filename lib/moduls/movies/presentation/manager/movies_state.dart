import '../../domain/entities/movie_entity.dart';

sealed class MoviesState {
  const MoviesState();
}

class MoviesInitialState extends MoviesState {
  const MoviesInitialState();
}

class MoviesLoadingState extends MoviesState {
  const MoviesLoadingState();
}

class MoviesLoadedState extends MoviesState {
  final List<MovieEntity> featuredMovies;
  final List<MovieEntity> actionMovies;
  final int selectedFeaturedIndex;

  const MoviesLoadedState({
    required this.featuredMovies,
    required this.actionMovies,
    this.selectedFeaturedIndex = 0,
  });

  MoviesLoadedState copyWith({
    List<MovieEntity>? featuredMovies,
    List<MovieEntity>? actionMovies,
    int? selectedFeaturedIndex,
  }) {
    return MoviesLoadedState(
      featuredMovies: featuredMovies ?? this.featuredMovies,
      actionMovies: actionMovies ?? this.actionMovies,
      selectedFeaturedIndex:
          selectedFeaturedIndex ?? this.selectedFeaturedIndex,
    );
  }
}

class MoviesErrorState extends MoviesState {
  final String message;
  const MoviesErrorState(this.message);
}
