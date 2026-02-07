import 'package:flutter/material.dart';
import '../models/athlete.dart';
import '../models/search_filter.dart';
import '../models/sport_category.dart';
import '../services/discovery_service.dart';
import '../widgets/athlete_card.dart';

class AthleteDiscoveryScreen extends StatefulWidget {
  const AthleteDiscoveryScreen({Key? key}) : super(key: key);

  @override
  State<AthleteDiscoveryScreen> createState() => _AthleteDiscoveryScreenState();
}

class _AthleteDiscoveryScreenState extends State<AthleteDiscoveryScreen> {
  final DiscoveryService _discoveryService = DiscoveryService();
  final TextEditingController _searchController = TextEditingController();
  
  AthleteSearchFilter _filter = AthleteSearchFilter();
  List<Athlete> _athletes = [];
  bool _isLoading = false;
  bool _showFilters = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover Athletes'),
        actions: [
          IconButton(
            icon: Icon(_showFilters ? Icons.filter_list_off : Icons.filter_list),
            onPressed: () {
              setState(() {
                _showFilters = !_showFilters;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search athletes by name, sport, position...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _performSearch('');
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: _performSearch,
            ),
          ),

          // Filter Section
          if (_showFilters) _buildFilterSection(),

          // Results Section
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _athletes.isEmpty
                    ? _buildEmptyState()
                    : _buildAthletesList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filters',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              TextButton(
                onPressed: _clearFilters,
                child: const Text('Clear All'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Sport Filter
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Sport',
              border: OutlineInputBorder(),
            ),
            value: _filter.sport,
            items: SportCategory.getActiveSports()
                .map((sport) => DropdownMenuItem(
                      value: sport.id,
                      child: Row(
                        children: [
                          Text(sport.icon),
                          const SizedBox(width: 8),
                          Text(sport.name),
                        ],
                      ),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                _filter = _filter.copyWith(sport: value, position: null);
              });
              _applyFilters();
            },
          ),
          const SizedBox(height: 12),

          // Position Filter
          if (_filter.sport != null)
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Position',
                border: OutlineInputBorder(),
              ),
              value: _filter.position,
              items: SportCategory.getSportById(_filter.sport!)?.positions
                      .map((position) => DropdownMenuItem(
                            value: position,
                            child: Text(position),
                          ))
                      .toList() ??
                  [],
              onChanged: (value) {
                setState(() {
                  _filter = _filter.copyWith(position: value);
                });
                _applyFilters();
              },
            ),
          const SizedBox(height: 12),

          // Age Range
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Min Age',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  initialValue: _filter.minAge?.toString(),
                  onChanged: (value) {
                    final age = int.tryParse(value);
                    setState(() {
                      _filter = _filter.copyWith(minAge: age);
                    });
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Max Age',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  initialValue: _filter.maxAge?.toString(),
                  onChanged: (value) {
                    final age = int.tryParse(value);
                    setState(() {
                      _filter = _filter.copyWith(maxAge: age);
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Location Filter
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Location',
              border: OutlineInputBorder(),
            ),
            initialValue: _filter.location,
            onChanged: (value) {
              setState(() {
                _filter = _filter.copyWith(location: value);
              });
            },
          ),
          const SizedBox(height: 12),

          // Additional Filters
          Row(
            children: [
              Expanded(
                child: CheckboxListTile(
                  title: const Text('Has Videos'),
                  value: _filter.hasVideos,
                  onChanged: (value) {
                    setState(() {
                      _filter = _filter.copyWith(hasVideos: value);
                    });
                    _applyFilters();
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),
              Expanded(
                child: CheckboxListTile(
                  title: const Text('Has Achievements'),
                  value: _filter.hasAchievements,
                  onChanged: (value) {
                    setState(() {
                      _filter = _filter.copyWith(hasAchievements: value);
                    });
                    _applyFilters();
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No athletes found',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAthletesList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _athletes.length,
      itemBuilder: (context, index) {
        final athlete = _athletes[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: AthleteCard(
            athlete: athlete,
            onTap: () {
              // TODO: Navigate to athlete profile
            },
          ),
        );
      },
    );
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      _applyFilters();
    } else {
      setState(() {
        _isLoading = true;
      });
      
      _discoveryService.searchAthletesByQuery(query).then((results) {
        setState(() {
          _athletes = results;
          _isLoading = false;
        });
      });
    }
  }

  void _applyFilters() {
    setState(() {
      _isLoading = true;
    });

    _discoveryService.searchAthletes(_filter).listen((results) {
      setState(() {
        _athletes = results;
        _isLoading = false;
      });
    });
  }

  void _clearFilters() {
    setState(() {
      _filter = _filter.clear();
      _searchController.clear();
    });
    _applyFilters();
  }
}
