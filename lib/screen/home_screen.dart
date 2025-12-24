import 'package:flutter/material.dart';
import '../models/balat_model.dart';
import '../models/qumsnatat_model.dart';
import '../widgets/horizontal_section.dart';
import '../widgets/section_header.dart';
import '../theme/app_theme.dart';

import 'search_delegate.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: true,
            expandedHeight: 120.0,
            backgroundColor: AppTheme.scaffoldBackgroundColor,
            actions: [
              IconButton(
                icon: const Icon(Icons.search, color: AppTheme.secondaryColor, size: 28),
                onPressed: () {
                  showSearch(context: context, delegate: MezmurSearchDelegate());
                },
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
              title: Text(
                'ካቶሊካዊ መዛሙር',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: 24,
                  color: AppTheme.secondaryColor,
                ),
              ),
              background: Container(
                alignment: Alignment.topRight,
                padding: const EdgeInsets.only(top: 40, right: 20),
                child: Opacity(
                  opacity: 0.1,
                  child: Image.asset(
                    'assets/icon.jpg',
                    width: 100,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 20),
                SectionHeader(title: 'ናይ ማሕበራት መዝሙር', onSeeAll: () {}),
                HorizontalSection(items: qumsnatat),
                SectionHeader(title: 'ናይ በዓላት መዛሙር', onSeeAll: () {}),
                HorizontalSection(items: balatCards),
                SectionHeader(title: 'ናይ ዝተፈላለዩ መዝሙር', onSeeAll: () {}),
                HorizontalSection(items: qumsnatat),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
