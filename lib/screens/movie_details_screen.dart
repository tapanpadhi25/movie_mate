import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_mate/utils/global_auth.dart';

import '../model/movie_model.dart';
import '../provider/theme_provider.dart';
import '../utils/theme_utils.dart';

class MovieDetailsScreen extends ConsumerWidget {
  final MovieResult result;

  const MovieDetailsScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLightMode = ref.watch(themeProvider);
    final themeData = CustomTheme.getTheme(isLightMode);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.keyboard_arrow_left, color: Colors.white),
        ),
        backgroundColor: themeData!.primaryColor,
        centerTitle: true,
        title: Text(
          result.title,
          style: themeData.textTheme.titleLarge!.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SizedBox(
            height: 200,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: "$imageBase${result.backdropPath}",
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(
                  Icons.broken_image,
                  color: Colors.grey,
                  size: 50,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(result.overview, style: themeData.textTheme.titleSmall),
          const SizedBox(height: 8),
          Text(
            "Language:- ${result.originalLanguage}",
            style: themeData.textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          Text(
            "Popularity:- ${result.popularity}",
            style: themeData.textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          Text(
            "Vote Average:- ${result.voteAverage}",
            style: themeData.textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          Text(
            "Vote Count:- ${result.voteCount}",
            style: themeData.textTheme.titleSmall,
          ),
        ],
      ),
    );
  }
}
