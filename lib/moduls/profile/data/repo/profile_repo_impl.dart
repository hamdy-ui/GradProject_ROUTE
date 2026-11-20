import '../../../auth/domain/entities/user_entity.dart';
import '../../../movies/data/models/movie_model.dart';
import '../../../movies/domain/entities/movie_entity.dart';
import '../../domain/repo/profile_repo.dart';
import '../data_source/profile_remote_data_source.dart';

class ProfileRepoImpl implements ProfileRepo {
  final ProfileRemoteDataSource remoteDataSource;

  const ProfileRepoImpl(this.remoteDataSource);

  @override
  Future<UserEntity?> getUserProfile() => remoteDataSource.getUserProfile();

  @override
  Future<void> updateUserProfile({
    required String name,
    required String phone,
    required int avatarIndex,
  }) =>
      remoteDataSource.updateUserProfile(
        name: name,
        phone: phone,
        avatarIndex: avatarIndex,
      );

  @override
  Future<void> deleteAccount() => remoteDataSource.deleteAccount();

  @override
  Future<void> sendPasswordReset() => remoteDataSource.sendPasswordReset();

  @override
  Future<List<MovieEntity>> getWishlist() => remoteDataSource.getWishlist();

  @override
  Future<List<MovieEntity>> getHistory() => remoteDataSource.getHistory();

  @override
  Future<bool> isMovieInWishlist(int movieId) =>
      remoteDataSource.isMovieInWishlist(movieId);

  @override
  Future<bool> toggleWishlist(MovieEntity movie) {
    final movieModel = MovieModel(
      id: movie.id,
      title: movie.title,
      year: movie.year,
      rating: movie.rating,
      runtime: movie.runtime,
      genres: movie.genres,
      summary: movie.summary,
      mediumCoverImage: movie.mediumCoverImage,
      largeCoverImage: movie.largeCoverImage,
      backgroundImage: movie.backgroundImage,
      trailerCode: movie.trailerCode,
    );
    return remoteDataSource.toggleWishlist(movieModel);
  }

  @override
  Future<void> addToHistory(MovieEntity movie) {
    final movieModel = MovieModel(
      id: movie.id,
      title: movie.title,
      year: movie.year,
      rating: movie.rating,
      runtime: movie.runtime,
      genres: movie.genres,
      summary: movie.summary,
      mediumCoverImage: movie.mediumCoverImage,
      largeCoverImage: movie.largeCoverImage,
      backgroundImage: movie.backgroundImage,
      trailerCode: movie.trailerCode,
    );
    return remoteDataSource.addToHistory(movieModel);
  }
}
