import 'package:flutter_riverpod/legacy.dart';
import 'package:movie_mate/repository/movie_repo.dart';

import '../view_model/movie_view_model.dart';

final movieProvider = ChangeNotifierProvider<MovieViewModel>((ref) {
  return MovieViewModel(repo: MovieService());
});

