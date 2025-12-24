import 'package:flutter/material.dart';
import '../models/qumsnatat_model.dart';
import 'church_card.dart';

class HorizontalSection extends StatelessWidget {
  final List<ContainerCard> items;

  const HorizontalSection({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: ListView.builder(
        padding: const EdgeInsets.only(left: 16),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ChurchCard(church: items[index]);
        },
      ),
    );
  }
}
