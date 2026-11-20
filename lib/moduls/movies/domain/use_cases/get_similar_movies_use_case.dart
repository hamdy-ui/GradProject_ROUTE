import '../entities/movie_entity.dart';
import '../repo/movies_repo.dart';

class GetSimilarMoviesUseCase {
  final MoviesRepo _repository;

  const GetSimilarMoviesUseCase(this._repository);

  Future<List<MovieEntity>> call({required int movieId}) {
    return _repository.getSimilarMovies(movieId: movieId);
  }
}
