import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:movie_mate/provider/movie_provider.dart';
import 'package:movie_mate/utils/constants.dart';
import 'package:shimmer/shimmer.dart';

import '../provider/theme_provider.dart';
import '../utils/global_auth.dart';
import '../utils/theme_utils.dart';
import 'movie_details_screen.dart';

class MovieListScreen extends ConsumerStatefulWidget {
  const MovieListScreen({super.key});

  @override
  ConsumerState<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends ConsumerState<MovieListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(movieProvider).MovieProvider();
      ref.read(movieProvider).getMovieList();
    });
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final provider = ref.read(movieProvider);
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!provider.isPaginating && !provider.isLoading) {
        provider.loadMoreMovies();
      }
    }
  }

  Future<void> _handleRefresh() async {
    await ref.read(movieProvider).getMovieList();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLightMode = ref.watch(themeProvider);
    final themeData = CustomTheme.getTheme(isLightMode);
    final provider = ref.watch(movieProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeData!.primaryColor,
        centerTitle: true,
        title: Text(
          Constants.MOVIE,
          style: themeData.textTheme.titleLarge!
              .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (final item in provider.myList)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: provider.selectedData == item
                              ? themeData.primaryColor
                              : Colors.grey.shade300,
                          foregroundColor: provider.selectedData == item
                              ? Colors.white
                              : Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          setState(() => provider.selectedData = item);
                        },
                        child: Text(item),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              if (provider.selectedData == "Favorites" &&
                  provider.movieFavoriteList.isNotEmpty) ...[
                Text(
                  "Favorite Movies",
                  style: themeData.textTheme.titleMedium,
                ),
                const SizedBox(height: 8),

                SizedBox(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: provider.movieFavoriteList.map((movie) {
                        final imageUrl = '$imageBase${movie.posterPath}';
                        final screenWidth = MediaQuery.of(context).size.width;
                        final imageSize = screenWidth * 0.28; // Responsive size (28% of screen width)

                        return Container(
                          width: imageSize,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: imageUrl,
                                  width: imageSize,
                                  height: imageSize * 1.4, // Slightly taller for movie posters
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  ),
                                  errorWidget: (context, url, error) => const Icon(
                                    Icons.broken_image,
                                    size: 40,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: Text(
                                  movie.title,
                                  style: themeData.textTheme.bodySmall!
                                      .copyWith(fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              if (provider.selectedData == "Watchlist" &&
                  provider.movieWatchList.isNotEmpty) ...[
                Text(
                  "Watchlist Movies",
                  style: themeData.textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: provider.movieWatchList.map((movie) {
                        final imageUrl = '$imageBase${movie.posterPath}';
                        final screenWidth = MediaQuery.of(context).size.width;
                        final imageSize = screenWidth * 0.28; // Responsive size (28% of screen width)

                        return Container(
                          width: imageSize,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: imageUrl,
                                  width: imageSize,
                                  height: imageSize * 1.4, // Slightly taller for movie posters
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  ),
                                  errorWidget: (context, url, error) => const Icon(
                                    Icons.broken_image,
                                    size: 40,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: Text(
                                  movie.title,
                                  style: themeData.textTheme.bodySmall!
                                      .copyWith(fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],

              Expanded(
                child: provider.isLoading
                    ? _buildShimmerGrid()
                    : provider.errorMessage.isNotEmpty
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(provider.errorMessage),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: themeData.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: _handleRefresh,
                        child: Text(
                          Constants.RETRY,
                          style: themeData.textTheme.titleMedium!
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                )
                    : provider.movieList.isEmpty
                    ? const Center(
                  child: Text(Constants.NO_DATA),
                )
                    : GridView.builder(
                  controller: _scrollController,
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: provider.movieList.length +
                      (provider.isPaginating ? 2 : 0),
                  itemBuilder: (context, index) {
                    if (index >= provider.movieList.length) {
                      return _buildShimmerItem();
                    }

                    final movie = provider.movieList[index];
                    final imageUrl = '$imageBase${movie.posterPath}';

                    final isFavorite = provider.movieFavoriteList
                        .any((item) => item.id == movie.id);
                    final isWatchlist = provider.movieWatchList
                        .any((item) => item.id == movie.id);

                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                MovieDetailsScreen(result: movie),
                          ),
                        );
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: Stack(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: imageUrl,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    placeholder: (context, url) =>
                                    const Center(
                                        child:
                                        CircularProgressIndicator()),
                                    errorWidget:
                                        (context, url, error) =>
                                    const Icon(
                                      Icons.broken_image,
                                      color: Colors.grey,
                                      size: 50,
                                    ),
                                  ),
                                  Positioned(
                                    top: 6,
                                    right: 6,
                                    left: 6,
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceBetween,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            ref.read(movieProvider).toggleFavorite(movie);
                                          },
                                          child: Icon(
                                            isFavorite
                                                ? Icons.favorite
                                                : Icons
                                                .favorite_border,
                                            color: Colors.pink,
                                            size: 26,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            ref.read(movieProvider).toggleWatchlist(movie);
                                          },
                                          child: Icon(
                                            isWatchlist
                                                ? Icons.bookmark
                                                : Icons
                                                .bookmark_border,
                                            color: Colors.red,
                                            size: 26,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              color: Colors.white,
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    movie.title,
                                    style: themeData
                                        .textTheme.titleMedium,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "${Constants.RELEASE_DATE} ${(movie.releaseDate == "") ? "--" : DateFormat("dd-MM-yyyy").format(DateTime.parse(movie.releaseDate))}",
                                    style: themeData
                                        .textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerGrid() {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.7,
      ),
      itemCount: 6,
      itemBuilder: (context, index) => _buildShimmerItem(),
    );
  }

  Widget _buildShimmerItem() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
