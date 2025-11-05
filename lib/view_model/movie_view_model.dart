import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import '../model/movie_model.dart';
import '../repository/movie_repo.dart';


class MovieViewModel extends ChangeNotifier {
  final MovieRepository? repo;
  MovieViewModel({required this.repo});

  List<String> myList = ["Favorites", "Watchlist"];
  String selectedData = "Favorites";

  List<MovieResult> movieList = [];
  List<MovieResult> movieFavoriteList = [];
  List<MovieResult> movieWatchList = [];
  bool isLoading = false;
  bool isPaginating = false;
  String errorMessage = "";

  int _currentPage = 1;
  bool _hasMore = true;
  MovieProvider() {
    _loadFromHive();
  }

  /// Load from local Hive when app starts
  Future<void> _loadFromHive() async {
    final favoritesBox = Hive.box('favoritesBox');
    final watchlistBox = Hive.box('watchlistBox');

    movieFavoriteList = (favoritesBox.values.toList())
        .map((e) => MovieResult.fromJson(Map<String, dynamic>.from(e)))
        .toList();

    movieWatchList = (watchlistBox.values.toList())
        .map((e) => MovieResult.fromJson(Map<String, dynamic>.from(e)))
        .toList();

    notifyListeners();
  }

  /// Add/remove from favorite
  Future<void> toggleFavorite(MovieResult movie) async {
    final favoritesBox = Hive.box('favoritesBox');
    final exists = movieFavoriteList.any((m) => m.id == movie.id);

    if (exists) {
      movieFavoriteList.removeWhere((m) => m.id == movie.id);
      await favoritesBox.delete(movie.id);
    } else {
      movieFavoriteList.add(movie);
      await favoritesBox.put(movie.id, movie.toJson());
    }

    notifyListeners();
  }

  /// Add/remove from watchlist
  Future<void> toggleWatchlist(MovieResult movie) async {
    final watchlistBox = Hive.box('watchlistBox');
    final exists = movieWatchList.any((m) => m.id == movie.id);

    if (exists) {
      movieWatchList.removeWhere((m) => m.id == movie.id);
      await watchlistBox.delete(movie.id);
    } else {
      movieWatchList.add(movie);
      await watchlistBox.put(movie.id, movie.toJson());
    }

    notifyListeners();
  }

  Future<void> getMovieList() async {
    try {
      isLoading = true;
      errorMessage = "";
      notifyListeners();
      _currentPage = 1;
      _hasMore = true;
      movieList.clear();
      final data = await repo?.fetchMovieList(page: _currentPage);
      if (data != null) {
        if (data != null && data.results.isNotEmpty) {
          movieList = data.results;
        } else {
          errorMessage = "No movies found";
        }
      } else {
        errorMessage = "No movies found";
      }
    } catch (e) {
      errorMessage = "Error fetching movies: $e";
      notifyListeners();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreMovies() async {
    if (isPaginating || !_hasMore) return;
    try {
      isPaginating = true;
      notifyListeners();
      _currentPage++;
      final moreData = await repo?.fetchMovieList(page: _currentPage);

      if (moreData != null && moreData.results.isNotEmpty) {
        _hasMore = false;
      } else {
        movieList.addAll(moreData.results);
      }
    } catch (e) {
      debugPrint("Pagination error: $e");
    } finally {
      isPaginating = false;
      notifyListeners();
    }
  }
}
