import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedAndEventsScreen extends StatefulWidget {
  const FeedAndEventsScreen({Key? key}) : super(key: key);

  @override
  State<FeedAndEventsScreen> createState() => _FeedAndEventsScreenState();
}

class _FeedAndEventsScreenState extends State<FeedAndEventsScreen> {
  // 0: Feed, 1: Event
  int _selectedHeaderTab = 0;

  // Track liked state & support counts per post ID
  final Map<String, bool> _likedPosts = {};
  final Map<String, int> _supportCounts = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: _selectedHeaderTab == 0,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            // Feed Tab
            GestureDetector(
              onTap: () {
                setState(() {
                  _selectedHeaderTab = 0;
                });
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Feed',
                    style: TextStyle(
                      color: _selectedHeaderTab == 0 ? Colors.black : Colors.grey.shade600,
                      fontWeight: _selectedHeaderTab == 0 ? FontWeight.bold : FontWeight.normal,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    height: 3,
                    width: 28,
                    color: _selectedHeaderTab == 0 ? const Color(0xFF2962FF) : Colors.transparent,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            // Event Tab
            GestureDetector(
              onTap: () {
                setState(() {
                  _selectedHeaderTab = 1;
                });
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Event',
                    style: TextStyle(
                      color: _selectedHeaderTab == 1 ? Colors.black : Colors.grey.shade600,
                      fontWeight: _selectedHeaderTab == 1 ? FontWeight.bold : FontWeight.normal,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    height: 3,
                    width: 32,
                    color: _selectedHeaderTab == 1 ? const Color(0xFF2962FF) : Colors.transparent,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedHeaderTab,
        children: [
          _buildFeedView(),
          _buildEventView(),
        ],
      ),
    );
  }

  // --- 1. LIVE SCROLLABLE FEED VIEW ---
  Widget _buildFeedView() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return PageView(
            scrollDirection: Axis.vertical,
            children: [
              _buildSingleFeedItem(
                postId: 'default_mock',
                authorName: 'Ashton Au.',
                timeAgo: '2 days ago',
                title: 'This dip needs\na fix.',
                description: '48th St, near Telegraph. Bikes have to swerve into traffic to miss it.',
                category: 'Pothole',
                imageUrl: 'https://images.unsplash.com/photo-1515162816999-a0c47dc192f7?auto=format&fit=crop&q=80&w=800',
                commentsCount: '18',
                initialLikes: 128,
              ),
            ],
          );
        }

        final posts = snapshot.data!.docs;

        return PageView.builder(
          scrollDirection: Axis.vertical,
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final doc = posts[index];
            final data = doc.data() as Map<String, dynamic>;

            return _buildSingleFeedItem(
              postId: doc.id,
              authorName: data['authorName'] ?? 'Community User',
              timeAgo: 'Recently',
              title: data['description'] ?? 'Neighborhood Report',
              description: data['location'] ?? '48th St & Telegraph Ave',
              category: data['category'] ?? 'Roads',
              imageUrl: data['mediaUrl'] ?? 'https://images.unsplash.com/photo-1515162816999-a0c47dc192f7?auto=format&fit=crop&q=80&w=800',
              commentsCount: '${data['reportsCount'] ?? 0}',
              initialLikes: data['likesCount'] ?? 128,
            );
          },
        );
      },
    );
  }

  Widget _buildSingleFeedItem({
    required String postId,
    required String authorName,
    required String timeAgo,
    required String title,
    required String description,
    required String category,
    required String imageUrl,
    required String commentsCount,
    required int initialLikes,
  }) {
    bool isLiked = _likedPosts[postId] ?? false;
    int currentLikes = _supportCounts[postId] ?? initialLikes;

    return Stack(
      children: [
        Positioned.fill(
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(color: Colors.grey.shade300);
            },
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withOpacity(0.9),
                  Colors.transparent,
                  Colors.white.withOpacity(0.8),
                  Colors.white,
                ],
                stops: const [0.0, 0.3, 0.7, 1.0],
              ),
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey.shade300,
                      radius: 16,
                      child: Text(
                        authorName.isNotEmpty ? authorName.substring(0, 1).toUpperCase() : 'U',
                        style: const TextStyle(color: Colors.black, fontSize: 12),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text('$authorName · $timeAgo', style: const TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          Container(width: 6, height: 6, decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle)),
                          const SizedBox(width: 6),
                          const Text('Reported', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text('180 m away · $category', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Community report · Repair not verified', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {},
                  child: const Text(
                    'See updates & help prioritize ➔',
                    style: TextStyle(color: Color(0xFF2962FF), fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        // Action Buttons Column
        Positioned(
          right: 20,
          bottom: 120,
          child: Column(
            children: [
              // 1. Support/Like Button
              GestureDetector(
                onTap: () {
                  setState(() {
                    bool newLikedState = !isLiked;
                    _likedPosts[postId] = newLikedState;
                    _supportCounts[postId] = currentLikes + (newLikedState ? 1 : -1);
                  });
                },
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isLiked ? const Color(0xFF2962FF) : Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.arrow_upward,
                        color: isLiked ? Colors.white : const Color(0xFF2962FF),
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$currentLikes',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    const Text(
                      'Support',
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 11, color: Colors.black54),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 2. Comments Button
              GestureDetector(
                onTap: _showCommentsSheet,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.chat_bubble_outline, color: Colors.black87, size: 24),
                    ),
                    const SizedBox(height: 4),
                    Text(commentsCount, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 3. Share Button
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Report link copied to clipboard!')),
                  );
                },
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.send_outlined, color: Colors.black87, size: 24),
                    ),
                    const SizedBox(height: 4),
                    const Text('Share', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 4. Report Button
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Report flagged for review.')),
                  );
                },
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.flag_outlined, color: Colors.black87, size: 24),
                    ),
                    const SizedBox(height: 4),
                    const Text('Report', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- COMMENTS MODAL SHEET ---
  void _showCommentsSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.65,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Comments',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: const [
                        Text('1.2k', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        Icon(Icons.keyboard_arrow_down, size: 20),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                  children: [
                    _buildCommentItem(
                      name: 'Ian Kyle',
                      timeAgo: '2h',
                      comment: 'This pothole is literally a sinkhole! I almost lost my tire yesterday',
                      likes: '1.2k',
                      avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100',
                    ),
                    _buildCommentItem(
                      name: 'Shan Chris',
                      timeAgo: '5h',
                      comment: 'I reported this to the city 3 weeks ago. Still nothing done',
                      likes: '842',
                      avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
                    ),
                    _buildCommentItem(
                      name: 'Caleb C.',
                      timeAgo: '1h',
                      comment: 'Thank you for reporting! We have dispatched a crew to fix this by Friday',
                      likes: '3.4k',
                      avatarUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100',
                    ),
                  ],
                ),
              ),
              SafeArea(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(top: BorderSide(color: Colors.grey.shade200)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8F7F5),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.sentiment_satisfied_alt, color: Colors.grey.shade500, size: 20),
                              const SizedBox(width: 8),
                              const Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Add a comment...',
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: Color(0xFF2962FF),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_upward, color: Colors.white, size: 20),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCommentItem({
    required String name,
    required String timeAgo,
    required String comment,
    required String likes,
    required String avatarUrl,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage(avatarUrl),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    Text(timeAgo, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  comment,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.thumb_up_outlined, size: 14, color: Colors.black54),
                    const SizedBox(width: 4),
                    Text(likes, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                    const SizedBox(width: 16),
                    const Text('Reply', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- 2. EVENT VIEW ---
  Widget _buildEventView() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.location_on_outlined, color: Color(0xFF2962FF), size: 16),
                SizedBox(width: 4),
                Text(
                  'Temescal, Oakland',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
                Icon(Icons.keyboard_arrow_down, color: Colors.black54, size: 20),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Happening\naround you.',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w900,
                height: 1.1,
                letterSpacing: -0.8,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Your neighborhood is out. Join in.',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('All events', true),
                  const SizedBox(width: 8),
                  _buildFilterChip('Free', false),
                  const SizedBox(width: 8),
                  _buildFilterChip('Music', false),
                  const SizedBox(width: 8),
                  _buildFilterChip('Outdoors', false),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              height: 280,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                  image: NetworkImage('https://images.unsplash.com/photo-1488459716781-31db52582fe9?auto=format&fit=crop&q=80&w=800'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF2962FF) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isSelected ? Colors.transparent : Colors.grey.shade300),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }
}