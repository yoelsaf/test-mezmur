import 'package:flutter/material.dart';
import '../models/qumsnatat_model.dart';
import '../screen/lyrics_screen.dart';

class SongTile extends StatelessWidget {
  final Mezlist song;
  final int index;

  const SongTile({super.key, required this.song, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8), // replaced withOpacity(0.03)
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor.withAlpha(25), // replaced withOpacity(0.1)
          child: Text(
            '${index + 1}',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          song.mezname ?? 'Unknown Song',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        trailing: Icon(Icons.lyrics_outlined, color: Theme.of(context).primaryColor),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => LyricsScreen(song: song),
            ),
          );
        },
      ),
    );
  }
}
