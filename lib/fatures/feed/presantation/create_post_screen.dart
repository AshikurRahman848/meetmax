import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final controller = TextEditingController();
  final _picker = ImagePicker();
  XFile? _picked;

  Future<void> _pickFromGallery() async {
    final x = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (x != null) setState(() => _picked = x);
  }

  @override
  Widget build(BuildContext context) {
    const lightBg = Color(0xFFF5F7FA);
    const cardBg = Color(0xFFF6F8FB);
    const primaryBlue = Color(0xFF2E6BFF);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Create a post', style: TextStyle(color: Colors.black)),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Row(
              children: const [
                Text('Visible for', style: TextStyle(color: Colors.black54)),
                SizedBox(width: 8),
                _VisibilityPill(),
              ],
            ),
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          // Composer card
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=1'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text box
                      TextField(
                        controller: controller,
                        minLines: 4,
                        maxLines: 10,
                        style: const TextStyle(fontSize: 16, height: 1.35),
                        decoration: const InputDecoration(
                          hintText: "What's on your mind?",
                          isCollapsed: true,
                          border: InputBorder.none,
                        ),
                      ),
                      // Attached image
                      if (_picked != null) ...[
                        const SizedBox(height: 14),
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: AspectRatio(
                                aspectRatio: 16 / 9,
                                child: Image.file(
                                  File(_picked!.path),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 10,
                              right: 10,
                              child: InkWell(
                                onTap: () => setState(() => _picked = null),
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.9),
                                    shape: BoxShape.circle,
                                    boxShadow: const [
                                      BoxShadow(
                                        blurRadius: 6,
                                        color: Color(0x1A000000),
                                      )
                                    ],
                                  ),
                                  child: const Icon(Icons.close, size: 18),
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
            ],
          ),

          const SizedBox(height: 24),

          // Actions
          _ActionRow(
            icon: Icons.videocam_outlined,
            label: 'Live Video',
            onTap: () {},
          ),
          _ActionRow(
            icon: Icons.photo_outlined,
            label: 'Photo/Video',
            onTap: _pickFromGallery,
          ),
          _ActionRow(
            icon: Icons.sentiment_satisfied_outlined,
            label: 'Feeling',
            onTap: () {},
          ),

          const SizedBox(height: 24),

          // Post button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                final text = controller.text.trim();
                Navigator.pop(context, {
                  'text': text,
                  'imagePath': _picked?.path, // may be null
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Post',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Small “Friends ▾” pill on the right side of the AppBar
class _VisibilityPill extends StatelessWidget {
  const _VisibilityPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF3FF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: const [
          Text('Friends', style: TextStyle(color: Color(0xFF2E6BFF), fontWeight: FontWeight.w600)),
          SizedBox(width: 4),
          Icon(Icons.keyboard_arrow_down, color: Color(0xFF2E6BFF)),
        ],
      ),
    );
  }
}

/// One-line action (icon + label) with clean alignment
class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Icon(icon, size: 22, color: Colors.black87),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}
