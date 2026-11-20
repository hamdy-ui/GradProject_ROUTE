import '../../../auth/domain/entities/user_entity.dart';
import '../../../movies/domain/entities/movie_entity.dart';
import '../repo/profile_repo.dart';

class GetUserProfileUseCase {
  final ProfileRepo _repository;
  const GetUserProfileUseCase(this._repository);
  Future<UserEntity?> call() => _repository.getUserProfile();
}

class UpdateUserProfileUseCase {
  final ProfileRepo _repository;
  const UpdateUserProfileUseCase(this._repository);
  Future<void> call({
    required String name,
    required String phone,
    required int avatarIndex,
  }) =>
      _repository.updateUserProfile(
        name: name,
        phone: phone,
        avatarIndex: avatarIndex,
      );
}

class DeleteAccountUseCase {
  final ProfileRepo _repository;
  const DeleteAccountUseCase(this._repository);
  Future<void> call() => _repository.deleteAccount();
}

class SendPasswordResetUseCase {
  final ProfileRepo _repository;
  const SendPasswordResetUseCase(this._repository);
  Future<void> call() => _repository.sendPasswordReset();
}

class GetWishlistUseCase {
  final ProfileRepo _repository;
  const GetWishlistUseCase(this._repository);
  Future<List<MovieEntity>> call() => _repository.getWishlist();
}

class GetHistoryUseCase {
  final ProfileRepo _repository;
  const GetHistoryUseCase(this._repository);
  Future<List<MovieEntity>> call() => _repository.getHistory();
}

class ToggleWishlistUseCase {
  final ProfileRepo _repository;
  const ToggleWishlistUseCase(this._repository);
  Future<bool> call(MovieEntity movie) => _repository.toggleWishlist(movie);
}

class AddToHistoryUseCase {
  final ProfileRepo _repository;
  const AddToHistoryUseCase(this._repository);
  Future<void> call(MovieEntity movie) => _repository.addToHistory(movie);
}

class IsMovieInWishlistUseCase {
  final ProfileRepo _repository;
  const IsMovieInWishlistUseCase(this._repository);
  Future<bool> call(int movieId) => _repository.isMovieInWishlist(movieId);
}
