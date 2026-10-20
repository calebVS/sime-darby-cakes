import 'package:flutter/material.dart';

class PointsTransactionScreen extends StatelessWidget {
  const PointsTransactionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7F5),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF2962FF)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Profile',
          style: TextStyle(color: Color(0xFF2962FF), fontSize: 16),
        ),
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Points Transaction',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 20),

            // Available Points Blue Header Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFEDF2FF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Your available points',
                        style: TextStyle(fontSize: 13, color: Colors.black54),
                      ),
                      SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '1,250',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(width: 6),
                          Text(
                            'pts',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Small actions. Well-earned rewards.',
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      color: Color(0xFF2962FF),
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Transaction History Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Transaction history',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Newest first',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            const Text(
              'October 2026',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 12),

            // Transaction List
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  _buildTransactionTile(
                    icon: Icons.check_circle_outline,
                    iconColor: Color(0xFF2962FF),
                    title: 'Report verified',
                    subtitle: '17 Oct · Oak Street pothole',
                    pts: '+100',
                    ptsSub: 'Earned',
                    isPositive: true,
                  ),
                  const Divider(height: 1),
                  _buildTransactionTile(
                    icon: Icons.people_outline,
                    iconColor: Color(0xFF2962FF),
                    title: 'Neighborhood cleanup',
                    subtitle: '15 Oct · Community contribution',
                    pts: '+250',
                    ptsSub: 'Earned',
                    isPositive: true,
                  ),
                  const Divider(height: 1),
                  _buildTransactionTile(
                    icon: Icons.card_giftcard,
                    iconColor: Colors.grey,
                    title: 'Starbucks · \$5 gift card',
                    subtitle: '12 Oct · Reward claimed',
                    pts: '-500',
                    ptsSub: 'Redeemed',
                    isPositive: false,
                  ),
                  const Divider(height: 1),
                  _buildTransactionTile(
                    icon: Icons.check_circle_outline,
                    iconColor: Color(0xFF2962FF),
                    title: 'Issue resolved bonus',
                    subtitle: '8 Oct · Park lighting repaired',
                    pts: '+300',
                    ptsSub: 'Earned',
                    isPositive: true,
                  ),
                  const Divider(height: 1),
                  _buildTransactionTile(
                    icon: Icons.chat_bubble_outline,
                    iconColor: Color(0xFF2962FF),
                    title: 'Helpful update',
                    subtitle: '3 Oct · Elm Street report',
                    pts: '+100',
                    ptsSub: 'Earned',
                    isPositive: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Balance on 1 Oct', style: TextStyle(color: Colors.grey, fontSize: 12)),
                Text('1,000 pts', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String pts,
    required String ptsSub,
    required bool isPositive,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                pts,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isPositive ? const Color(0xFF2962FF) : Colors.black87,
                ),
              ),
              Text(
                ptsSub,
                style: const TextStyle(color: Colors.grey, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }
}