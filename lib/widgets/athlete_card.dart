import 'package:flutter/material.dart';
import '../models/athlete.dart';
import '../utilities/themes.dart';

class AthleteCard extends StatelessWidget {
  final Athlete athlete;
  final VoidCallback onTap;
  final bool showVideos;
  final bool showContactButton;

  const AthleteCard({
    Key? key,
    required this.athlete,
    required this.onTap,
    this.showVideos = true,
    this.showContactButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with profile info
              Row(
                children: [
                  // Profile Picture
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: ScoutConnectTheme.primaryColor,
                    backgroundImage: athlete.profilePictureUrl.isNotEmpty
                        ? NetworkImage(athlete.profilePictureUrl)
                        : null,
                    child: athlete.profilePictureUrl.isEmpty
                        ? const Icon(Icons.person, color: Colors.white, size: 32)
                        : null,
                  ),
                  const SizedBox(width: 16),
                  
                  // Basic Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          athlete.name,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: ScoutConnectTheme.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                athlete.sport,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: ScoutConnectTheme.primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                athlete.position,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(
                              athlete.location,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Icon(Icons.cake, size: 14, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(
                              '${athlete.age} years',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Bio
              if (athlete.bio.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bio',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      athlete.bio,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              
              // Skills
              if (athlete.skills.isNotEmpty) ...[
                Text(
                  'Skills',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: athlete.skills.take(4).map((skill) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: ScoutConnectTheme.accentColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        skill,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: ScoutConnectTheme.accentColor,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                if (athlete.skills.length > 4)
                  Text(
                    '+${athlete.skills.length - 4} more',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                const SizedBox(height: 12),
              ],
              
              // Stats Row
              Row(
                children: [
                  _StatItem(
                    icon: Icons.emoji_events,
                    label: 'Achievements',
                    value: athlete.achievements.length.toString(),
                    color: ScoutConnectTheme.accentColor,
                  ),
                  if (showVideos && athlete.videoUrls.isNotEmpty) ...[
                    const SizedBox(width: 16),
                    _StatItem(
                      icon: Icons.play_circle,
                      label: 'Videos',
                      value: athlete.videoUrls.length.toString(),
                      color: Colors.red,
                    ),
                  ],
                  const SizedBox(width: 16),
                  _StatItem(
                    icon: Icons.fitness_center,
                    label: 'Skills',
                    value: athlete.skills.length.toString(),
                    color: ScoutConnectTheme.successColor,
                  ),
                ],
              ),
              
              // Physical Stats (if available)
              if (athlete.height > 0 || athlete.weight > 0) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    if (athlete.height > 0)
                      Text(
                        '${athlete.height.toStringAsFixed(1)}cm',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    if (athlete.height > 0 && athlete.weight > 0)
                      Text(' • ', style: Theme.of(context).textTheme.bodySmall),
                    if (athlete.weight > 0)
                      Text(
                        '${athlete.weight.toStringAsFixed(1)}kg',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                  ],
                ),
              ],
              
              // Action Buttons
              if (showContactButton) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // TODO: View full profile
                          onTap();
                        },
                        icon: const Icon(Icons.person),
                        label: const Text('View Profile'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ScoutConnectTheme.primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // TODO: Contact athlete
                        },
                        icon: const Icon(Icons.message),
                        label: const Text('Contact'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: ScoutConnectTheme.primaryColor,
                          side: BorderSide(color: ScoutConnectTheme.primaryColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
