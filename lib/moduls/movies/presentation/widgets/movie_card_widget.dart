import 'package:flutter/material.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/movie_entity.dart';
import 'rating_badge_widget.dart';

class MovieCardWidget extends StatelessWidget {
  final MovieEntity movie;
  final double? width;
  final double? height;
  final double borderRadius;
  final VoidCallback? onTap;

  const MovieCardWidget({
    super.key,
    required this.movie,
    this.width,
    this.height,
    this.borderRadius = 16,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ??
          () {
            Navigator.pushNamed(
              context,
              AppRoutes.movieDetails,
              arguments: movie.id,
            );
          },
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: AppColors.surfaceDark,
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            movie.mediumCoverImage.isNotEmpty
                ? Image.network(
                    movie.mediumCoverImage,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => _buildPlaceholder(),
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return Container(
                        color: AppColors.surfaceDark,
                        child: const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.primary,
                          ),
                        ),
                      );
                    },
                  )
                : _buildPlaceholder(),
            Positioned(
              top: 10,
              left: 10,
              child: RatingBadgeWidget(rating: movie.rating),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.surfaceDark,
      child: const Center(
        child: Icon(
          Icons.movie_outlined,
          color: AppColors.grey,
          size: 36,
        ),
      ),
    );
  }
}
