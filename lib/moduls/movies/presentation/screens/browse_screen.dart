import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../manager/browse_cubit.dart';
import '../manager/browse_state.dart';
import '../widgets/movie_card_widget.dart';

class BrowseScreen extends StatefulWidget {
  final String? initialGenre;

  const BrowseScreen({
    super.key,
    this.initialGenre,
  });

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  late String _selectedGenre;

  @override
  void initState() {
    super.initState();
    _selectedGenre = widget.initialGenre ?? BrowseCubit.availableGenres.first;
    context.read<BrowseCubit>().selectGenre(_selectedGenre);
  }

  void _onGenreTapped(String genre) {
    if (_selectedGenre == genre) return;
    setState(() {
      _selectedGenre = genre;
    });
    context.read<BrowseCubit>().selectGenre(genre);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            verticalSpace(16),
            // Genre Category Tabs (Horizontal Scroll)
            SizedBox(
              height: 48,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: BrowseCubit.availableGenres.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final genre = BrowseCubit.availableGenres[index];
                  final isSelected = genre == _selectedGenre;

                  return GestureDetector(
                    onTap: () => _onGenreTapped(genre),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.primary,
                          width: 2,
                        ),
                      ),
                      child: Text(
                        genre,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? AppColors.black : AppColors.primary,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            verticalSpace(16),
            // 2-Column Movie Grid
            Expanded(
              child: BlocBuilder<BrowseCubit, BrowseState>(
                builder: (context, state) {
                  if (state is BrowseLoadingState) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  } else if (state is BrowseErrorState) {
                    return Center(
                      child: Text(
                        state.message,
                        style: AppStyles.font16WhiteRegular,
                        textAlign: TextAlign.center,
                      ),
                    );
                  } else if (state is BrowseLoadedState) {
                    final movies = state.movies;
                    if (movies.isEmpty) {
                      return const Center(
                        child: Text(
                          'No movies found for this genre',
                          style: AppStyles.font16WhiteRegular,
                        ),
                      );
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.68,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                      ),
                      itemCount: movies.length,
                      itemBuilder: (context, index) {
                        return MovieCardWidget(movie: movies[index]);
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
