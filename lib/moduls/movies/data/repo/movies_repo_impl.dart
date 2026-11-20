import '../../domain/entities/movie_details_entity.dart';
import '../../domain/entities/movie_entity.dart';
import '../../domain/repo/movies_repo.dart';
import '../data_source/movies_remote_data_source.dart';

class MoviesRepoImpl implements MoviesRepo {
  final MoviesRemoteDataSource remoteDataSource;

  const MoviesRepoImpl(this.remoteDataSource);

  @override
  Future<List<MovieEntity>> getMovies({
    int? limit,
    int? page,
    String? quality,
    double? minimumRating,
    String? queryTerm,
    String? genre,
    String? sortBy,
    String? orderBy,
  }) {
    return remoteDataSource.getMovies(
      limit: limit,
      page: page,
      quality: quality,
      minimumRating: minimumRating,
      queryTerm: queryTerm,
      genre: genre,
      sortBy: sortBy,
      orderBy: orderBy,
    );
  }

  @override
  Future<MovieDetailsEntity> getMovieDetails({required int movieId}) {
    return remoteDataSource.getMovieDetails(movieId: movieId);
  }

  @override
  Future<List<MovieEntity>> getSimilarMovies({required int movieId}) {
    return remoteDataSource.getSimilarMovies(movieId: movieId);
  }
}
