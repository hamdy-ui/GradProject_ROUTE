import '../../../auth/domain/entities/user_entity.dart';
import '../../../movies/domain/entities/movie_entity.dart';

enum ProfileTab { wishlist, history }

sealed class ProfileState {
  const ProfileState();
}

class ProfileInitialState extends ProfileState {
  const ProfileInitialState();
}

class ProfileLoadingState extends ProfileState {
  const ProfileLoadingState();
}

class ProfileLoadedState extends ProfileState {
  final UserEntity? user;
  final List<MovieEntity> wishlist;
  final List<MovieEntity> history;
  final ProfileTab selectedTab;

  const ProfileLoadedState({
    this.user,
    required this.wishlist,
    required this.history,
    this.selectedTab = ProfileTab.wishlist,
  });

  ProfileLoadedState copyWith({
    UserEntity? user,
    List<MovieEntity>? wishlist,
    List<MovieEntity>? history,
    ProfileTab? selectedTab,
  }) {
    return ProfileLoadedState(
      user: user ?? this.user,
      wishlist: wishlist ?? this.wishlist,
      history: history ?? this.history,
      selectedTab: selectedTab ?? this.selectedTab,
    );
  }
}

class ProfileUpdateSuccessState extends ProfileState {
  final String message;
  const ProfileUpdateSuccessState(this.message);
}

class ProfileAccountDeletedState extends ProfileState {
  const ProfileAccountDeletedState();
}

class ProfileErrorState extends ProfileState {
  final String message;
  const ProfileErrorState(this.message);
}
