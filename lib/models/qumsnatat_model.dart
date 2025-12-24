import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class ContainerCard {
  String? imageUrl;
  String? cardTitle;
  String? category;
  List<Album> albums;

  ContainerCard({this.imageUrl, this.cardTitle, required this.albums});
}

class Album {
  String? imagUrl;
  String? qumsname;
  int? released;
  int? volum;
  List<Mezlist> mezlist;

  Album({this.imagUrl, this.qumsname, this.released, this.volum, required this.mezlist});
}

class Mezlist {
  String? mezname;
  String? lyrics;
  int? id;
  
  Mezlist({this.mezname, this.lyrics, this.id});

  factory Mezlist.fromJson(Map<String, dynamic> json) {
    return Mezlist(
      mezname: json['title'],
      lyrics: json['lyrics'],
      id: json['id'],
    );
  }
}

// Global list
List<ContainerCard> qumsnatat = [];

// Helper to map category names to specific images if desired
String _getImageForCategory(String category) {
  if (category.contains("ዓዲ ቀይሕ")) return "assets/cathedral.jpg";
  if (category.contains("ሰምበል")) return "assets/sito.jpg";
  if (category.contains("ሳንታ")) return "assets/santa asmara.jpg";
  if (category.contains("ኪዳነ ምሕረት")) return "assets/kidun.jpg";
  if (category.contains("ካቴድራል")) return "assets/cathedral.jpg";
  // Default
  return "assets/icon.jpg";
}

Future<void> loadMezmurData() async {
  try {
    // Load the massive flat JSON file
    final String response = await rootBundle.loadString('assets/lyrics.json');
    final List<dynamic> flatData = json.decode(response);
    
    // Group by Category
    // Map<CategoryName, List<Mezlist>>
    final Map<String, List<Mezlist>> groupedSongs = {};

    for (var item in flatData) {
      final song = Mezlist.fromJson(item);
      final category = item['category'] ?? 'Uncategorized';
      
      if (!groupedSongs.containsKey(category)) {
        groupedSongs[category] = [];
      }
      groupedSongs[category]!.add(song);
    }

    // Convert Groups to ContainerCards
    qumsnatat = groupedSongs.entries.map((entry) {
      final categoryName = entry.key;
      final songs = entry.value;

      // Create a virtual "Album" to hold these songs helps maintain the UI structure
      // We can split them into volumes if the list is too long, but for now 1 Album per Category.
      final album = Album(
        imagUrl: _getImageForCategory(categoryName),
        qumsname: "All Songs",
        released: 2024,
        volum: 1,
        mezlist: songs,
      );

      return ContainerCard(
        imageUrl: _getImageForCategory(categoryName),
        cardTitle: categoryName,
        albums: [album],
      );
    }).toList();

    debugPrint("Loaded ${qumsnatat.length} categories from lyrics.json");

  } catch (e) {
    debugPrint("Error loading mezmur data: $e");
    qumsnatat = [];
  }
}