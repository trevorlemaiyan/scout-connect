import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utilities/themes.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();

  bool _isEditing = false;
  bool _isLoading = false;
  String _name = '';
  String _bio = '';
  String _about = '';
  String _sport = '';
  String _position = '';
  int _age = 0;
  String _location = '';
  String _experience = '';
  String _education = '';
  String _profilePictureUrl = '';

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();
  final TextEditingController _sportController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _educationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _aboutController.dispose();
    _sportController.dispose();
    _positionController.dispose();
    _ageController.dispose();
    _locationController.dispose();
    _experienceController.dispose();
    _educationController.dispose();
    super.dispose();
  }

  Future<void> _loadUserProfile() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    final userDoc = await _firestore.collection('users').doc(currentUser.uid).get();
    if (!userDoc.exists) return;

    final userData = userDoc.data() as Map<String, dynamic>;

    setState(() {
      _name = userData['name'] ?? '';
      _bio = userData['bio'] ?? '';
      _about = userData['about'] ?? '';
      _sport = userData['sport'] ?? '';
      _position = userData['position'] ?? '';
      _age = userData['age'] ?? 0;
      _location = userData['location'] ?? '';
      _experience = userData['experience'] ?? '';
      _education = userData['education'] ?? '';
      _profilePictureUrl = userData['profilePictureUrl'] ?? '';

      _nameController.text = _name;
      _bioController.text = _bio;
      _aboutController.text = _about;
      _sportController.text = _sport;
      _positionController.text = _position;
      _ageController.text = _age.toString();
      _locationController.text = _location;
      _experienceController.text = _experience;
      _educationController.text = _education;
    });
  }

  Future<void> _pickProfilePicture() async {
    try {
      final image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;

      setState(() {
        _isLoading = true;
      });

      // TODO: Upload to Firebase Storage
      // For now, just update the local state
      setState(() {
        _profilePictureUrl = image.path;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return;

      final updateData = {
        'name': _nameController.text,
        'bio': _bioController.text,
        'about': _aboutController.text,
        'sport': _sportController.text,
        'position': _positionController.text,
        'age': int.tryParse(_ageController.text) ?? 0,
        'location': _locationController.text,
        'experience': _experienceController.text,
        'education': _educationController.text,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      };

      await _firestore.collection('users').doc(currentUser.uid).update(updateData);

      setState(() {
        _isEditing = false;
        _isLoading = false;
        _name = _nameController.text;
        _bio = _bioController.text;
        _about = _aboutController.text;
        _sport = _sportController.text;
        _position = _positionController.text;
        _age = int.tryParse(_ageController.text) ?? 0;
        _location = _locationController.text;
        _experience = _experienceController.text;
        _education = _educationController.text;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $e')),
      );
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return const Scaffold(body: Center(child: Text('Please login')));

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Profile' : 'Profile'),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
            ),
          if (_isEditing)
            TextButton(
              onPressed: _isLoading ? null : _saveProfile,
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Save'),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Picture
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: ScoutConnectTheme.primaryColor,
                            backgroundImage: _profilePictureUrl.isNotEmpty
                                ? NetworkImage(_profilePictureUrl)
                                : null,
                            child: _profilePictureUrl.isEmpty
                                ? const Icon(Icons.person, color: Colors.white, size: 60)
                                : null,
                          ),
                          if (_isEditing)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: _pickProfilePicture,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    color: Colors.blue,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Basic Info
                    _buildSectionTitle('Basic Information'),
                    _buildTextField(
                      controller: _nameController,
                      label: 'Full Name',
                      enabled: _isEditing,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    _buildTextField(
                      controller: _bioController,
                      label: 'Bio',
                      enabled: _isEditing,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),

                    // About Section
                    _buildSectionTitle('About'),
                    _buildTextField(
                      controller: _aboutController,
                      label: 'Tell us about yourself',
                      enabled: _isEditing,
                      maxLines: 4,
                      hintText: 'Share your story, goals, and what makes you unique...',
                    ),
                    const SizedBox(height: 16),

                    // Professional Info
                    _buildSectionTitle('Professional Information'),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _sportController,
                            label: 'Sport',
                            enabled: _isEditing,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                            controller: _positionController,
                            label: 'Position',
                            enabled: _isEditing,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _ageController,
                            label: 'Age',
                            enabled: _isEditing,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                            controller: _locationController,
                            label: 'Location',
                            enabled: _isEditing,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Background
                    _buildSectionTitle('Background'),
                    _buildTextField(
                      controller: _experienceController,
                      label: 'Experience',
                      enabled: _isEditing,
                      hintText: 'e.g., 5 years of competitive experience',
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _educationController,
                      label: 'Education',
                      enabled: _isEditing,
                      hintText: 'e.g., Bachelor\'s in Sports Management',
                    ),
                    const SizedBox(height: 32),

                    // Stats Display
                    if (!_isEditing) _buildStatsSection(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: ScoutConnectTheme.primaryColor,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool enabled = true,
    int? maxLines,
    String? hintText,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          border: const OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ScoutConnectTheme.primaryColor),
          ),
        ),
        validator: validator,
        keyboardType: keyboardType,
      ),
    );
  }

  Widget _buildStatsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profile Stats',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildStatItem('Profile Views', '247'),
            _buildStatItem('Connections', '12'),
            _buildStatItem('Videos Uploaded', '5'),
            _buildStatItem('Scout Status', _isScouted() ? 'Scouted' : 'Not Scouted'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: ScoutConnectTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  bool _isScouted() {
    // This would come from user data
    return false; // Placeholder
  }
}
