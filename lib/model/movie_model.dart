class MovieModel {
  final int? page;
  final List<MovieResult> results;
  final int? totalPages;
  final int? totalResults;

  MovieModel({
    this.page,
    required this.results,
    this.totalPages,
    this.totalResults,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      page: json['page'] ?? 0,
      results: (json['results'] as List<dynamic>?)
          ?.map((e) => MovieResult.fromJson(e))
          .toList() ??
          [],
      totalPages: json['total_pages'] ?? 0,
      totalResults: json['total_results'] ?? 0,
    );
  }
}

class MovieResult {
  final int? id;
  final String title;
  final String originalTitle;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final String releaseDate;
  final String originalLanguage;
  final double voteAverage;
  final int voteCount;
  final bool adult;
  final bool video;
  final List<int> genreIds;
  final double popularity;

  MovieResult({
    this.id,
    required this.title,
    required this.originalTitle,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.releaseDate,
    required this.originalLanguage,
    required this.voteAverage,
    required this.voteCount,
    required this.adult,
    required this.video,
    required this.genreIds,
    required this.popularity,
  });

  factory MovieResult.fromJson(Map<String, dynamic> json) {
    return MovieResult(
      id: json['id'] ?? 0,
      title: json['title'] ?? "",
      originalTitle: json['original_title'] ?? "",
      overview: json['overview'] ?? "",
      posterPath: json['poster_path'] ?? "",
      backdropPath: json['backdrop_path'] ?? "",
      releaseDate: json['release_date'] ?? "",
      originalLanguage: json['original_language'] ?? "",
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      voteCount: json['vote_count'] ?? 0,
      adult: json['adult'] ?? false,
      video: json['video'] ?? false,
      genreIds: (json['genre_ids'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList() ??
          [],
      popularity: (json['popularity'] ?? 0).toDouble(),
    );
  }

  /// ✅ Convert object to JSON Map (for Hive/local storage)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'original_title': originalTitle,
      'overview': overview,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'release_date': releaseDate,
      'original_language': originalLanguage,
      'vote_average': voteAverage,
      'vote_count': voteCount,
      'adult': adult,
      'video': video,
      'genre_ids': genreIds,
      'popularity': popularity,
    };
  }
}

