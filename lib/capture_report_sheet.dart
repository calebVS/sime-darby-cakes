import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'cloudinary_service.dart';
import 'gemini_service.dart';

class CaptureReportSheet extends StatefulWidget {
  const CaptureReportSheet({Key? key}) : super(key: key);

  @override
  State<CaptureReportSheet> createState() => _CaptureReportSheetState();
}

class _CaptureReportSheetState extends State<CaptureReportSheet> {
  final TextEditingController _descriptionController = TextEditingController(
    text: 'Deep pothole by the curb on 48th. Cyclists have to swerve out to avoid it.',
  );
  final CloudinaryService _cloudinaryService = CloudinaryService();

  File? _selectedImage;
  bool _isUploading = false;
  bool _isAnalyzing = false; 
  String _selectedCategory = 'Roads';

  final List<Map<String, dynamic>> _categories = [
    {'label': 'Roads', 'icon': Icons.construction},
    {'label': 'Lighting', 'icon': Icons.lightbulb_outline},
    {'label': 'Waste', 'icon': Icons.delete_outline},
  ];

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source, imageQuality: 80);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _isAnalyzing = true; // Show loading spinner over image preview
      });

      print('🚀 Sending image to Gemini AI...');

      // 1. Get detected string ("Roads", "Lighting", or "Waste")
      String detectedCategory = await GeminiService.detectIssue(_selectedImage!);

      print('✅ Gemini Category Selected: $detectedCategory');

      // 2. Trigger auto-select in UI
      if (mounted) {
        setState(() {
          _selectedCategory = detectedCategory; 
          _isAnalyzing = false; // Hide loading spinner overlay
        });
      }
    }
  }

  void _showImageSourcePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xFF2563EB)),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Color(0xFF2563EB)),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitReport() async {
    if (_descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please describe what is happening.')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      String? imageUrl;
      if (_selectedImage != null) {
        imageUrl = await CloudinaryService.uploadImage(_selectedImage!);
      }

      await FirebaseFirestore.instance.collection('reports').add({
        'title': _descriptionController.text.trim(),
        'category': _selectedCategory,
        'imageUrl': imageUrl ?? '',
        'location': '48th St & Telegraph Ave',
        'subLocation': 'Temescal · Current location',
        'status': 'Reported',
        'upvotes': 0,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Report posted successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to post report: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFBF9F5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'New report',
          style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.black, size: 22),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Header
            const Text(
              'Make it visible.',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: Colors.black,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'A photo, a place, a little context. That\'s it.',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // Main Media Preview Card
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(20),
                image: _selectedImage != null
                    ? DecorationImage(
                        image: FileImage(_selectedImage!),
                        fit: BoxFit.cover,
                      )
                    : const DecorationImage(
                        image: NetworkImage('https://images.unsplash.com/photo-1515162816999-a0c47dc192f7?q=80&w=600'),
                        fit: BoxFit.cover,
                      ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    // Top overlay options
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.camera_alt, size: 14, color: Colors.black),
                            SizedBox(width: 4),
                            Text('Photo', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            SizedBox(width: 8),
                            Icon(Icons.videocam_outlined, size: 14, color: Colors.grey),
                            SizedBox(width: 4),
                            Text('Video', style: TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedImage = null;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close, size: 14, color: Colors.white),
                        ),
                      ),
                    ),

                    // AI Analyzing Loading Overlay
                    if (_isAnalyzing)
                      Container(
                        color: Colors.black.withOpacity(0.5),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              CircularProgressIndicator(color: Colors.white),
                              SizedBox(height: 10),
                              Text(
                                'Detecting issue with Gemini...',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    // Bottom Overlay Controls
                    Positioned(
                      bottom: 12,
                      left: 12,
                      right: 12,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.65),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _selectedImage != null ? '1 photo added' : '0 photos added',
                              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: _showImageSourcePicker,
                            icon: const Icon(Icons.add, size: 16, color: Color(0xFF2563EB)),
                            label: const Text(
                              'Add photo or video',
                              style: TextStyle(color: Color(0xFF2563EB), fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Issue Type Selection
            const Text(
              'What kind of issue?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                ..._categories.map((cat) {
                  final isSelected = _selectedCategory == cat['label'];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      avatar: Icon(
                        cat['icon'],
                        size: 16,
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                      label: Text(cat['label']),
                      selected: isSelected,
                      selectedColor: const Color(0xFF2563EB),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: isSelected ? Colors.transparent : Colors.grey.shade300),
                      ),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedCategory = cat['label'];
                          });
                        }
                      },
                    ),
                  );
                }).toList(),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const Icon(Icons.more_horiz, size: 16, color: Colors.black87),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Description Box
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'What\'s happening?',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                Text(
                  '${_descriptionController.text.length} / 300',
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              maxLength: 300,
              onChanged: (val) => setState(() {}),
              decoration: InputDecoration(
                counterText: '',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Location Box
            const Text(
              'Where is it?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on_outlined, color: Color(0xFF2563EB), size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          '48th St & Telegraph Ave',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Temescal · Current location',
                          style: TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Edit', style: TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Similar Reports Callout
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.layers_outlined, color: Color(0xFF2563EB), size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          '2 similar reports nearby',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2563EB), fontSize: 12),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Support an existing one, or share a new angle.',
                          style: TextStyle(fontSize: 11, color: Color(0xFF3B82F6)),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Color(0xFF2563EB)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Footer Note
            const Text(
              'Posted publicly to Blockup, not sent to the city. Avoid faces, plates and personal details.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _isUploading ? null : _submitReport,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: _isUploading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.north_east, color: Colors.white, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Post neighborhood report',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}