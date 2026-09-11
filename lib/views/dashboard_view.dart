import 'package:flutter/material.dart';

import '../controllers/dashboard_controller.dart';
import '../models/dashboard_section.dart';
import 'assistant_view.dart';
import 'carnet/carnet_view.dart';
import 'diagnostic_view.dart';
import 'meteo_view.dart';
import 'ndvi_view.dart';
import 'parcelles/parcelles_view.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({required this.controller, super.key});

  final DashboardController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) => Scaffold(
        body: controller.selectedIndex == 0
            ? SafeArea(
                child: CustomScrollView(
                  slivers: [
                    const SliverPadding(
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                      sliver: SliverToBoxAdapter(child: _Header()),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
                      sliver: SliverToBoxAdapter(
                        child: Text(
                          'Bonjour, agriculteur',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF18351D),
                              ),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 6, 20, 0),
                      sliver: SliverToBoxAdapter(
                        child: Text(
                          'Suivez vos cultures et prenez de meilleures décisions.',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(color: const Color(0xFF637064)),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(20, 22, 20, 0),
                      sliver: SliverToBoxAdapter(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(24),
                          onTap: () => controller.selectSection(4),
                          child: const _WeatherCard(),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                      sliver: SliverToBoxAdapter(
                        child: Text(
                          'Votre exploitation',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF18351D),
                              ),
                        ),
                      ),
                    ),
                    const SliverPadding(
                      padding: EdgeInsets.fromLTRB(20, 12, 20, 0),
                      sliver: SliverToBoxAdapter(
                        child: Row(
                          children: [
                            Expanded(
                              child: _SummaryCard(
                                value: '3',
                                label: 'Parcelles',
                                icon: Icons.landscape_outlined,
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: _SummaryCard(
                                value: '12',
                                label: 'Activités',
                                icon: Icons.event_note_outlined,
                                accent: Color(0xFFB66A2C),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SliverPadding(
                      padding: EdgeInsets.fromLTRB(20, 24, 20, 110),
                      sliver: SliverToBoxAdapter(child: _RecentActivity()),
                    ),
                  ],
                ),
              )
            : _buildSection(context),
        floatingActionButton: controller.selectedIndex == 0
            ? FloatingActionButton.extended(
                onPressed: () => controller.selectSection(2),
                icon: const Icon(Icons.add),
                label: const Text('Ajouter une activité'),
              )
            : null,
        bottomNavigationBar: NavigationBar(
          selectedIndex: controller.selectedIndex,
          onDestinationSelected: controller.selectSection,
          destinations: dashboardSections
              .map(
                (section) => NavigationDestination(
                  icon: Icon(section.icon),
                  label: section.label,
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context) {
    return switch (controller.selectedIndex) {
      1 => const ParcellesView(),
      2 => const CarnetView(),
      3 => const DiagnosticView(),
      4 => const MeteoView(),
      5 => const NdviView(),
      6 => const AssistantView(),
      _ => const SizedBox.shrink(),
    };
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.eco, color: Colors.white, size: 26),
        ),
        const SizedBox(width: 12),
        Text(
          'AGRIVISION',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
            color: const Color(0xFF18351D),
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: () {},
          tooltip: 'Notifications',
          icon: const Icon(Icons.notifications_none),
        ),
        const CircleAvatar(
          radius: 20,
          backgroundColor: Color(0xFFDCE8D6),
          child: Icon(Icons.person_outline, color: Color(0xFF1B5E20)),
        ),
      ],
    );
  }
}

class _WeatherCard extends StatelessWidget {
  const _WeatherCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFDAE9D2),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.wb_sunny_outlined,
            size: 44,
            color: Color(0xFFB66A2C),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Kinshasa, RDC', style: theme.textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(
                  '28°C  •  Partiellement nuageux',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF355437),
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Color(0xFF355437)),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.value,
    required this.label,
    required this.icon,
    this.accent = const Color(0xFF1B5E20),
  });

  final String value;
  final String label;
  final IconData icon;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE4E8E0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: accent),
          const SizedBox(height: 14),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: const Color(0xFF637064)),
          ),
        ],
      ),
    );
  }
}

class _RecentActivity extends StatelessWidget {
  const _RecentActivity();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Activité récente',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            TextButton(onPressed: () {}, child: const Text('Voir tout')),
          ],
        ),
        const SizedBox(height: 8),
        const _ActivityTile(
          icon: Icons.water_drop_outlined,
          title: 'Irrigation',
          subtitle: 'Parcelle Maïs Nord  •  Aujourd’hui',
        ),
        const _ActivityTile(
          icon: Icons.visibility_outlined,
          title: 'Observation ajoutée',
          subtitle: 'Parcelle Haricot Est  •  Hier',
          accent: Color(0xFFB66A2C),
        ),
      ],
    );
  }
}

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.accent = const Color(0xFF1B5E20),
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: accent.withValues(alpha: 0.12),
        child: Icon(icon, color: accent),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right, size: 20),
    );
  }
}
