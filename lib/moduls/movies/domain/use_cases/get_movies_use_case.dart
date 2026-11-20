import '../entities/movie_entity.dart';
import '../repo/movies_repo.dart';

class GetMoviesUseCase {
  final MoviesRepo _repository;

  const GetMoviesUseCase(this._repository);

  Future<List<MovieEntity>> call({
    int? limit,
    int? page,
    String? quality,
    double? minimumRating,
    String? queryTerm,
    String? genre,
    String? sortBy,
    String? orderBy,
  }) {
    return _repository.getMovies(
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
}
