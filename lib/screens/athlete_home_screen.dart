import 'package:flutter/material.dart';
import '../widgets/stats_card.dart';
import '../widgets/quick_actions_card.dart';
import '../widgets/recent_events_card.dart';
import '../widgets/athlete_profile_card.dart';
import '../screens/profile_screen.dart';

class AthleteHomeScreen extends StatefulWidget {
  const AthleteHomeScreen({Key? key}) : super(key: key);

  @override
  State<AthleteHomeScreen> createState() => _AthleteHomeScreenState();
}

class _AthleteHomeScreenState extends State<AthleteHomeScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  
  final List<Widget> _pages = [
    const AthleteFeedPage(),
    AthleteProfilePage(),
    AthleteEventsPage(),
    AthleteMessagesPage(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_outlined),
            activeIcon: Icon(Icons.event),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message_outlined),
            activeIcon: Icon(Icons.message),
            label: 'Messages',
          ),
        ],
      ),
    );
  }
}

class AthleteFeedPage extends StatelessWidget {
  const AthleteFeedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scout Connect'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Implement notifications
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back!',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your profile is getting noticed by scouts',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Quick Stats
            const StatsCard(),
            const SizedBox(height: 16),

            // Quick Actions
            const QuickActionsCard(),
            const SizedBox(height: 16),

            // Recent Events
            const RecentEventsCard(),
            const SizedBox(height: 16),

            // Profile Preview
            const AthleteProfileCard(),
          ],
        ),
      ),
    );
  }
}

class AthleteProfilePage extends StatelessWidget {
  const AthleteProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ProfileScreen();
  }
}

class AthleteEventsPage extends StatelessWidget {
  const AthleteEventsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
      ),
      body: const Center(
        child: Text('Events - Coming Soon'),
      ),
    );
  }
}

class AthleteMessagesPage extends StatelessWidget {
  const AthleteMessagesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
      ),
      body: const Center(
        child: Text('Messages - Coming Soon'),
      ),
    );
  }
}
