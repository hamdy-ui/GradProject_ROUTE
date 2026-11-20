import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../domain/entities/movie_details_entity.dart';
import '../manager/movie_details_cubit.dart';
import '../manager/movie_details_state.dart';
import '../widgets/movie_card_widget.dart';

class MovieDetailsScreen extends StatelessWidget {
  final int movieId;

  const MovieDetailsScreen({
    super.key,
    required this.movieId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MovieDetailsCubit.create()..loadMovieDetails(movieId),
      child: const _MovieDetailsBody(),
    );
  }
}

class _MovieDetailsBody extends StatelessWidget {
  const _MovieDetailsBody();

  Future<void> _launchUrl(BuildContext context, String urlString) async {
    if (urlString.isEmpty) return;
    final uri = Uri.parse(urlString);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not launch player link')),
          );
        }
      }
    } catch (_) {}
  }

  void _onWatchPressed(BuildContext context, MovieDetailsEntity movie) {
    context.read<MovieDetailsCubit>().recordWatchHistory();

    if (movie.trailerCode.isNotEmpty) {
      final trailerUrl = 'https://www.youtube.com/watch?v=${movie.trailerCode}';
      _launchUrl(context, trailerUrl);
    } else if (movie.torrents.isNotEmpty && movie.torrents.first.url.isNotEmpty) {
      _launchUrl(context, movie.torrents.first.url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.surfaceDark,
          content: Text('Watch recorded in your History!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: BlocConsumer<MovieDetailsCubit, MovieDetailsState>(
        listener: (context, state) {
          if (state is MovieDetailsLoadedState && state.isWatchRecorded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                duration: Duration(seconds: 1),
                backgroundColor: AppColors.surfaceDark,
                content: Text(
                  'Added to History!',
                  style: TextStyle(color: AppColors.white),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is MovieDetailsLoadingState) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          } else if (state is MovieDetailsErrorState) {
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
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Go Back'),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is MovieDetailsLoadedState) {
            final movie = state.movie;
            final isInWishlist = state.isInWishlist;

            return CustomScrollView(
              slivers: [
                // Top Backdrop Hero Header
                SliverToBoxAdapter(
                  child: Stack(
                    children: [
                      // Backdrop / Cover Image
                      SizedBox(
                        height: 520,
                        width: double.infinity,
                        child: Image.network(
                          movie.largeCoverImage.isNotEmpty
                              ? movie.largeCoverImage
                              : movie.backgroundImage,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Container(
                            color: AppColors.surfaceDark,
                          ),
                        ),
                      ),
                      // Gradient Overlay
                      Container(
                        height: 520,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppColors.scaffoldBackground.withValues(alpha: 0.3),
                              AppColors.scaffoldBackground.withValues(alpha: 0.7),
                              AppColors.scaffoldBackground,
                            ],
                            stops: const [0.0, 0.6, 1.0],
                          ),
                        ),
                      ),
                      // Top Icons: Back & Bookmark
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(
                                  Icons.arrow_back_ios_new,
                                  color: AppColors.white,
                                  size: 24,
                                ),
                              ),
                              IconButton(
                                onPressed: () => context
                                    .read<MovieDetailsCubit>()
                                    .toggleWishlist(),
                                icon: Icon(
                                  isInWishlist
                                      ? Icons.bookmark_rounded
                                      : Icons.bookmark_outline_rounded,
                                  color: isInWishlist
                                      ? AppColors.primary
                                      : AppColors.white,
                                  size: 28,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Center Play Button (trailers)
                      Positioned(
                        top: 200,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: GestureDetector(
                            onTap: () {
                              if (movie.trailerCode.isNotEmpty) {
                                _launchUrl(
                                  context,
                                  'https://www.youtube.com/watch?v=${movie.trailerCode}',
                                );
                              }
                            },
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.redButton.withValues(alpha: 0.9),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.redButton.withValues(alpha: 0.5),
                                    blurRadius: 20,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.play_arrow_rounded,
                                color: AppColors.white,
                                size: 48,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Title & Year
                      Positioned(
                        bottom: 12,
                        left: 20,
                        right: 20,
                        child: Column(
                          children: [
                            Text(
                              movie.title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                                height: 1.3,
                              ),
                            ),
                            verticalSpace(8),
                            Text(
                              '${movie.year}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFADADAD),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Body Content
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      verticalSpace(12),
                      // "Watch" CTA Button
                      SizedBox(
                        height: 56,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.redButton,
                            foregroundColor: AppColors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () => _onWatchPressed(context, movie),
                          child: const Text(
                            'Watch',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      verticalSpace(18),
                      // Stats Row: Likes, Runtime, Rating
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              icon: Icons.favorite,
                              text: '${movie.likeCount}',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              icon: Icons.access_time_filled,
                              text: '${movie.runtime}',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              icon: Icons.star,
                              text: movie.rating.toStringAsFixed(1),
                            ),
                          ),
                        ],
                      ),
                      verticalSpace(24),
                      // Screen Shots Section
                      if (movie.screenshots.isNotEmpty) ...[
                        const Text(
                          'Screen Shots',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        ),
                        verticalSpace(14),
                        ...movie.screenshots.map((screenUrl) => Padding(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.network(
                                  screenUrl,
                                  height: 170,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) =>
                                      const SizedBox.shrink(),
                                ),
                              ),
                            )),
                        verticalSpace(16),
                      ],
                      // Similar Movies Section
                      if (movie.similarMovies.isNotEmpty) ...[
                        const Text(
                          'Similar',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        ),
                        verticalSpace(14),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.68,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 14,
                          ),
                          itemCount: movie.similarMovies.length,
                          itemBuilder: (context, index) {
                            final similar = movie.similarMovies[index];
                            return MovieCardWidget(movie: similar);
                          },
                        ),
                        verticalSpace(24),
                      ],
                      // Summary Section
                      if (movie.descriptionFull.isNotEmpty ||
                          movie.summary.isNotEmpty) ...[
                        const Text(
                          'Summary',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        ),
                        verticalSpace(12),
                        Text(
                          movie.descriptionFull.isNotEmpty
                              ? movie.descriptionFull
                              : movie.summary,
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.white,
                            height: 1.45,
                          ),
                        ),
                        verticalSpace(24),
                      ],
                      // Cast Section
                      if (movie.cast.isNotEmpty) ...[
                        const Text(
                          'Cast',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        ),
                        verticalSpace(14),
                        ...movie.cast.map((castItem) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceDark,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: castItem.urlSmallImage.isNotEmpty
                                          ? Image.network(
                                              castItem.urlSmallImage,
                                              width: 60,
                                              height: 60,
                                              fit: BoxFit.cover,
                                              errorBuilder: (_, _, _) =>
                                                  _castPlaceholder(),
                                            )
                                          : _castPlaceholder(),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Name : ${castItem.name}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.white,
                                            ),
                                          ),
                                          if (castItem
                                              .characterName.isNotEmpty) ...[
                                            const SizedBox(height: 4),
                                            Text(
                                              'Character : ${castItem.characterName}',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Color(0xFFD6D6D6),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                        verticalSpace(16),
                      ],
                      // Genres Section
                      if (movie.genres.isNotEmpty) ...[
                        const Text(
                          'Genres',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        ),
                        verticalSpace(14),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: movie.genres.map((genre) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceDark,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                genre,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: AppColors.white,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        verticalSpace(36),
                      ],
                    ]),
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildStatCard({required IconData icon, required String text}) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _castPlaceholder() {
    return Container(
      width: 60,
      height: 60,
      color: AppColors.cardDark,
      child: const Icon(Icons.person, color: AppColors.primary, size: 30),
    );
  }
}
