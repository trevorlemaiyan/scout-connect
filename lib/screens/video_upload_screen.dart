import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/video_service.dart';
import '../utilities/themes.dart';

class VideoUploadScreen extends StatefulWidget {
  const VideoUploadScreen({Key? key}) : super(key: key);

  @override
  _VideoUploadScreenState createState() => _VideoUploadScreenState();
}

class _VideoUploadScreenState extends State<VideoUploadScreen> {
  final VideoService _videoService = VideoService();
  bool _isUploading = false;
  String? _uploadedVideoUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Video'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Instructions
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info, color: ScoutConnectTheme.primaryColor),
                        const SizedBox(width: 8),
                        Text(
                          'Upload Your Performance Video',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildInstructionItem(
                      '• Record your best performance highlights',
                    ),
                    _buildInstructionItem(
                      '• Keep videos under 5 minutes for best results',
                    ),
                    _buildInstructionItem(
                      '• Show your skills, technique, and athletic ability',
                    ),
                    _buildInstructionItem(
                      '• Ensure good lighting and clear audio',
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Upload Options
            Text(
              'Choose Upload Method',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _buildUploadOption(
                    icon: Icons.videocam,
                    label: 'Record Video',
                    description: 'Record new video',
                    onTap: _recordVideo,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildUploadOption(
                    icon: Icons.video_library,
                    label: 'Choose from Gallery',
                    description: 'Select existing video',
                    onTap: _pickVideoFromGallery,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Upload Status
            if (_isUploading) ...[
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Uploading video...'),
                            Text('Please wait, this may take a few minutes'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            
            if (_uploadedVideoUrl != null) ...[
              Card(
                color: ScoutConnectTheme.successColor.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: ScoutConnectTheme.successColor),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Video uploaded successfully!',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('Your video is now visible to scouts'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            
            const Spacer(),
            
            // Tips Section
            Card(
              color: Colors.grey.shade100,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pro Tips',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildTipItem('Show multiple skills and techniques'),
                    _buildTipItem('Include game footage if possible'),
                    _buildTipItem('Add voice commentary explaining your skills'),
                    _buildTipItem('Ensure steady camera work'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  Widget _buildTipItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.star, size: 16, color: ScoutConnectTheme.accentColor),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadOption({
    required IconData icon,
    required String label,
    required String description,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: _isUploading ? null : onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
          color: _isUploading ? Colors.grey.shade100 : null,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 48,
              color: _isUploading ? Colors.grey : ScoutConnectTheme.primaryColor,
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: _isUploading ? Colors.grey : null,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _recordVideo() async {
    try {
      setState(() {
        _isUploading = true;
        _uploadedVideoUrl = null;
      });

      final videoUrl = await _videoService.uploadVideo(source: ImageSource.camera);
      
      if (videoUrl != null) {
        setState(() {
          _uploadedVideoUrl = videoUrl;
        });
        
        _showSuccessDialog();
      } else {
        _showErrorDialog('Failed to upload video. Please try again.');
      }
    } catch (e) {
      _showErrorDialog('Error: $e');
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  Future<void> _pickVideoFromGallery() async {
    try {
      setState(() {
        _isUploading = true;
        _uploadedVideoUrl = null;
      });

      final videoUrl = await _videoService.uploadVideo(source: ImageSource.gallery);
      
      if (videoUrl != null) {
        setState(() {
          _uploadedVideoUrl = videoUrl;
        });
        
        _showSuccessDialog();
      } else {
        _showErrorDialog('Failed to upload video. Please try again.');
      }
    } catch (e) {
      _showErrorDialog('Error: $e');
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success!'),
        content: const Text('Your video has been uploaded successfully and is now visible to scouts.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Go back to previous screen
            },
            child: const Text('Done'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Reset for another upload
              setState(() {
                _uploadedVideoUrl = null;
              });
            },
            child: const Text('Upload Another'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Upload Failed'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
