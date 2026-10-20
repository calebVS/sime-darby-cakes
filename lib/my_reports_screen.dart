import 'package:flutter/material.dart';

class MyReportsScreen extends StatefulWidget {
  const MyReportsScreen({Key? key}) : super(key: key);

  @override
  State<MyReportsScreen> createState() => _MyReportsScreenState();
}

class _MyReportsScreenState extends State<MyReportsScreen> {
  int _selectedTabIndex = 0; // 0: All, 1: Open, 2: Resolved

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'My reports',
                        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Maya J. · Your corner of Temescal',
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  ),
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.black12,
                    child: Text('MJ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Overview Stats Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E232A),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem('3', 'Reports shared'),
                    _buildStatItem('184', 'Total support'),
                    _buildStatItem('1', 'Resolved'),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Interactive Filter Tabs
              Row(
                children: [
                  _buildTabChip(0, 'All', '3'),
                  const SizedBox(width: 8),
                  _buildTabChip(1, 'Open', '2'),
                  const SizedBox(width: 8),
                  _buildTabChip(2, 'Resolved', '1'),
                ],
              ),
              const SizedBox(height: 16),

              // Report Items
              if (_selectedTabIndex == 0 || _selectedTabIndex == 1) ...[
                _buildReportCard(
                  status: 'Reported',
                  statusColor: Colors.orange,
                  title: 'Pothole on 48th Street',
                  location: '48th & Telegraph · Oct 10',
                  supportCount: '128',
                  footerText: 'Awaiting the first repair update',
                  imageUrl: 'https://images.unsplash.com/photo-1515162816999-a0c47dc192f7?auto=format&fit=crop&q=80&w=200',
                ),
                const SizedBox(height: 12),
                _buildReportCard(
                  status: 'In progress',
                  statusColor: const Color(0xFF2962FF),
                  title: 'Streetlight on Telegraph',
                  location: 'Telegraph & 51st · Oct 8',
                  supportCount: '34',
                  footerText: 'Crew seen by Nina · not verified',
                  imageUrl: 'https://images.unsplash.com/photo-1509114397022-ed747cca3f65?auto=format&fit=crop&q=80&w=200',
                ),
                const SizedBox(height: 12),
              ],

              if (_selectedTabIndex == 0 || _selectedTabIndex == 2) ...[
                _buildReportCard(
                  status: 'Resolved',
                  statusColor: Colors.green,
                  title: 'Dumping on Shattuck',
                  location: 'Shattuck & 46th · Oct 3',
                  supportCount: '22',
                  footerText: 'Photo-confirmed by 2 neighbors',
                  imageUrl: 'https://images.unsplash.com/photo-1532996122724-e3c354a0b15b?auto=format&fit=crop&q=80&w=200',
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String count, String label) {
    return Column(
      children: [
        Text(count, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
      ],
    );
  }

  Widget _buildTabChip(int index, String label, String count) {
    bool isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTabIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2962FF) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? Colors.transparent : Colors.grey.shade300),
        ),
        child: Text(
          '$label $count',
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildReportCard({
    required String status,
    required Color statusColor,
    required String title,
    required String location,
    required String supportCount,
    required String footerText,
    required String imageUrl,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(imageUrl, width: 70, height: 70, fit: BoxFit.cover),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            status,
                            style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.arrow_upward, size: 12, color: Color(0xFF2962FF)),
                            Text(supportCount, style: const TextStyle(color: Color(0xFF2962FF), fontWeight: FontWeight.bold, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    Text(location, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(footerText, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              const Icon(Icons.chevron_right, color: Colors.grey, size: 18),
            ],
          ),
        ],
      ),
    );
  }
}