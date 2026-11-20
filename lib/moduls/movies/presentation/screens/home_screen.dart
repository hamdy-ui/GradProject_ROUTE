import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../manager/movies_cubit.dart';
import '../manager/movies_state.dart';
import '../widgets/movie_card_widget.dart';
import '../widgets/rating_badge_widget.dart';

class HomeScreen extends StatelessWidget {
  final ValueChanged<int>? onNavigateTab;

  const HomeScreen({
    super.key,
    this.onNavigateTab,
  });

  @override
  Widget build(BuildContext context) {
    return const _HomeScreenBody();
  }
}

class _HomeScreenBody extends StatefulWidget {
  const _HomeScreenBody();

  @override
  State<_HomeScreenBody> createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends State<_HomeScreenBody> {
  late final PageController _featuredPageController;
  int _currentFeaturedIndex = 0;

  @override
  void initState() {
    super.initState();
    _featuredPageController = PageController(
      viewportFraction: 0.65,
      initialPage: 0,
    );
    context.read<MoviesCubit>().loadHomeMovies();
  }

  @override
  void dispose() {
    _featuredPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: BlocBuilder<MoviesCubit, MoviesState>(
        builder: (context, state) {
          if (state is MoviesLoadingState) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          } else if (state is MoviesErrorState) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: AppStyles.font16WhiteRegular,
                    ),
                    verticalSpace(16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.black,
                      ),
                      onPressed: () =>
                          context.read<MoviesCubit>().loadHomeMovies(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is MoviesLoadedState) {
            final featured = state.featuredMovies;
            final actionMovies = state.actionMovies;
            final currentMovie =
                featured.isNotEmpty ? featured[_currentFeaturedIndex] : null;

            return SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 90),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Top Hero Banner Section
                  Stack(
                    children: [
                      // Backdrop Background with Gradient Fade
                      if (currentMovie != null &&
                          currentMovie.backgroundImage.isNotEmpty)
                        SizedBox(
                          height: 520,
                          width: double.infinity,
                          child: Image.network(
                            currentMovie.backgroundImage,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => Container(
                              color: AppColors.scaffoldBackground,
                            ),
                          ),
                        )
                      else
                        Container(
                          height: 520,
                          color: AppColors.scaffoldBackground,
                        ),
                      // Dark Gradient Overlay
                      Container(
                        height: 520,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppColors.scaffoldBackground.withValues(alpha: 0.8),
                              AppColors.scaffoldBackground.withValues(alpha: 0.45),
                              AppColors.scaffoldBackground,
                            ],
                            stops: const [0.0, 0.5, 1.0],
                          ),
                        ),
                      ),
                      // Content inside Hero
                      SafeArea(
                        bottom: false,
                        child: Column(
                          children: [
                            verticalSpace(12),
                            // "Available Now" Banner
                            Center(
                              child: Image.asset(
                                AppAssets.availableNow,
                                height: 50,
                                fit: BoxFit.contain,
                                errorBuilder: (_, _, _) => const Text(
                                  'AVAILABLE NOW',
                                  style: AppStyles.font24WhiteBold,
                                ),
                              ),
                            ),
                            verticalSpace(20),
                            // Featured 3D/Carousel Movie Slider
                            if (featured.isNotEmpty)
                              SizedBox(
                                height: 350,
                                child: PageView.builder(
                                  controller: _featuredPageController,
                                  itemCount: featured.length,
                                  onPageChanged: (index) {
                                    setState(() {
                                      _currentFeaturedIndex = index;
                                    });
                                  },
                                  itemBuilder: (context, index) {
                                    final movie = featured[index];
                                    final isSelected =
                                        index == _currentFeaturedIndex;
                                    final scale = isSelected ? 1.0 : 0.85;

                                    return Center(
                                      child: AnimatedScale(
                                        scale: scale,
                                        duration:
                                            const Duration(milliseconds: 300),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.pushNamed(
                                              context,
                                              AppRoutes.movieDetails,
                                              arguments: movie.id,
                                            );
                                          },
                                          child: Container(
                                            width: 234,
                                            height: 350,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: AppColors.surfaceDark,
                                              boxShadow: isSelected
                                                  ? [
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withValues(alpha: 0.5),
                                                        blurRadius: 20,
                                                        offset:
                                                            const Offset(0, 8),
                                                      ),
                                                    ]
                                                  : null,
                                            ),
                                            clipBehavior: Clip.antiAlias,
                                            child: Stack(
                                              fit: StackFit.expand,
                                              children: [
                                                movie.largeCoverImage.isNotEmpty
                                                    ? Image.network(
                                                        movie.largeCoverImage,
                                                        fit: BoxFit.cover,
                                                        errorBuilder:
                                                            (_, _, _) =>
                                                                Container(
                                                          color: AppColors
                                                              .surfaceDark,
                                                        ),
                                                      )
                                                    : Container(
                                                        color: AppColors
                                                            .surfaceDark,
                                                      ),
                                                Positioned(
                                                  top: 14,
                                                  left: 14,
                                                  child: RatingBadgeWidget(
                                                    rating: movie.rating,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            verticalSpace(12),
                            // "Watch Now" Graphic Button
                            if (currentMovie != null)
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.movieDetails,
                                    arguments: currentMovie.id,
                                  );
                                },
                                child: Image.asset(
                                  AppAssets.watchNow,
                                  height: 80,
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, _, _) => Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 24),
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'WATCH NOW',
                                        style: AppStyles.font20BlackBold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  verticalSpace(20),
                  // "Action" Header + "See More"
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Action',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.browse,
                            );
                          },
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'See More',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 6),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: AppColors.primary,
                                size: 14,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  verticalSpace(16),
                  // Horizontal Action Movies List
                  SizedBox(
                    height: 220,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      itemCount: actionMovies.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 14),
                      itemBuilder: (context, index) {
                        final movie = actionMovies[index];
                        return MovieCardWidget(
                          movie: movie,
                          width: 146,
                          height: 220,
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
