import 'package:flutter/material.dart';
import 'feed_and_events_screen.dart';
import 'capture_report_sheet.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const FeedAndEventsScreen(),
    const Center(child: Text('Nearby Map Screen')),
    const SizedBox(), // Placeholder for Report modal trigger
    const Center(child: Text('Rewards Screen')),
    const Center(child: Text('Profile Screen')),
  ];

  void _onTabTapped(int index) {
    if (index == 2) {
      _showReportSheet();
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  void _showReportSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CaptureReportSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade200, width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF2962FF),
          unselectedItemColor: Colors.black87,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          elevation: 0,
          items: [
            // 1. Feed (Stacked Layers Icon)
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Icon(
                  Icons.layers_outlined,
                  color: _currentIndex == 0 ? const Color(0xFF2962FF) : Colors.black87,
                  size: 24,
                ),
              ),
              label: 'Feed',
            ),
            // 2. Nearby (Map Icon)
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Icon(
                  Icons.map_outlined,
                  color: _currentIndex == 1 ? const Color(0xFF2962FF) : Colors.black87,
                  size: 24,
                ),
              ),
              label: 'Nearby',
            ),
            // 3. Report (Blue Pill "+" Button)
            BottomNavigationBarItem(
              icon: Container(
                margin: const EdgeInsets.only(bottom: 2.0),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF2962FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 20),
              ),
              label: 'Report',
            ),
            // 4. Rewards (Gift Box Icon)
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Icon(
                  Icons.card_giftcard_outlined,
                  color: _currentIndex == 3 ? const Color(0xFF2962FF) : Colors.black87,
                  size: 24,
                ),
              ),
              label: 'Rewards',
            ),
            // 5. Profile (Person Outline Icon)
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Icon(
                  Icons.person_outline,
                  color: _currentIndex == 4 ? const Color(0xFF2962FF) : Colors.black87,
                  size: 24,
                ),
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}