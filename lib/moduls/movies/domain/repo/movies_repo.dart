import '../entities/movie_details_entity.dart';
import '../entities/movie_entity.dart';

abstract class MoviesRepo {
  Future<List<MovieEntity>> getMovies({
    int? limit,
    int? page,
    String? quality,
    double? minimumRating,
    String? queryTerm,
    String? genre,
    String? sortBy,
    String? orderBy,
  });

  Future<MovieDetailsEntity> getMovieDetails({
    required int movieId,
  });

  Future<List<MovieEntity>> getSimilarMovies({
    required int movieId,
  });
}
