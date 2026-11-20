import '../../domain/entities/movie_entity.dart';

class MovieModel extends MovieEntity {
  const MovieModel({
    required super.id,
    required super.title,
    required super.year,
    required super.rating,
    super.runtime,
    super.genres,
    super.summary,
    super.mediumCoverImage,
    super.largeCoverImage,
    super.backgroundImage,
    super.trailerCode,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? 'Unknown',
      year: (json['year'] as num?)?.toInt() ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      runtime: (json['runtime'] as num?)?.toInt() ?? 0,
      genres: (json['genres'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      summary: json['summary'] as String? ??
          json['description_full'] as String? ??
          '',
      mediumCoverImage: json['medium_cover_image'] as String? ?? '',
      largeCoverImage: json['large_cover_image'] as String? ??
          json['medium_cover_image'] as String? ??
          '',
      backgroundImage: json['background_image_original'] as String? ??
          json['background_image'] as String? ??
          '',
      trailerCode: json['yt_trailer_code'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'year': year,
      'rating': rating,
      'runtime': runtime,
      'genres': genres,
      'summary': summary,
      'medium_cover_image': mediumCoverImage,
      'large_cover_image': largeCoverImage,
      'background_image': backgroundImage,
      'yt_trailer_code': trailerCode,
    };
  }
}
