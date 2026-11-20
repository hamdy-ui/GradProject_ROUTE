import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/data_source/movies_remote_data_source.dart';
import '../../data/repo/movies_repo_impl.dart';
import '../../domain/use_cases/get_movies_use_case.dart';
import 'movies_state.dart';

class MoviesCubit extends Cubit<MoviesState> {
  final GetMoviesUseCase getMoviesUseCase;

  MoviesCubit({required this.getMoviesUseCase})
      : super(const MoviesInitialState());

  factory MoviesCubit.create() {
    final remoteDataSource = MoviesRemoteDataSourceImpl();
    final repo = MoviesRepoImpl(remoteDataSource);
    return MoviesCubit(getMoviesUseCase: GetMoviesUseCase(repo));
  }

  Future<void> loadHomeMovies() async {
    emit(const MoviesLoadingState());
    try {
      final featured = await getMoviesUseCase(
        limit: 8,
        sortBy: 'rating',
        minimumRating: 7.0,
      );

      final action = await getMoviesUseCase(
        limit: 12,
        genre: 'Action',
        sortBy: 'year',
      );

      emit(MoviesLoadedState(
        featuredMovies: featured,
        actionMovies: action,
        selectedFeaturedIndex: 0,
      ));
    } catch (e) {
      emit(MoviesErrorState(e.toString().replaceAll('Exception: ', '')));
    }
  }

  void selectFeaturedIndex(int index) {
    if (state is MoviesLoadedState) {
      emit((state as MoviesLoadedState).copyWith(selectedFeaturedIndex: index));
    }
  }
}
