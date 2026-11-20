import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/data_source/movies_remote_data_source.dart';
import '../../data/repo/movies_repo_impl.dart';
import '../../domain/use_cases/get_movies_use_case.dart';
import 'browse_state.dart';

class BrowseCubit extends Cubit<BrowseState> {
  final GetMoviesUseCase getMoviesUseCase;

  static const List<String> availableGenres = [
    'Action',
    'Adventure',
    'Animation',
    'Biography',
    'Comedy',
    'Crime',
    'Documentary',
    'Drama',
    'Family',
    'Fantasy',
    'Horror',
    'Romance',
    'Sci-Fi',
    'Thriller',
  ];

  BrowseCubit({required this.getMoviesUseCase})
      : super(const BrowseInitialState());

  factory BrowseCubit.create() {
    final remoteDataSource = MoviesRemoteDataSourceImpl();
    final repo = MoviesRepoImpl(remoteDataSource);
    return BrowseCubit(getMoviesUseCase: GetMoviesUseCase(repo));
  }

  Future<void> selectGenre(String genre) async {
    emit(BrowseLoadingState(selectedGenre: genre));
    try {
      final movies = await getMoviesUseCase(
        genre: genre,
        limit: 20,
        sortBy: 'year',
      );
      emit(BrowseLoadedState(
        selectedGenre: genre,
        movies: movies,
      ));
    } catch (e) {
      emit(BrowseErrorState(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
