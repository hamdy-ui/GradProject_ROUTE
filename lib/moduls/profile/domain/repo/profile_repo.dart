import '../../../auth/domain/entities/user_entity.dart';
import '../../../movies/domain/entities/movie_entity.dart';

abstract class ProfileRepo {
  Future<UserEntity?> getUserProfile();

  Future<void> updateUserProfile({
    required String name,
    required String phone,
    required int avatarIndex,
  });

  Future<void> deleteAccount();

  Future<void> sendPasswordReset();

  Future<List<MovieEntity>> getWishlist();

  Future<List<MovieEntity>> getHistory();

  Future<bool> isMovieInWishlist(int movieId);

  Future<bool> toggleWishlist(MovieEntity movie);

  Future<void> addToHistory(MovieEntity movie);
}
