import 'package:flutter/material.dart';
import '../utilities/themes.dart';

class RecentEventsCard extends StatelessWidget {
  const RecentEventsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Upcoming Events',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                TextButton(
                  onPressed: () {
                    // TODO: Navigate to events
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _EventItem(
              title: 'Basketball Tryouts',
              date: 'Dec 15, 2024',
              location: 'Sports Complex',
              attendees: 24,
            ),
            const SizedBox(height: 8),
            _EventItem(
              title: 'Football Scouting Camp',
              date: 'Dec 18, 2024',
              location: 'Training Ground',
              attendees: 45,
            ),
            const SizedBox(height: 8),
            _EventItem(
              title: 'Athletics Meet',
              date: 'Dec 22, 2024',
              location: 'Stadium',
              attendees: 67,
            ),
          ],
        ),
      ),
    );
  }
}

class _EventItem extends StatelessWidget {
  final String title;
  final String date;
  final String location;
  final int attendees;

  const _EventItem({
    required this.title,
    required this.date,
    required this.location,
    required this.attendees,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: ScoutConnectTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.event,
              color: ScoutConnectTheme.primaryColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(date, style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(width: 12),
                    Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(location, style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: ScoutConnectTheme.successColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.people, size: 14, color: ScoutConnectTheme.successColor),
                const SizedBox(width: 4),
                Text(
                  '$attendees',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: ScoutConnectTheme.successColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
