import 'package:flutter/material.dart';
import '../models/qumsnatat_model.dart';
import '../widgets/song_tile.dart';
import '../theme/app_theme.dart';

class MezmurSearchDelegate extends SearchDelegate {
  @override
  ThemeData appBarTheme(BuildContext context) {
    return AppTheme.lightTheme.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: AppTheme.scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: AppTheme.secondaryColor),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
        hintStyle: TextStyle(fontSize: 18),
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear, color: AppTheme.secondaryColor),
          onPressed: () {
            query = '';
          },
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back, color: AppTheme.secondaryColor),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    if (query.isEmpty) {
      return Container(
        color: AppTheme.scaffoldBackgroundColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search, size: 64, color: AppTheme.secondaryColor.withAlpha(51)), // replaced withOpacity(0.2)
              const SizedBox(height: 16),
              Text(
                'Search by title or lyrics',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.secondaryColor.withAlpha(128) // replaced withOpacity(0.5)
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Flatten logic
    final allSongs = <Mezlist>[];
    for (var card in qumsnatat) {
      for (var album in card.albums) {
        allSongs.addAll(album.mezlist);
      }
    }

    final lowerQuery = query.toLowerCase();
    final results = allSongs.where((song) {
      final title = song.mezname?.toLowerCase() ?? '';
      final lyrics = song.lyrics?.toLowerCase() ?? '';
      return title.contains(lowerQuery) || lyrics.contains(lowerQuery);
    }).toList();

    if (results.isEmpty) {
      return Container(
        color: AppTheme.scaffoldBackgroundColor,
        child: Center(
          child: Text(
            'No matches found',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      );
    }

    return Container(
      color: AppTheme.scaffoldBackgroundColor,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: results.length,
        itemBuilder: (context, index) {
          return SongTile(
            song: results[index],
            index: index, // Pass 0-based index
          );
        },
      ),
    );
  }
}
