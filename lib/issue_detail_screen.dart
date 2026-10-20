import 'package:flutter/material.dart';

class IssueDetailSheet extends StatefulWidget {
  const IssueDetailSheet({Key? key}) : super(key: key);

  @override
  State<IssueDetailSheet> createState() => _IssueDetailSheetState();
}

class _IssueDetailSheetState extends State<IssueDetailSheet> {
  bool _isSupported = false;
  int _supportCount = 128;
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7F5),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'The neighborhood report',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Main Photo Preview Banner
                    Container(
                      height: 220,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: const DecorationImage(
                          image: NetworkImage(
                            'https://images.unsplash.com/photo-1515162816999-a0c47dc192f7?auto=format&fit=crop&q=80&w=800',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 12,
                            left: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: const BoxDecoration(
                                      color: Colors.orange,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Reported',
                                    style: TextStyle(
                                      color: Colors.orange.shade900,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 12,
                            right: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.collections_outlined, color: Colors.white, size: 14),
                                  SizedBox(width: 4),
                                  Text(
                                    '1 / 3',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Issue Header
                    const Text(
                      'Pothole on 48th Street',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: const [
                        Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                        SizedBox(width: 4),
                        Text(
                          'Telegraph & 48th · Maya J. · Oct 10',
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Bikes have to swerve into traffic to miss it. The edge is getting deeper after the rain.',
                      style: TextStyle(fontSize: 15, color: Colors.grey.shade800, height: 1.3),
                    ),
                    const SizedBox(height: 20),

                    // Support Button & Counter Row
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  _isSupported = !_isSupported;
                                  _supportCount += _isSupported ? 1 : -1;
                                });
                              },
                              icon: Icon(
                                Icons.north_east,
                                size: 18,
                                color: _isSupported ? const Color(0xFF2962FF) : Colors.white,
                              ),
                              label: Text(
                                _isSupported ? 'Supported' : 'Support this report',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: _isSupported ? const Color(0xFF2962FF) : Colors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _isSupported
                                    ? const Color(0xFFEDF2FF)
                                    : const Color(0xFF2962FF),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEDF2FF),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              Text(
                                '$_supportCount',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2962FF),
                                ),
                              ),
                              const Text(
                                'neighbors',
                                style: TextStyle(fontSize: 10, color: Color(0xFF2962FF)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your support raises visibility. It doesn\'t confirm a repair.',
                      style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                    ),
                    const SizedBox(height: 28),

                    // Repair Progress Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Repair progress',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: const Row(
                            children: [
                              Text(
                                'Add an update',
                                style: TextStyle(
                                  color: Color(0xFF2962FF),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              Icon(Icons.north_east, size: 14, color: Color(0xFF2962FF)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Timeline Progress Indicator
                    Row(
                      children: [
                        _buildTimelineNode('Reported', 'Oct 10 · Maya J.', isDone: true, isFirst: true),
                        _buildTimelineConnector(isDone: false),
                        _buildTimelineNode('In progress', 'Not confirmed', isDone: false),
                        _buildTimelineConnector(isDone: false),
                        _buildTimelineNode('Resolved', 'Awaiting evidence', isDone: false, isLast: true),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, size: 16, color: Colors.grey.shade600),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Community-sourced updates. No repair is verified yet; this is not a city service request.',
                              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Neighbors Are Talking Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [
                            Text(
                              'Neighbors are talking ',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '18',
                              style: TextStyle(fontSize: 18, color: Colors.grey, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: const Text(
                            'View all',
                            style: TextStyle(color: Color(0xFF2962FF), fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Sample Comment Cards
                    _buildCommentTile(
                      avatarText: 'AL',
                      author: 'Alex L.',
                      timeAgo: '3h',
                      content: 'Hit this on my bike yesterday. Thanks for getting it on everyone\'s radar.',
                      likesCount: '1.2k',
                    ),
                    const SizedBox(height: 12),
                    _buildCommentTile(
                      avatarText: 'FG',
                      author: 'FixItGuy',
                      timeAgo: '5h',
                      content: 'I reported this to the city 3 weeks ago. Still nothing done',
                      likesCount: '842',
                    ),
                    const SizedBox(height: 12),
                    _buildCommentTile(
                      avatarText: 'CR',
                      author: 'CityRep',
                      timeAgo: '1h',
                      content: 'Thank you for reporting! We have dispatched a crew to fix this by Friday',
                      likesCount: '3.4k',
                      isOfficial: true,
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Sticky Add Comment Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                      child: TextField(
                        controller: _commentController,
                        decoration: const InputDecoration(
                          hintText: 'Add what you\'ve seen...',
                          hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.sentiment_satisfied_alt, color: Colors.grey, size: 20),
                          prefixIconConstraints: BoxConstraints(minWidth: 32),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: const Color(0xFF2962FF),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_upward, color: Colors.white, size: 18),
                      onPressed: () {
                        if (_commentController.text.isNotEmpty) {
                          _commentController.clear();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Comment posted!')),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineNode(String label, String sublabel, {required bool isDone, bool isFirst = false, bool isLast = false}) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: isDone ? const Color(0xFF2962FF) : Colors.grey.shade300,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isDone ? Icons.check : Icons.circle,
              color: isDone ? Colors.white : Colors.grey.shade500,
              size: 14,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: isDone ? Colors.black87 : Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            sublabel,
            style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineConnector({required bool isDone}) {
    return Container(
      width: 30,
      height: 2,
      color: isDone ? const Color(0xFF2962FF) : Colors.grey.shade300,
    );
  }

  Widget _buildCommentTile({
    required String avatarText,
    required String author,
    required String timeAgo,
    required String content,
    required String likesCount,
    bool isOfficial = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: isOfficial ? const Color(0xFF2962FF) : Colors.grey.shade300,
                    child: Text(
                      avatarText,
                      style: TextStyle(
                        color: isOfficial ? Colors.white : Colors.black87,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    author,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: isOfficial ? const Color(0xFF2962FF) : Colors.black87,
                    ),
                  ),
                ],
              ),
              Text(timeAgo, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          Text(content, style: const TextStyle(fontSize: 13, height: 1.2)),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.thumb_up_alt_outlined, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text(likesCount, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(width: 16),
              const Text('Reply', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}