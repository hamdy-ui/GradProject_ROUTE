import '../entities/movie_details_entity.dart';
import '../repo/movies_repo.dart';

class GetMovieDetailsUseCase {
  final MoviesRepo _repository;

  const GetMovieDetailsUseCase(this._repository);

  Future<MovieDetailsEntity> call({required int movieId}) {
    return _repository.getMovieDetails(movieId: movieId);
  }
}
