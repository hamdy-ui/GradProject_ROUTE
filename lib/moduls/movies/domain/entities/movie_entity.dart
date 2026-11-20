class MovieEntity {
  final int id;
  final String title;
  final int year;
  final double rating;
  final int runtime;
  final List<String> genres;
  final String summary;
  final String mediumCoverImage;
  final String largeCoverImage;
  final String backgroundImage;
  final String trailerCode;

  const MovieEntity({
    required this.id,
    required this.title,
    required this.year,
    required this.rating,
    this.runtime = 0,
    this.genres = const [],
    this.summary = '',
    this.mediumCoverImage = '',
    this.largeCoverImage = '',
    this.backgroundImage = '',
    this.trailerCode = '',
  });
}
