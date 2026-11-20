import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/data_source/profile_remote_data_source.dart';
import '../../data/repo/profile_repo_impl.dart';
import '../../domain/use_cases/profile_use_cases.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetUserProfileUseCase getUserProfileUseCase;
  final UpdateUserProfileUseCase updateUserProfileUseCase;
  final DeleteAccountUseCase deleteAccountUseCase;
  final SendPasswordResetUseCase sendPasswordResetUseCase;
  final GetWishlistUseCase getWishlistUseCase;
  final GetHistoryUseCase getHistoryUseCase;

  ProfileCubit({
    required this.getUserProfileUseCase,
    required this.updateUserProfileUseCase,
    required this.deleteAccountUseCase,
    required this.sendPasswordResetUseCase,
    required this.getWishlistUseCase,
    required this.getHistoryUseCase,
  }) : super(const ProfileInitialState());

  factory ProfileCubit.create() {
    final remoteDataSource = ProfileRemoteDataSourceImpl();
    final repo = ProfileRepoImpl(remoteDataSource);

    return ProfileCubit(
      getUserProfileUseCase: GetUserProfileUseCase(repo),
      updateUserProfileUseCase: UpdateUserProfileUseCase(repo),
      deleteAccountUseCase: DeleteAccountUseCase(repo),
      sendPasswordResetUseCase: SendPasswordResetUseCase(repo),
      getWishlistUseCase: GetWishlistUseCase(repo),
      getHistoryUseCase: GetHistoryUseCase(repo),
    );
  }

  Future<void> loadProfileData() async {
    emit(const ProfileLoadingState());
    try {
      final user = await getUserProfileUseCase();
      final wishlist = await getWishlistUseCase();
      final history = await getHistoryUseCase();

      emit(ProfileLoadedState(
        user: user,
        wishlist: wishlist,
        history: history,
        selectedTab: ProfileTab.wishlist,
      ));
    } catch (e) {
      emit(ProfileErrorState(e.toString().replaceAll('Exception: ', '')));
    }
  }

  void switchTab(ProfileTab tab) {
    if (state is ProfileLoadedState) {
      emit((state as ProfileLoadedState).copyWith(selectedTab: tab));
    }
  }

  Future<void> updateProfile({
    required String name,
    required String phone,
    required int avatarIndex,
  }) async {
    emit(const ProfileLoadingState());
    try {
      await updateUserProfileUseCase(
        name: name,
        phone: phone,
        avatarIndex: avatarIndex,
      );
      emit(const ProfileUpdateSuccessState('Profile updated successfully!'));
      await loadProfileData();
    } catch (e) {
      emit(ProfileErrorState(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> sendPasswordReset() async {
    try {
      await sendPasswordResetUseCase();
    } catch (e) {
      emit(ProfileErrorState(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> deleteAccount() async {
    emit(const ProfileLoadingState());
    try {
      await deleteAccountUseCase();
      emit(const ProfileAccountDeletedState());
    } catch (e) {
      emit(ProfileErrorState(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
