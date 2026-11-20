import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../profile/data/data_source/profile_remote_data_source.dart';
import '../../../profile/data/repo/profile_repo_impl.dart';
import '../../../profile/domain/use_cases/profile_use_cases.dart';
import '../../data/data_source/movies_remote_data_source.dart';
import '../../data/repo/movies_repo_impl.dart';
import '../../domain/use_cases/get_movie_details_use_case.dart';
import 'movie_details_state.dart';

class MovieDetailsCubit extends Cubit<MovieDetailsState> {
  final GetMovieDetailsUseCase getMovieDetailsUseCase;
  final IsMovieInWishlistUseCase isMovieInWishlistUseCase;
  final ToggleWishlistUseCase toggleWishlistUseCase;
  final AddToHistoryUseCase addToHistoryUseCase;

  MovieDetailsCubit({
    required this.getMovieDetailsUseCase,
    required this.isMovieInWishlistUseCase,
    required this.toggleWishlistUseCase,
    required this.addToHistoryUseCase,
  }) : super(const MovieDetailsInitialState());

  factory MovieDetailsCubit.create() {
    final moviesDataSource = MoviesRemoteDataSourceImpl();
    final moviesRepo = MoviesRepoImpl(moviesDataSource);
    final profileDataSource = ProfileRemoteDataSourceImpl();
    final profileRepo = ProfileRepoImpl(profileDataSource);

    return MovieDetailsCubit(
      getMovieDetailsUseCase: GetMovieDetailsUseCase(moviesRepo),
      isMovieInWishlistUseCase: IsMovieInWishlistUseCase(profileRepo),
      toggleWishlistUseCase: ToggleWishlistUseCase(profileRepo),
      addToHistoryUseCase: AddToHistoryUseCase(profileRepo),
    );
  }

  Future<void> loadMovieDetails(int movieId) async {
    emit(const MovieDetailsLoadingState());
    try {
      final details = await getMovieDetailsUseCase(movieId: movieId);
      final isInWishlist = await isMovieInWishlistUseCase(movieId);
      emit(MovieDetailsLoadedState(
        movie: details,
        isInWishlist: isInWishlist,
      ));
    } catch (e) {
      emit(MovieDetailsErrorState(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> toggleWishlist() async {
    final currentState = state;
    if (currentState is MovieDetailsLoadedState) {
      try {
        final newStatus = await toggleWishlistUseCase(currentState.movie);
        emit(currentState.copyWith(isInWishlist: newStatus));
      } catch (e) {
        emit(MovieDetailsErrorState(e.toString().replaceAll('Exception: ', '')));
      }
    }
  }

  Future<void> recordWatchHistory() async {
    final currentState = state;
    if (currentState is MovieDetailsLoadedState) {
      try {
        await addToHistoryUseCase(currentState.movie);
        emit(currentState.copyWith(isWatchRecorded: true));
      } catch (_) {}
    }
  }
}
