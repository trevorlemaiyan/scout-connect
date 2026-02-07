import 'package:flutter/material.dart';
import '../utilities/themes.dart';

class StatsCard extends StatelessWidget {
  const StatsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Stats',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _StatItem(
                    icon: Icons.visibility,
                    value: '247',
                    label: 'Profile Views',
                    color: ScoutConnectTheme.primaryColor,
                  ),
                ),
                Expanded(
                  child: _StatItem(
                    icon: Icons.people,
                    value: '12',
                    label: 'Scout Connections',
                    color: ScoutConnectTheme.accentColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _StatItem(
                    icon: Icons.event,
                    value: '5',
                    label: 'Events Attended',
                    color: ScoutConnectTheme.successColor,
                  ),
                ),
                Expanded(
                  child: _StatItem(
                    icon: Icons.star,
                    value: '4.8',
                    label: 'Average Rating',
                    color: Colors.amber,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ScoutStatsCard extends StatelessWidget {
  const ScoutStatsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Scouting Stats',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _StatItem(
                    icon: Icons.person_search,
                    value: '48',
                    label: 'Athletes Discovered',
                    color: ScoutConnectTheme.primaryColor,
                  ),
                ),
                Expanded(
                  child: _StatItem(
                    icon: Icons.sports,
                    value: '6',
                    label: 'Sports Covered',
                    color: ScoutConnectTheme.accentColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _StatItem(
                    icon: Icons.event_available,
                    value: '12',
                    label: 'Events Organized',
                    color: ScoutConnectTheme.successColor,
                  ),
                ),
                Expanded(
                  child: _StatItem(
                    icon: Icons.trending_up,
                    value: '89%',
                    label: 'Success Rate',
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
