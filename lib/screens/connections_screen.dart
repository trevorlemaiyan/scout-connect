import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/connection.dart';
import '../services/connection_service.dart';
import '../utilities/themes.dart';

class ConnectionsScreen extends StatefulWidget {
  const ConnectionsScreen({Key? key}) : super(key: key);

  @override
  State<ConnectionsScreen> createState() => _ConnectionsScreenState();
}

class _ConnectionsScreenState extends State<ConnectionsScreen> with TickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ConnectionService _connectionService = ConnectionService();

  @override
  Widget build(BuildContext context) {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return const Scaffold(body: Center(child: Text('Please login')));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Connections'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Requests'),
            Tab(text: 'My Connections'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildRequestsTab(),
          _buildConnectionsTab(),
        ],
      ),
    );
  }

  TabController get _tabController {
    return TabController(length: 2, vsync: this);
  }

  Widget _buildRequestsTab() {
    return StreamBuilder<List<Connection>>(
      stream: _connectionService.getConnectionRequests(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final requests = snapshot.data ?? [];
        
        if (requests.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  'No connection requests',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'When someone sends you a connection request, it will appear here',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final request = requests[index];
            return _buildConnectionRequestCard(request);
          },
        );
      },
    );
  }

  Widget _buildConnectionsTab() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _getConnections(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final connections = snapshot.data ?? [];
        
        if (connections.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people_outline, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  'No connections yet',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Connect with athletes and scouts to build your network',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: connections.length,
          itemBuilder: (context, index) {
            final connection = connections[index];
            return _buildConnectionCard(connection);
          },
        );
      },
    );
  }

  Widget _buildConnectionRequestCard(Connection connection) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: ScoutConnectTheme.primaryColor,
                  child: const Icon(Icons.person, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Connection Request',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: ScoutConnectTheme.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'From: ${connection.requesterId}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                Text(
                  _formatDate(connection.createdAt),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final success = await _connectionService.acceptConnectionRequest(connection.id);
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Connection accepted!')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ScoutConnectTheme.successColor,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Accept'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      final success = await _connectionService.declineConnectionRequest(connection.id);
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Connection declined')),
                        );
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey.shade600,
                      side: BorderSide(color: Colors.grey.shade600),
                    ),
                    child: const Text('Decline'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectionCard(Map<String, dynamic> connection) {
    final userData = connection['userData'] as Map<String, dynamic>?;
    final userName = userData?['name'] ?? 'Unknown User';
    final userPicture = userData?['profilePictureUrl'] ?? '';
    final userType = userData?['accountType'] ?? 'Unknown';

    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: ScoutConnectTheme.primaryColor,
          backgroundImage: userPicture.isNotEmpty
              ? NetworkImage(userPicture)
              : null,
          child: userPicture.isEmpty
              ? const Icon(Icons.person, color: Colors.white, size: 24)
              : null,
        ),
        title: Text(
          userName,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              userType,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: ScoutConnectTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Connected since ${connection['connectedDate'] ?? 'Recently'}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.message),
          onPressed: () {
            // TODO: Navigate to messaging screen
          },
        ),
        onTap: () {
          // TODO: Navigate to user profile
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  Future<List<Map<String, dynamic>>> _getConnections() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return [];

    // This would get user's connections from Firestore
    // For now, return empty list as placeholder
    return [];
  }
}
