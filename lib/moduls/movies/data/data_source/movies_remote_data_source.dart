import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie_details_model.dart';
import '../models/movie_model.dart';

abstract class MoviesRemoteDataSource {
  Future<List<MovieModel>> getMovies({
    int? limit,
    int? page,
    String? quality,
    double? minimumRating,
    String? queryTerm,
    String? genre,
    String? sortBy,
    String? orderBy,
  });

  Future<MovieDetailsModel> getMovieDetails({required int movieId});

  Future<List<MovieModel>> getSimilarMovies({required int movieId});
}

class MoviesRemoteDataSourceImpl implements MoviesRemoteDataSource {
  final http.Client client;
  static const String baseUrl = 'https://yts.pw/api/v2';

  MoviesRemoteDataSourceImpl({http.Client? client})
      : client = client ?? http.Client();

  @override
  Future<List<MovieModel>> getMovies({
    int? limit,
    int? page,
    String? quality,
    double? minimumRating,
    String? queryTerm,
    String? genre,
    String? sortBy,
    String? orderBy,
  }) async {
    final queryParams = <String, String>{};
    if (limit != null) queryParams['limit'] = limit.toString();
    if (page != null) queryParams['page'] = page.toString();
    if (quality != null && quality.isNotEmpty) queryParams['quality'] = quality;
    if (minimumRating != null) {
      queryParams['minimum_rating'] = minimumRating.toString();
    }
    if (queryTerm != null && queryTerm.trim().isNotEmpty) {
      queryParams['query_term'] = queryTerm.trim();
    }
    if (genre != null && genre.isNotEmpty && genre.toLowerCase() != 'all') {
      queryParams['genre'] = genre;
    }
    if (sortBy != null && sortBy.isNotEmpty) queryParams['sort_by'] = sortBy;
    if (orderBy != null && orderBy.isNotEmpty) queryParams['order_by'] = orderBy;

    final uri = Uri.parse('$baseUrl/list_movies.json')
        .replace(queryParameters: queryParams.isNotEmpty ? queryParams : null);

    final response = await client.get(uri);
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      if (data['status'] == 'ok') {
        final moviesJson = data['data']?['movies'] as List<dynamic>?;
        if (moviesJson == null) return [];
        return moviesJson
            .map((e) => MovieModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(data['status_message'] ?? 'Failed to load movies');
      }
    } else {
      throw Exception('Server error: ${response.statusCode}');
    }
  }

  @override
  Future<MovieDetailsModel> getMovieDetails({required int movieId}) async {
    final uri = Uri.parse(
      '$baseUrl/movie_details.json?movie_id=$movieId&with_images=true&with_cast=true',
    );

    final response = await client.get(uri);
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      if (data['status'] == 'ok') {
        final movieJson = data['data']?['movie'] as Map<String, dynamic>?;
        if (movieJson == null) throw Exception('Movie not found');

        // Fetch similar movies to embed in details
        final similarMovies = await getSimilarMovies(movieId: movieId);
        return MovieDetailsModel.fromJson(
          movieJson,
          similarMovies: similarMovies,
        );
      } else {
        throw Exception(data['status_message'] ?? 'Failed to load movie details');
      }
    } else {
      throw Exception('Server error: ${response.statusCode}');
    }
  }

  @override
  Future<List<MovieModel>> getSimilarMovies({required int movieId}) async {
    try {
      final uri = Uri.parse('$baseUrl/movie_suggestions.json?movie_id=$movieId');
      final response = await client.get(uri);
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        if (data['status'] == 'ok') {
          final moviesJson = data['data']?['movies'] as List<dynamic>?;
          if (moviesJson == null) return [];
          return moviesJson
              .map((e) => MovieModel.fromJson(e as Map<String, dynamic>))
              .toList();
        }
      }
      return [];
    } catch (_) {
      return [];
    }
  }
}
