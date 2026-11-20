import 'movie_entity.dart';

class CastEntity {
  final String name;
  final String characterName;
  final String urlSmallImage;

  const CastEntity({
    required this.name,
    required this.characterName,
    this.urlSmallImage = '',
  });
}

class TorrentEntity {
  final String url;
  final String quality;
  final String size;
  final String type;

  const TorrentEntity({
    required this.url,
    required this.quality,
    required this.size,
    this.type = '',
  });
}

class MovieDetailsEntity extends MovieEntity {
  final int likeCount;
  final String descriptionFull;
  final List<String> screenshots;
  final List<CastEntity> cast;
  final List<TorrentEntity> torrents;
  final List<MovieEntity> similarMovies;

  const MovieDetailsEntity({
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
    this.likeCount = 0,
    this.descriptionFull = '',
    this.screenshots = const [],
    this.cast = const [],
    this.torrents = const [],
    this.similarMovies = const [],
  });
}
