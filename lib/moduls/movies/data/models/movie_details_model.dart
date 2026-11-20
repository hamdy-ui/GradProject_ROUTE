import '../../domain/entities/movie_details_entity.dart';
import '../../domain/entities/movie_entity.dart';

class CastModel extends CastEntity {
  const CastModel({
    required super.name,
    required super.characterName,
    super.urlSmallImage,
  });

  factory CastModel.fromJson(Map<String, dynamic> json) {
    return CastModel(
      name: json['name'] as String? ?? 'Actor',
      characterName: json['character_name'] as String? ?? '',
      urlSmallImage: json['url_small_image'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'character_name': characterName,
      'url_small_image': urlSmallImage,
    };
  }
}

class TorrentModel extends TorrentEntity {
  const TorrentModel({
    required super.url,
    required super.quality,
    required super.size,
    super.type,
  });

  factory TorrentModel.fromJson(Map<String, dynamic> json) {
    return TorrentModel(
      url: json['url'] as String? ?? '',
      quality: json['quality'] as String? ?? '',
      size: json['size'] as String? ?? '',
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'quality': quality,
      'size': size,
      'type': type,
    };
  }
}

class MovieDetailsModel extends MovieDetailsEntity {
  const MovieDetailsModel({
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
    super.likeCount,
    super.descriptionFull,
    super.screenshots,
    super.cast,
    super.torrents,
    super.similarMovies,
  });

  factory MovieDetailsModel.fromJson(
    Map<String, dynamic> json, {
    List<MovieEntity> similarMovies = const [],
  }) {
    final screenshots = <String>[];
    for (int i = 1; i <= 3; i++) {
      final largeScreen = json['large_screenshot_image$i'] as String?;
      final medScreen = json['medium_screenshot_image$i'] as String?;
      if (largeScreen != null && largeScreen.isNotEmpty) {
        screenshots.add(largeScreen);
      } else if (medScreen != null && medScreen.isNotEmpty) {
        screenshots.add(medScreen);
      }
    }

    final castList = (json['cast'] as List<dynamic>?)
            ?.map((e) => CastModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        const <CastModel>[];

    final torrentList = (json['torrents'] as List<dynamic>?)
            ?.map((e) => TorrentModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        const <TorrentModel>[];

    return MovieDetailsModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? 'Unknown',
      year: (json['year'] as num?)?.toInt() ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      runtime: (json['runtime'] as num?)?.toInt() ?? 0,
      genres: (json['genres'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      summary: json['description_intro'] as String? ??
          json['summary'] as String? ??
          '',
      descriptionFull: json['description_full'] as String? ??
          json['summary'] as String? ??
          '',
      likeCount: (json['like_count'] as num?)?.toInt() ?? 0,
      mediumCoverImage: json['medium_cover_image'] as String? ?? '',
      largeCoverImage: json['large_cover_image'] as String? ??
          json['medium_cover_image'] as String? ??
          '',
      backgroundImage: json['background_image_original'] as String? ??
          json['background_image'] as String? ??
          '',
      trailerCode: json['yt_trailer_code'] as String? ?? '',
      screenshots: screenshots,
      cast: castList,
      torrents: torrentList,
      similarMovies: similarMovies,
    );
  }
}
