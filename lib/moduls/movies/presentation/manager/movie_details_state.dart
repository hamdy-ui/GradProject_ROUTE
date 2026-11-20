import '../../domain/entities/movie_details_entity.dart';

sealed class MovieDetailsState {
  const MovieDetailsState();
}

class MovieDetailsInitialState extends MovieDetailsState {
  const MovieDetailsInitialState();
}

class MovieDetailsLoadingState extends MovieDetailsState {
  const MovieDetailsLoadingState();
}

class MovieDetailsLoadedState extends MovieDetailsState {
  final MovieDetailsEntity movie;
  final bool isInWishlist;
  final bool isWatchRecorded;

  const MovieDetailsLoadedState({
    required this.movie,
    this.isInWishlist = false,
    this.isWatchRecorded = false,
  });

  MovieDetailsLoadedState copyWith({
    MovieDetailsEntity? movie,
    bool? isInWishlist,
    bool? isWatchRecorded,
  }) {
    return MovieDetailsLoadedState(
      movie: movie ?? this.movie,
      isInWishlist: isInWishlist ?? this.isInWishlist,
      isWatchRecorded: isWatchRecorded ?? this.isWatchRecorded,
    );
  }
}

class MovieDetailsErrorState extends MovieDetailsState {
  final String message;
  const MovieDetailsErrorState(this.message);
}
