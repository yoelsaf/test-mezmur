import 'package:flutter/material.dart';
import '../models/qumsnatat_model.dart';
import '../screen/church_screen.dart';

class ChurchCard extends StatelessWidget {
  final ContainerCard church;

  const ChurchCard({super.key, required this.church});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChurchScreen(cards: church),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(right: 16, bottom: 8, top: 8),
        width: 160,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20), // replaced withOpacity(0.08)
              offset: const Offset(0, 4),
              blurRadius: 12,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                child: Hero(
                  tag: church.imageUrl.toString(),
                  child: Image.asset(
                    church.imageUrl.toString(),
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                       color: Colors.grey[300],
                       child: const Icon(Icons.image_not_supported, color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                church.cardTitle.toString(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
